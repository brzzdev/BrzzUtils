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
        -scheme BrzzUtils \
        -destination "platform=macOS" \
        | xcbeautify

# Install developer tools
tools:
	curl -o ./.swiftformat https://raw.githubusercontent.com/brzzdev/Configs/main/Configs/swiftformat
	which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew tap Homebrew/bundle
	brew bundle --no-lock install
	mint bootstrap
	just pre-commit