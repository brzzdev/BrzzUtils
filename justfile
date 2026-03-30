swiftformat_base := "/tmp/swiftformat-base"

# Build the package
build:
    set -o pipefail && xcodebuild build \
        -scheme BrzzUtils-Package \
        -destination "platform=macOS" \
        | xcbeautify

[private]
fetch-swiftformat-config:
    curl -sL https://raw.githubusercontent.com/brzzdev/Configs/main/Configs/swiftformat -o {{ swiftformat_base }}

# Format Swift sources
format: fetch-swiftformat-config
    mint run swiftformat . --base-config {{ swiftformat_base }}

[private]
format-staged: fetch-swiftformat-config
    ./.git-format-staged --formatter "$(mint which swiftformat 2>/dev/null | tail -1) stdin --stdinpath '{}' --base-config {{ swiftformat_base }}" "*.swift"

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
    which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew tap Homebrew/bundle
    brew bundle --no-lock install
    mint bootstrap
    just pre-commit