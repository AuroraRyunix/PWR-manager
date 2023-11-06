#!/bin/bash

# Function to install Java on Debian/Ubuntu
install_java_debian() {
    echo "Debian/Ubuntu based system detected. Installing OpenJDK 19..."
    sudo apt-get update
    sudo apt-get install openjdk-19-jre -y
}

# Function to install Java on CentOS/RHEL
install_java_redhat() {
    echo "CentOS/RHEL based system detected. Installing OpenJDK 19..."
    sudo yum install java-19-openjdk -y
}

# Function to install Java on Fedora
install_java_fedora() {
    echo "Fedora based system detected. Installing OpenJDK 19..."
    sudo dnf install java-19-openjdk -y
}

# Function to install Java on Arch Linux
install_java_arch() {
    echo "Arch Linux detected. Installing OpenJDK 19..."
    sudo pacman -S jre-openjdk-headless --noconfirm
}

# Function to determine the Linux distribution and install Java
install_java() {
    if [ -x "$(command -v java)" ]; then
        echo "Java is already installed."
    elif [ -f /etc/debian_version ]; then
        install_java_debian
    elif [ -f /etc/redhat-release ]; then
        install_java_redhat
    elif [ -f /etc/fedora-release ]; then
        install_java_fedora
    elif [ -f /etc/arch-release ]; then
        install_java_arch
    else
        echo "Unsupported system. Please install OpenJDK 19 manually."
        exit 1
    fi
}

# Check and install Java
install_java
