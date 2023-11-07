# Check if the password.txt file exists, and if it does, remove it
if [ -f "$home_dir/PWR_manager/password.txt" ]; then
    rm "$home_dir/PWR_manager/password.txt"
fi

# Define the service name
service_name="PWR_manager"

sudo systemctl stop PWR_manager
sudo systemctl disable PWR_manager
sudo rm /etc/systemd/system/PWR_manager.service
echo -e "\033[1mUnistall completed!\033[0m"
