#!/bin/bash

# Check if the script is running with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with root privileges for systemd service setup."
    exit 1
fi

# Define the URL of the .jar file to download
jar_url="https://github.com/pwrlabs/PWR-Validator-Node/raw/main/validator.jar"

# Define the service name
service_name="PWR_manager"

# Define the service description
service_description="Your PWR Manager Service"

# Get the user's external IP address using a tool like curl
external_ip=$(sudo -u $SUDO_USER curl -s https://ifconfig.me)

# Use $HOME to get the current user's home directory
home_dir=$(eval echo ~$SUDO_USER)

# Specify the directory within the user's home directory to store output
output_dir="$home_dir/PWR_manager"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Download the .jar file and store it in the user's home directory
sudo -u $SUDO_USER wget -O "$home_dir/PWR_manager/validator.jar" "$jar_url"

# Create a passwords file (You can customize this as needed)
sudo -u $SUDO_USER echo "YourPassword" > "$home_dir/PWR_manager/password.txt"

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

echo "PWR Manager service has been installed and started with auto-restart on failure."

# Reminder message
echo "Please make sure to change your password in '$home_dir/PWR_manager/passwords.txt' and restart the service using 'systemctl restart $service_name'."
echo "You can find the standard output in the file '$output_dir/out.txt' and the standard error in the file '$output_dir/outERROR.txt'."
