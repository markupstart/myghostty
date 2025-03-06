#!/bin/bash

set -e

# Configurable Ghostty version — can be passed as first argument or defaults to v1.1.2
GHOSTTY_VERSION="${1:-v1.1.2}"

ZIG_REQUIRED_VERSION="0.13.0"
ZIG_BINARY="/usr/local/bin/zig"

# Cleanup function to remove temporary files on exit
cleanup() {
    if [[ -d "$TMP_DIR" ]]; then
        echo "Cleaning up temporary files..."
        sudo rm -rf "$TMP_DIR"
    fi
}
trap cleanup EXIT

# Install dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y libgtk-4-dev libadwaita-1-dev git blueprint-compiler

# Create temporary directory
TMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TMP_DIR"

# Compare Zig versions to ensure installed version is >= 0.13.0
check_zig_version() {
    local installed_version
    installed_version=$(zig version 2>/dev/null || echo "0.0.0")

    # Sort versions and ensure installed >= required
    if [ "$(printf '%s\n' "$ZIG_REQUIRED_VERSION" "$installed_version" | sort -V | head -n1)" == "$ZIG_REQUIRED_VERSION" ]; then
        return 0
    else
        return 1
    fi
}

# Determine architecture (x86_64 or aarch64)
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ZIG_ARCH="x86_64" ;;
    aarch64) ZIG_ARCH="aarch64" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Install Zig if not present or outdated
if command -v zig &> /dev/null && check_zig_version; then
    echo "Zig $ZIG_REQUIRED_VERSION or newer is already installed."
else
    echo "Downloading and installing Zig $ZIG_REQUIRED_VERSION for $ZIG_ARCH..."
    ZIG_URL="https://ziglang.org/download/$ZIG_REQUIRED_VERSION/zig-linux-$ZIG_ARCH-$ZIG_REQUIRED_VERSION.tar.xz"
    cd "$TMP_DIR"
    wget "$ZIG_URL"
    tar -xf "zig-linux-$ZIG_ARCH-$ZIG_REQUIRED_VERSION.tar.xz"

    sudo rm -rf /usr/local/zig
    sudo mv "zig-linux-$ZIG_ARCH-$ZIG_REQUIRED_VERSION" /usr/local/zig
    sudo ln -sf /usr/local/zig/zig /usr/local/bin/zig

    echo "Zig $ZIG_REQUIRED_VERSION installed successfully."
fi

# Verify Zig installation
echo "Verifying Zig installation..."
zig version || { echo "Zig installation failed!"; exit 1; }

# Clone and build Ghostty if not already installed
if command -v ghostty &> /dev/null; then
    echo "Ghostty already installed. Skipping clone and build."
else
    echo "Cloning and building Ghostty version $GHOSTTY_VERSION..."
    cd "$TMP_DIR"
    git clone https://github.com/ghostty-org/ghostty.git
    cd ghostty
    git -c advice.detachedHead=false checkout "$GHOSTTY_VERSION"

    # Build and install
    zig build -Doptimize=ReleaseFast
    sudo install -Dm755 zig-out/bin/ghostty /usr/local/bin/ghostty

    echo "Ghostty $GHOSTTY_VERSION installed successfully."
fi

# Ensure ~/.config/ghostty directory exists
mkdir -p "$HOME/.config/ghostty"

# Create a default config file if not present
CONFIG_FILE="$HOME/.config/ghostty/config"
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Creating basic ghostty config at $CONFIG_FILE..."
    cat <<EOF > "$CONFIG_FILE"
# Ghostty configuration file
# Customize this to your liking
EOF
else
    echo "Ghostty config already exists at $CONFIG_FILE."
fi

echo "Ghostty installation complete!"
