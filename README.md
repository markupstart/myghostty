> [!IMPORTANT]  
> The script is **NOT** installing the latest tagged version of ghostty, instead it's getting the Nightly Tip.
> 
## Ghostty Installation Script for Debian 13

This script automates the installation of **Ghostty** on Debian 13 using source files. It installs necessary dependencies, downloads and installs **Zig 0.14.0**, and builds **Ghostty** from source. It also ensures a clean installation by removing temporary files after the process.

## Prerequisites

- Debian 13 (or a similar Debian-based distribution)
- A user with `sudo` privileges

### Make the script executable

Change the permissions to make the script executable:

```bash
chmod +x install_ghostty.sh
```

### 3. Run the script

Execute the script to install **Ghostty** and its dependencies:

```bash
./install_ghostty.sh
```

The script will:

1. Install the necessary dependencies.
2. Download and install **Zig 0.14.0**.
3. Clone the **Ghostty** repository from GitHub.
4. Build and install **Ghostty** with optimization for performance.
5. Clean up temporary files after the installation is complete.

### 4. Verify the installation

To verify that **Zig** has been installed successfully:

```bash
zig version
```

To verify **Ghostty** has been installed correctly, you can check if it is executable or check the installation paths based on your build setup.

## Cleaning Up

The script automatically removes all temporary files used during the installation process to keep your system clean.

## Troubleshooting

If you encounter any issues:

- Make sure your system has access to the required repositories and internet access for downloading dependencies and source files.
- Check if `zig` is available in your PATH with `which zig` or `zig version`.
- Review the logs printed during the script execution for any error messages.
