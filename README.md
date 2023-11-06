# PWR Manager Installation and Updater Script

This script simplifies the installation and management of the PWR Manager service, which runs a the PWR java Validator nodes and manages it as a systemd service. It automatically updates the service with the user's external IP address and separates standard output and standard error into separate log files.

## Features

- Automatically pulls the last Validator Node .jar
- Automatic update of the service with the user's external IP address.
- Separate log files for standard output and standard error.
- Automatically installs the required java version

## Prerequisites

- A Linux system with `systemd` support.

## Installation

1. Download the script:

   ```bash
   wget https://github.com/AuroraRyunix/PWR-manager/blob/main/PWR_manager_installer_updater.sh
   wget https://github.com/AuroraRyunix/PWR-manager/blob/main/install_java.sh
   ```

2. Make the script executable:

   ```bash
   sudo chmod +x PWR_manager_installer_updater.sh
   ```

3. Run the script with root privileges:

   ```bash
   sudo sh PWR_manager_installer_updater.sh
   ```

4. Follow the on-screen instructions to set your password. Then restart the service
   ```bash
   sudo systemctl restart PWR_manager
   ```

## Usage

Once the script has been run, the PWR Manager service will be installed and started as a systemd service. You can manage the service using standard `systemctl` commands:

- Start the service: `sudo systemctl start PWR_manager`
- Stop the service: `sudo systemctl stop PWR_manager`
- Restart the service: `sudo systemctl restart PWR_manager`
- Check the service status: `sudo systemctl status PWR_manager`

## Customization

- You can customize the JAR file URL, service name, and description in the script.
- The script assumes the `java` executable is available. If not, it can be installed using your system's package manager.
- The location of the service files and output directories can be customized in the script.

## Contributing

Contributions are welcome! Feel free to open an issue or create a pull request.


- Inspired by [PWR Labs](https://github.com/pwrlabs).


Customize this template by replacing placeholders like `your-repo`, `Your Name`, and any other details specific to your project. Additionally, you can expand the documentation with more information about the project's features, usage, and customization options.