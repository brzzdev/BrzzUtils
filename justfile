set default-list

# Xcode's default DerivedData path is hashed, so its object files have no stable location.
release_derived_data := ".build/release"
release_products := justfile_directory() / release_derived_data / "Build/Products/Release"
scheme := "BrzzUtils-Package"

# Repo-scoped rather than the bare /tmp/swiftformat-base every repo in the family
# shares: two checkouts on different config revisions otherwise fight over one
# file, and each overwrites the other's config mid-commit.
swiftformat_base := "/tmp/swiftformat-base-BrzzUtils"
swiftformat_url := "https://raw.githubusercontent.com/brzzdev/Configs/main/Swift/swiftformat"

# Build the package
build: (build-for "platform=macOS")

[private]
build-for destination *args:
    set -o pipefail && xcodebuild build \
        -scheme {{ scheme }} \
        -destination {{ quote(destination) }} \
        {{ args }} \
        | xcbeautify

# Build the package for a generic iOS device, no simulator needed
build-ios: (build-for "generic/platform=iOS")

# Build the package in Release for macOS, printing where its object files land
build-release: (build-for "platform=macOS" "-configuration" "Release" "-derivedDataPath" release_derived_data)
    @echo {{ quote(release_products) }}

# Fetched rather than vendored, but at most once a day: this is a dependency of
# `format-staged`, which the pre-commit hook runs on every commit, so an
# unconditional fetch would put GitHub on the commit path.
#
# `-f` is load-bearing. Without it curl exits 0 on a 404 and writes the error body
# into the config file, and swiftformat then reformats the whole tree against
# `404: Not Found` from inside the pre-commit hook — silently, since the hook
# stays green. Verified.
[private]
fetch-swiftformat-config:
    #!/usr/bin/env bash
    set -euo pipefail

    # Fresh enough: nothing to do. `find -mmin` is a single stat on one file.
    if [ -n "$(find {{ swiftformat_base }} -mmin -1440 2>/dev/null)" ]; then
        exit 0
    fi

    # Per-invocation, because the cache path is shared by every clone and worktree
    # of this repo. Given a single hardcoded temp name instead, two concurrent hooks
    # write the same file, the first `mv` hands the half-written result over as the
    # live config, and the second `mv` then fails on a name that is already gone.
    # The trap covers every exit below, so no temp file outlives the recipe.
    #
    # `mv` carries the temp file's mode across, so the cache lands 0600 rather than
    # the 0644 `curl -o` gave it under the default umask. That is the right way
    # round for a per-user cache sitting in a world-writable directory.
    tmp="$(mktemp {{ swiftformat_base }}.XXXXXX)"
    trap 'rm -f "$tmp"' EXIT

    if curl -sfL --retry 2 --max-time 10 {{ swiftformat_url }} -o "$tmp"; then
        # Same filesystem, so this is an atomic rename: a concurrent reader sees the
        # old config or the new one, never a partial write.
        mv "$tmp" {{ swiftformat_base }}
        exit 0
    fi

    # Offline, or the config moved. A stale copy still formats correctly enough to
    # commit against; no copy at all cannot, so that is the one hard failure.
    if [ ! -f {{ swiftformat_base }} ]; then
        echo "cannot reach {{ swiftformat_url }} and no cached config at {{ swiftformat_base }}." >&2
        exit 1
    fi

    # The mtime records the last *attempt*, not when the contents arrived. Without
    # this a failed refresh leaves the stale copy stale, so every commit from here
    # on reaches the curl above and an offline one pays the timeout each time —
    # exactly what the daily cache exists to prevent. Nothing reads this mtime but
    # the staleness test at the top.
    touch {{ swiftformat_base }}

# Format Swift sources
format: fetch-swiftformat-config
    swiftformat . --base-config {{ swiftformat_base }}

[private]
format-staged: fetch-swiftformat-config
    git-format-staged \
        --formatter "swiftformat stdin --stdinpath '{}' --base-config {{ swiftformat_base }}" \
        "*.swift"

# Fail on a SwiftLint violation, or on the shared config going missing
lint:
    # `--config` is load-bearing, not decoration. With the config merely
    # discovered, SwiftLint treats a failed `parent_config` fetch as a warning,
    # falls back to its own built-in defaults and exits 0 — a gate that lints
    # nothing we asked for. Naming the file explicitly takes SwiftLint's
    # "explicitly specified ... -> fail" path instead. Verified on 0.65.1:
    # identical rule set (260 rows of `swiftlint rules`), exit 134 when the
    # config cannot load, and still exit 0 when it falls back to a cached copy
    # of our own config.
    #
    # Pass this one file, not the parent and child separately: two `--config`
    # arguments silently resolve to a *different* rule set — measured, 172 rows
    # of that table flip. The local overrides are inlined into `.swiftlint.yml`
    # for the same reason a second file is a liability: a referenced local
    # config that goes missing is ignored with a warning and a zero exit.
    swiftlint --strict --config .swiftlint.yml
# Show outdated Swift packages
outdated:
    swift-outdated

# Place pre-commit hook locally
pre-commit:
    cp .scripts/pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit

# Fail when BrzzUtils' required-reason API categories differ from its privacy manifest's
privacy-audit: build-release
    #!/usr/bin/env bash
    set -euo pipefail

    # Apple's required-reason APIs as `nm -u` names them, copied from
    # https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api.
    # Swift's wrappers reference these same symbols, so none needs its mangled name.
    # getattrlist, fgetattrlist, and getattrlistat read timestamps and disk space alike, so
    # they count towards both.
    required_reason_symbols='
    NSPrivacyAccessedAPICategoryActiveKeyboards _objc_msgSend$activeInputModes
    NSPrivacyAccessedAPICategoryDiskSpace _NSFileSystemFreeSize
    NSPrivacyAccessedAPICategoryDiskSpace _NSFileSystemSize
    NSPrivacyAccessedAPICategoryDiskSpace _NSURLVolumeAvailableCapacityForImportantUsageKey
    NSPrivacyAccessedAPICategoryDiskSpace _NSURLVolumeAvailableCapacityForOpportunisticUsageKey
    NSPrivacyAccessedAPICategoryDiskSpace _NSURLVolumeAvailableCapacityKey
    NSPrivacyAccessedAPICategoryDiskSpace _NSURLVolumeTotalCapacityKey
    NSPrivacyAccessedAPICategoryDiskSpace _fgetattrlist
    NSPrivacyAccessedAPICategoryDiskSpace _fstatfs
    NSPrivacyAccessedAPICategoryDiskSpace _fstatvfs
    NSPrivacyAccessedAPICategoryDiskSpace _getattrlist
    NSPrivacyAccessedAPICategoryDiskSpace _getattrlistat
    NSPrivacyAccessedAPICategoryDiskSpace _statfs
    NSPrivacyAccessedAPICategoryDiskSpace _statvfs
    NSPrivacyAccessedAPICategoryFileTimestamp _NSFileCreationDate
    NSPrivacyAccessedAPICategoryFileTimestamp _NSFileModificationDate
    NSPrivacyAccessedAPICategoryFileTimestamp _NSURLContentModificationDateKey
    NSPrivacyAccessedAPICategoryFileTimestamp _NSURLCreationDateKey
    NSPrivacyAccessedAPICategoryFileTimestamp _fgetattrlist
    NSPrivacyAccessedAPICategoryFileTimestamp _fstat
    NSPrivacyAccessedAPICategoryFileTimestamp _fstatat
    NSPrivacyAccessedAPICategoryFileTimestamp _getattrlist
    NSPrivacyAccessedAPICategoryFileTimestamp _getattrlistat
    NSPrivacyAccessedAPICategoryFileTimestamp _getattrlistbulk
    NSPrivacyAccessedAPICategoryFileTimestamp _lstat
    NSPrivacyAccessedAPICategoryFileTimestamp _objc_msgSend$fileModificationDate
    NSPrivacyAccessedAPICategoryFileTimestamp _stat
    NSPrivacyAccessedAPICategorySystemBootTime _mach_absolute_time
    NSPrivacyAccessedAPICategorySystemBootTime _objc_msgSend$systemUptime
    NSPrivacyAccessedAPICategoryUserDefaults _OBJC_CLASS_$_NSUserDefaults
    '

    # awk reads the `nm -u` symbols first, then keeps each table row whose symbol is among them.
    referenced_rows="$(
        nm -u {{ quote(release_products / "BrzzUtils.o") }} \
            | awk 'NR == FNR { undefined[$1]; next } $2 in undefined' - <(printf '%s\n' "$required_reason_symbols")
    )"
    referenced_categories="$(awk '{ print $1 }' <<<"$referenced_rows" | sort -u)"

    manifest=Sources/BrzzUtils/PrivacyInfo.xcprivacy
    count="$(plutil -extract NSPrivacyAccessedAPITypes raw -expect array -o - "$manifest")"
    # `set -e` doesn't reach inside the substitution, so a failed entry exits it explicitly.
    declared_categories="$(
        for ((i = 0; i < count; i++)); do
            plutil -extract "NSPrivacyAccessedAPITypes.$i.NSPrivacyAccessedAPIType" raw -expect string -o - "$manifest" || exit
        done | sort -u
    )"

    undeclared="$(comm -23 <(printf '%s\n' "$referenced_categories") <(printf '%s\n' "$declared_categories"))"
    stale="$(comm -13 <(printf '%s\n' "$referenced_categories") <(printf '%s\n' "$declared_categories"))"
    for category in $undeclared; do
        symbols="$(awk -v category="$category" '$1 == category { print $2 }' <<<"$referenced_rows" | paste -sd ' ' -)"
        echo "undeclared: $category, referenced by $symbols" >&2
    done
    for category in $stale; do
        echo "stale: $category is declared but never referenced" >&2
    done
    [ -z "$undeclared$stale" ]

# Run tests
test:
    set -o pipefail && xcodebuild test \
        -scheme {{ scheme }} \
        -destination "platform=macOS" \
        | xcbeautify

# Run tests on the pinned iOS simulator; extra arguments go to xcodebuild
test-ios *args:
    set -o pipefail && xcodebuild test \
        -scheme {{ scheme }} \
        -destination "platform=iOS Simulator,name=iPhone 18 Pro,OS=27.0" \
        {{ args }} \
        | xcbeautify

# Install developer tools
tools:
    mise install
    just pre-commit
