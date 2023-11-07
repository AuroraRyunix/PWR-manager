# Check if the password.txt file exists, and if it does, remove it
if [ -f "$home_dir/PWR_manager/password.txt" ]; then
    rm "$home_dir/PWR_manager/password.txt"
fi

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

# Function to remove Java on Red Hat/CentOS
remove_java_redhat() {
    echo "Red Hat/CentOS based system detected. Removing Java..."
    sudo yum remove java-\* -y
}

# Function to remove Java on Arch Linux
remove_java_arch() {
    echo "Arch Linux detected. Removing Java..."
    sudo pacman -Rns jre-openjdk --noconfirm
}

sudo systemctl stop PWR_manager
sudo systemctl disable PWR_manager
sudo rm /etc/systemd/system/PWR_manager.service

echo -e "\033[1mService stopped and removed.\033[0m"

sleep 2

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
                remove_java_redhat
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
echo -e "\033[1mUnistall completed!\033[0m"

