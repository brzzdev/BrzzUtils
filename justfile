# Repo-scoped rather than the bare /tmp/swiftformat-base every repo in the family
# shares: two checkouts on different config revisions otherwise fight over one
# file, and each overwrites the other's config mid-commit.
swiftformat_base := "/tmp/swiftformat-base-BrzzUtils"
swiftformat_url := "https://raw.githubusercontent.com/brzzdev/Configs/main/Configs/swiftformat"

# Build the package
build:
    set -o pipefail && xcodebuild build \
        -scheme BrzzUtils-Package \
        -destination "platform=macOS" \
        | xcbeautify

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
    mint run swiftformat . --base-config {{ swiftformat_base }}

[private]
format-staged: fetch-swiftformat-config
    #!/usr/bin/env bash
    # `mint which` writes the path to stdout and its failures to stderr, so piping
    # it into `tail` without pipefail swallows a 127 and yields an empty string. The
    # formatter command would then start with a bare ` stdin`, and the pre-commit
    # hook would pass while formatting nothing at all. The assignment sits in the
    # `if` condition so `set -e` does not abort on it before the message is printed.
    set -euo pipefail

    if ! formatter="$(mint which swiftformat | tail -1)" || [ -z "$formatter" ]; then
        echo "swiftformat not installed — run \`just tools\`." >&2
        exit 1
    fi

    git-format-staged \
        --formatter "$formatter stdin --stdinpath '{}' --base-config {{ swiftformat_base }}" \
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
    mint run swift-outdated

# Place pre-commit hook locally
pre-commit:
    cp .scripts/pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit

# Run tests
test:
    set -o pipefail && xcodebuild test \
        -scheme BrzzUtils-Package \
        -destination "platform=macOS" \
        | xcbeautify

# Install developer tools
tools:
    #!/usr/bin/env bash
    set -euo pipefail

    # The installer is fetched into a variable first so a failed download stops
    # here, rather than running the empty string, reporting success and leaving
    # `brew: command not found` two lines later to explain itself. It also cannot
    # put brew on the PATH of the shell that invoked it, and on Apple Silicon brew
    # lands in /opt/homebrew, which is on no default PATH — hence `shellenv`.
    # `shellenv bash` rather than a bare one, which emits zsh array syntax.
    if ! command -v brew >/dev/null; then
        installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        /bin/bash -c "$installer"
        for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            [ -x "$brew_bin" ] || continue
            eval "$("$brew_bin" shellenv bash)"
            break
        done
    fi

    if ! command -v brew >/dev/null; then
        echo 'Homebrew is installed but not on PATH. Add `eval "$(brew shellenv)"` to your shell profile, then re-run.' >&2
        exit 1
    fi

    # No `brew tap Homebrew/bundle`: bundle is part of brew itself now, the tap is
    # empty, and tapping it exits 1 — which aborted this recipe before it ever
    # reached the Brewfile.
    brew bundle install
    mint bootstrap
    just pre-commit