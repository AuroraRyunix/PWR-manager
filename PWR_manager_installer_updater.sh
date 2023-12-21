#!/bin/bash
#this is the main installer script that downloads the required updates, java, PWR node validator executable (jar). After this it creates a system.d service that will manage the service. 
# user changable settings:


# Define the URL of the .jar file to download
jar_url="https://github.com/pwrlabs/PWR-Validator-Node/raw/main/validator.jar"
# Define the service name
service_name="PWR_manager"
# Define the service description
service_description="manages the PWR validator nodes. Made by AuroraRyunix"

# Get the user's external IP address using a tool like curl
external_ip=$(curl https://ipinfo.io/ip)

# Use $HOME to get the current user's home directory
home_dir=$(eval echo ~$SUDO_USER)

# Specify the directory within the user's home directory to store output
output_dir="$home_dir/PWR_manager"

# Check if the script is running with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with root privileges for systemd service setup."
    exit 1
fi

if [ -f "PWR_manager_update_firewall.sh" ]; then
    echo "Executing PWR_manager_update_firewall.sh..."
    sudo sh PWR_manager_update_firewall.sh

    # Continue with the rest of your script here
    echo "sucesfully bypassed the firewall"
else
    echo "Please manually portforward, no script found."
fi





echo "stopping current PWR_manager to install/update"
sudo systemctl stop PWR_manager.service
echo "service stopped"

#installing java
#
#
#
#
#
#
#
#

install_java_debian() {
    echo "Debian based system detected. Installing OpenJDK 21..."
    sudo apt-get update -y
    sudo apt-get install -y wget curl
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
    sudo dpkg -i jdk-21_linux-x64_bin.deb
    rm jdk-21_linux-x64_bin.deb
}



# Function to install Java on Fedora/rhel/centos/rocky linux
install_java_fedora() {
    echo "Fedora-based system detected. Downloading and installing Oracle JDK 21..."
    # Download Oracle JDK 21 RPM
    sudo dnf install -y wget curl
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.rpm
    # Install Oracle JDK 21
    sudo rpm -i jdk-21_linux-x64_bin.rpm
    sudo update-alternatives --install "/usr/bin/java" "java" "/usr/java/jdk-*/bin/java" 1
    rm jdk-21_linux-x64_bin.rpm
}



# Function to install Java on Arch Linux
install_java_arch() {
    echo "Arch Linux detected. Installing OpenJDK 19..."
    sudo pacman -S wget curl jre-openjdk --noconfirm
}


# Function to determine the Linux distribution and install Java
install_java() {
    if [ -x "$(command -v java)" ]; then
        echo "Java is already installed."
    elif [ -f /etc/debian_version ]; then
        install_java_debian
    elif [ -f /etc/fedora-release ]; then
        install_java_fedora
    elif [ -f /etc/redhat-release ]; then
        install_java_fedora
    elif [ -f /etc/arch-release ]; then
        install_java_arch
    elif [ -f /etc/centos-release ]; then
        install_java_fedora
    elif [ -f /etc/ubuntu-release ]; then
        install_java_debian
    else
        echo "Unsupported system. Please install the appropriate JDK manually."
        exit 1
    fi
}





perform_uninstall() {
    # Add your uninstallation code here
    echo "Uninstalling PWR manager..."
        # Define the service name
        service_name="PWR_manager"
        
        # Function to remove Java on Debian/Ubuntu
        remove_java_debian() {
            echo "Debian/Ubuntu based system detected. Removing Java..."
            sudo apt-get purge openjdk-\* -y
            sudo apt-get autoremove -y
        }
        
        # Function to remove Java on Fedora
        remove_java_fedora() {
            echo "Fedora-based system detected. Removing Java..."
            sudo dnf remove java-\* -y
        }
        
        # Function to remove Java on Arch Linux
        remove_java_arch() {
            echo "Arch Linux detected. Removing Java..."
            sudo pacman -Rns jre-openjdk --noconfirm
        }
        
        sudo systemctl stop PWR_manager
        sudo systemctl disable PWR_manager
        sudo rm /etc/systemd/system/PWR_manager.service
        cd $home_dir/PWR_manager/
	mkdir backups
	mv validator.jar backups/validator.jar.old.$(date +"%Y%m%d")
 	mv outERROR.txt backups/outERROR.txt.$(date +"%Y%m%d")
  	mv out.txt backups/out.txt.$(date +"%Y%m%d")
        echo -e "\033[1mService stopped and removed.\033[0m"
        
        # Function to determine the Linux distribution and remove Java
        remove_java() {
            if [ -x "$(command -v java)" ]; then
                read -p "Do you want to remove Java? (y/n): " remove_java_choice
                if [ "$remove_java_choice" = "y" ]; then
                    if [ -f /etc/debian_version ]; then
                        remove_java_debian
                    elif [ -f /etc/fedora-release ]; then
                        remove_java_fedora
                    elif [ -f /etc/redhat-release ]; then
                        remove_java_fedora
                    elif [ -f /etc/arch-release ]; then
                        remove_java_arch
                    else
                        echo "Unsupported system. Please remove Java manually."
                        exit 1
                    fi
                    echo "Java has been removed."
                else
                    echo "Not removing java"
                fi
            else
                echo "Java is not installed."
            fi
        }
        
        # Check and remove Java
        remove_java
	# Continue
 	systemctl daemon-reload
        echo -e "\033[1mUnistall completed!\033[0m"

}



#check for --uninstall, else run the script normally
#
if [ "$1" = "--uninstall" ]; then
    # If the first command-line argument is "--uninstall", perform uninstallation
    perform_uninstall
else
    # Normal code that runs when the script is called without --uninstall
    echo "INSTALLING"
    # Create the output directory if it doesn't exist
    # Check if Java is installed
	if ! command -v java &>/dev/null; then
    		echo "Java is not installed. Installing Java..."
    		install_java
	fi
	
	

	
	
	

	
    mkdir -p "$output_dir"
    sudo chmod 0777 "$output_dir"
    touch "$output_dir/out.txt"
    touch "$output_dir/outERROR.txt"
    
    # Check if the password.txt file exists, and if it does, remove it
    if [ -f "$home_dir/PWR_manager/password.txt" ]; then
        rm "$home_dir/PWR_manager/password.txt"
    fi
    echo -e "\033[1mPasword backed up, please enter password again for security reasons.\033[0m"
    # Prompt the user for a password and store it in password.txt
    echo -e "\033[1mEnter your PWR Validator Node password please, or leave it blank and manually add it later:\033[0m"
    read -p "Password: " user_password
    echo "$user_password" > "$home_dir/PWR_manager/password.txt"
    
    # create a backup of everything (excluding blocks) every install/update
    cd $home_dir/PWR_manager/
    mkdir backups
    mv validator.jar "backups/validator.jar.backup.$(date +"%Y%m%d")"
    cp password.txt "backups/password.txt.$(date +"%Y%m%d")"
    cp -r staticDatabase/ "backups/staticDatabaseBACKUP$(date +"%Y%m%d")/"
    echo -e "\033[1Downloading the node runtime, please wait.\033[0m"
    sudo -u $SUDO_USER curl -LO "$jar_url"
    echo -e "\033[1Creating the systemD service.\033[0m"
    # Create a systemd service unit file
    cat > /etc/systemd/system/$service_name.service <<EOF
        [Unit]
        Description=$service_description
        
        [Service]
        ExecStart=java -jar $home_dir/PWR_manager/validator.jar password.txt $external_ip
        User=$SUDO_USER
        WorkingDirectory=$home_dir/PWR_manager
        Restart=always
        RestartSec=5
	SyslogIdentifier=$service_name
	SyslogLevel=info
	SyslogFacility=local0
        StandardOutput=file:$output_dir/out.txt
        StandardError=file:$output_dir/outERROR.txt
	LimitFSIZE=5M
 
        [Install]
        WantedBy=multi-user.target

EOF
    
    # Reload systemd to pick up the new service unit file
    systemctl daemon-reload
    echo -e "\033[1Restarting the systemD-Daemon.\033[0m"
    
    # Enable and start the service
    systemctl enable $service_name
    systemctl start $service_name
    echo -e "\033[1mPlease wait for PWR-manager to start.\033[0m"
    sleep 1
    echo -e "\033[1mPWR Manager service has been installed and started with auto-restart on failure.\033[0m"
    
    
    # Reminder message
    echo -e "\033[1mSucesfully installed, you can check the current status using "sudo systemctl status PWR-manager.service".\033[0m"
    echo -e "\033[1mYou can find the output logs in the file '$output_dir/out.txt' and the error logs in the file '$output_dir/outERROR.txt'.\033[0m"
    
        
        # Add your regular installation or update logic here
fi
