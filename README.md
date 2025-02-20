> [!IMPORTANT]  
> The script is **NOT** installing the latest version of ghostty.  The commit for Debian/Ubuntu currently working (02/20/2025) is 1.1.3-HEAD+f1f11207.

## Ghostty Installation Script for Debian 12

This script automates the installation of **Ghostty** on Debian 12 using source files. It installs necessary dependencies, downloads and installs **Zig 0.13.0**, and builds **Ghostty** from source. It also ensures a clean installation by removing temporary files after the process.

## Prerequisites

- Debian 12 (or a similar Debian-based distribution)
- A user with `sudo` privileges

## Installation Steps

### 1. Clone the repository

Clone the repository containing this script to your local machine:

```bash
git clone https://github.com/drewgrif/myghostty
cd myghostty
```

### 2. Make the script executable

Change the permissions to make the script executable:

```bash
chmod +x install-ghostty.sh
```

### 3. Run the script

Execute the script to install **Ghostty** and its dependencies:

```bash
./install-ghostty.sh
```

The script will:

1. Install the necessary dependencies (`libgtk-4-dev`, `libadwaita-1-dev`, `git`).
2. Download and install **Zig 0.13.0**.
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


> [!TIP]
> If you are getting an error using ```clear``` or ```CTRL+L``` command in SSH, look at SSH https://ghostty.org/docs/help/terminfo#ssh

> [!SOLUTION]
> ```infocmp -x | ssh YOUR-SERVER -- tic -x -```


![2025-01-22_18-55](https://github.com/user-attachments/assets/6879a35c-a609-4215-9c52-674c64b46683)
