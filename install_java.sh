#!/bin/bash

# Function to install Java on Debian/Ubuntu
install_java_debian() {
    sudo apt-get update
    sudo apt-get install -y default-jre
}

# Function to install Java on RHEL/CentOS/Fedora
install_java_redhat() {
    sudo yum install -y java-1.8.0-openjdk
}

# Function to install Java on Arch Linux
install_java_arch() {
    sudo pacman -S --noconfirm jre8-openjdk
}

# Function to determine the Linux distribution and install Java
install_java() {
    if [ -x "$(command -v java)" ]; then
        echo "Java is already installed."
    elif [ -x "$(command -v apt-get)" ]; then
        install_java_debian
    elif [ -x "$(command -v yum)" ]; then
        install_java_redhat
    elif [ -x "$(command -v pacman)" ]; then
        install_java_arch
    else
        echo "Unsupported Linux distribution. Please install Java manually."
        exit 1
    fi
}

# Check and install Java
install_java
