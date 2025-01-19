#!/bin/bash

# Set up error handling
set -e

# Dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y libgtk-4-dev libadwaita-1-dev git

# Create a temporary directory for the build
TMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TMP_DIR"

# Check if Zig is installed and the version is 0.13.0 or higher
ZIG_REQUIRED_VERSION="0.13.0"
ZIG_BINARY="/usr/local/bin/zig"
check_zig_version() {
    local installed_version
    installed_version=$(zig version 2>/dev/null || echo "0.0.0")
    if [ "$(printf '%s\n' "$ZIG_REQUIRED_VERSION" "$installed_version" | sort -V | head -n1)" == "$ZIG_REQUIRED_VERSION" ]; then
        return 0
    else
        return 1
    fi
}

if command -v zig &> /dev/null && check_zig_version; then
    echo "Zig $ZIG_REQUIRED_VERSION or higher is already installed. Skipping installation."
else
    echo "Downloading and installing Zig $ZIG_REQUIRED_VERSION..."
    ZIG_URL="https://ziglang.org/download/$ZIG_REQUIRED_VERSION/zig-linux-x86_64-$ZIG_REQUIRED_VERSION.tar.xz"
    cd $TMP_DIR
    wget $ZIG_URL
    tar -xf zig-linux-x86_64-$ZIG_REQUIRED_VERSION.tar.xz
    sudo mv zig-linux-x86_64-$ZIG_REQUIRED_VERSION /usr/local/zig
    sudo ln -sf /usr/local/zig/zig /usr/local/bin/zig
    echo "Zig $ZIG_REQUIRED_VERSION installed successfully."
fi

# Verify Zig installation
echo "Checking Zig version..."
zig version || { echo "Zig installation failed!"; exit 1; }

# Check if Ghostty is installed
if command -v ghostty &> /dev/null; then
    echo "Ghostty is already installed. Skipping installation."
else
    echo "Cloning and building Ghostty..."
    git clone https://github.com/ghostty-org/ghostty
    cd ghostty
    sudo zig build -p /usr -Doptimize=ReleaseFast
    echo "Ghostty installed successfully."
fi

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -rf $TMP_DIR

echo "Installation process completed successfully!"
