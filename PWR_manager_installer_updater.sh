#!/bin/bash

# Check if Java is installed
if ! command -v java &>/dev/null; then
    echo "Java is not installed. Installing Java..."
    ./install_java.sh
fi

# Continue with the rest of the script as before
# Define the URL of the .jar file to download
jar_url="https://github.com/pwrlabs/PWR-Validator-Node/raw/main/validator.jar"

# Define the service name
service_name="PWR_manager"

# Define the service description
service_description="Your PWR Manager Service"

# Get the user's external IP address using a tool like curl
external_ip=$(curl -s https://ifconfig.me)

# Use $HOME to get the current user's home directory
home_dir="$HOME"

# Create a directory to store all the related files
mkdir -p "$home_dir/PWR_manager"

# Download the ..jar file and store it in the user's home directory
wget -O "$home_dir/PWR_manager/validator.jar" "$jar_url"

# Create a passwords file (You can customize this as needed)
echo "YourPassword" > "$home_dir/PWR_manager/passwords.txt"

# Create a systemd service unit file
cat > /etc/systemd/system/$service_name.service <<EOF
[Unit]
Description=$service_description

[Service]
ExecStart=java -jar $home_dir/PWR_manager/validator.jar password $external_ip
User=$USER
WorkingDirectory=$home_dir/PWR_manager
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to pick up the new service unit file
systemctl daemon-reload

# Enable and start the service
systemctl enable $service_name
systemctl start $service_name

echo "PWR Manager service has been installed and started with auto-restart on failure."
