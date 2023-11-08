# PWR Manager Installation and Updater Script

This script simplifies the installation and management of the PWR Manager service, which runs a the PWR java Validator nodes and manages it as a systemd service. It automatically updates the service with the user's external IP address and separates standard output and standard error into separate log files.

example setup:
https://youtu.be/U93-pU9Czeg

## Features

- Automatically installs the required java version
- Automatically pulls the last Validator Node .jar
- Automatic update of the service with the user's external IP address.
- Separate log files for standard output and standard error.
- Asks for a password and automatically starts the service

## Prerequisites

- A Linux system with `systemd` support.
- for auto java installation, either:
  `ubuntu, debian, arch, fedora, rhel9`

## Installation

1. Download the script:

   ```bash
   wget https://raw.githubusercontent.com/AuroraRyunix/PWR-manager/main/PWR_manager_installer_updater.sh
   ```
   
3. Make the script executable:

   ```bash
   sudo chmod +x PWR_manager_installer_updater.sh
   ```

4. Run the script with root privileges:

   ```bash
   sudo sh PWR_manager_installer_updater.sh
   ```



## Usage

Once the script has been run, the PWR Manager service will be installed and started as a systemd service. You can manage the service using standard `systemctl` commands:

- Start the service: `sudo systemctl start PWR_manager`
- Stop the service: `sudo systemctl stop PWR_manager`
- Restart the service: `sudo systemctl restart PWR_manager`
- Check the service status: `sudo systemctl status PWR_manager`
- All files are located under `"home directory"/PWR_manager`

## Customization

- You can customize the JAR file URL, service name, and description in the script.
- The script assumes the `java` executable is available. If not, it will try to automatically install the corect version.
- The location of the service files and output directories can be customized in the script.

## Uninstalling

-unistalling will not remove the node files

   either run:
   ```bash
   sudo sh PWR_manager_installer_updater.sh --uninstall
   ```
   or manually remove the service using:
   ```bash
   sudo systemctl stop PWR_manager
   sudo systemctl disable PWR_manager
   sudo rm /etc/systemd/system/PWR_manager.service
   ```



## Contributing

Contributions are welcome! Feel free to open an issue or create a pull request.


- Inspired by [PWR Labs](https://github.com/pwrlabs).

