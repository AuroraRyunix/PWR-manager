# PWR Manager Installation and Updater Script

This script simplifies the installation and management of the PWR Manager service, which runs a the PWR java Validator nodes and manages it as a systemd service. It automatically updates the service with the user's external IP address and separates standard output and standard error into separate log files.

- Automatically installs the required java version
- Automatically installs curl and wget (manual installation is recommended)
- Automatically pulls the last Validator Node .jar
- Automatic update of the service with the user's external IP address.
- Separate log files for standard output and standard error.
- Keeps the logs at 5MB max, automatically rotates to keep the last info.
- Creates backups every update
- Asks for a password and automatically starts the service
- Tries to add firewall exceptions for both ports, works with most types (firewalld, firewall-cmd, ...)

## Prerequisites

- A Linux system with `systemd` support.
- WGET and CURL installed! (the script will try to auto install these if these aren't installed)
- For auto java installation, either (derivative systems may or may not work):
  `ubuntu, debian, arch, fedora, rhel, centos, rocky linux`

## Example videos:
- [installation](https://youtu.be/oCrFdcO_pjU) 
- [uninstallation](https://youtu.be/iHhVLCCmBwQ)
## Automatic Installation

1. Automatically download and run the script:

   ```bash
   wget -q https://raw.githubusercontent.com/AuroraRyunix/PWR-manager/main/PWR_manager_installer_updater.sh ; wget -q https://raw.githubusercontent.com/AuroraRyunix/PWR-manager/main/PWR_manager_update_firewall.sh ; sudo chmod +x PWR_manager_installer_updater.sh ; sudo sh PWR_manager_installer_updater.sh ; rm PWR_manager_*.sh
   ```
   

## Manual Installation

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

## Firewall

1. If you're using any type of firewall (iptables, nft, ufw, firewall-cmd, shorewall), make sure to either manually add the required ports, or run the next script:
  
   ```bash
   sudo sh PWR_manager_update_firewall.sh
   ```

## Usage

Once the script has been run, the PWR Manager service will be installed and started as a systemd service. You can manage the service using standard `systemctl` commands:

- Start the Node: `sudo systemctl start PWR_manager`
- Stop the Node: `sudo systemctl stop PWR_manager`
- Restart the Node: `sudo systemctl restart PWR_manager`
- Check the Node status: `sudo systemctl status PWR_manager`
- All files are located under `"home directory"/PWR_manager`
- The service automatically rotates the logs after 5MB

## Customization

- You can customize the JAR file URL, service name, and description in the script.
- The script assumes the `java` executable is available. If not, it will try to automatically install the corect version.
- The location of the service files and output directories can be customized in the script.

## Uninstalling

- Unistalling will not remove the node files.
- Uninstalling will ask to remove java.

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


## Special thanks to

- Inspired by [PWR Labs](https://github.com/pwrlabs).


## Support
- Made by [Aurora Ryunix](https://ko-fi.com/jaydenryunix).
