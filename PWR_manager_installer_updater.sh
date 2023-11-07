#!/bin/bash
#this is the main installer script that downloads the required updates, java, PWR node validator executable (jar). After this it creates a system.d service that will manage the service. 
# Preset locations:

# Define the URL of the .jar file to download
jar_url="https://github.com/pwrlabs/PWR-Validator-Node/raw/main/validator.jar"
# Define the service name
service_name="PWR_manager"
# Define the service description
service_description="manages the PWR validator nodes. Made by AuroraRyunix"

# Get the user's external IP address using a tool like curl
external_ip=$(sudo -u $SUDO_USER curl -s https://ifconfig.me)

# Use $HOME to get the current user's home directory
home_dir=$(eval echo ~$SUDO_USER)

# Specify the directory within the user's home directory to store output
output_dir="$home_dir/PWR_manager"

# Check if the script is running with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with root privileges for systemd service setup."
    exit 1
fi

# Check if Java is installed
if ! command -v java &>/dev/null; then
    echo "Java is not installed. Installing Java..."
    sudo sh install_java.sh
fi


# Create the output directory if it doesn't exist
mkdir -p "$output_dir"
sudo chmod 0777 "$output_dir"
touch "$output_dir/out.txt"
touch "$output_dir/outERROR.txt"

# Check if the password.txt file exists, and if it does, remove it
if [ -f "$home_dir/PWR_manager/password.txt" ]; then
    rm "$home_dir/PWR_manager/password.txt"
fi

# Prompt the user for a password and store it in password.txt
echo -e "\033[1mEnter your PWR Validator Node password please, or leave it blank and manually add it later:\033[0m"
read -p "Password: " user_password
echo "$user_password" > "$home_dir/PWR_manager/password.txt"

# Download the .jar file and store it in the user's home directory
sudo -u $SUDO_USER wget -O "$home_dir/PWR_manager/validator.jar" "$jar_url"

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
StandardOutput=file:$output_dir/out.txt
StandardError=file:$output_dir/outERROR.txt

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to pick up the new service unit file
systemctl daemon-reload

# Enable and start the service
systemctl enable $service_name
systemctl start $service_name
echo -e "\033[1mPlease wait for the systemd service to start.\033[0m"
sleep 10
systemctl restart $service_name
echo -e "\033[1mPWR Manager service has been installed and started with auto-restart on failure.\033[0m"


# Reminder message
echo -e "\033[1mPlease make sure to change your password in '$home_dir/PWR_manager/password.txt' and restart the service using 'systemctl restart $service_name'.\033[0m"
echo -e "\033[1mYou can find the standard output in the file '$output_dir/out.txt' and the standard error in the file '$output_dir/outERROR.txt'.\033[0m"
