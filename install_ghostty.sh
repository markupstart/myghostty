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

# Install Zig
echo "Downloading and installing Zig 0.13.0..."
ZIG_URL="https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz"
cd $TMP_DIR
wget $ZIG_URL
tar -xf zig-linux-x86_64-0.13.0.tar.xz
sudo mv zig-linux-x86_64-0.13.0 /usr/local/zig
sudo ln -sf /usr/local/zig/zig /usr/local/bin/zig

# Verify Zig installation
echo "Checking Zig version..."
zig version || { echo "Zig installation failed!"; exit 1; }

# Install Ghostty
echo "Cloning and building Ghostty..."
git clone https://github.com/ghostty-org/ghostty
cd ghostty
sudo zig build -p /usr -Doptimize=ReleaseFast

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -rf $TMP_DIR

echo "Ghostty installation completed successfully!"
