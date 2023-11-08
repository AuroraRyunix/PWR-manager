#!/bin/bash

# Function to install Java on Debian/Ubuntu
install_java_debian() {
    echo "Debian based system detected. Installing OpenJDK 21..."
    sudo apt-get update -y
    sudo apt-get install -y
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
    sudo apt-get -qqy install ./jdk-21_linux-x64_bin.deb
}

install_java_ubuntu() {
    echo "Ubuntu based system detected. Installing OpenJDK 21..."
    sudo apt-get update -y
    sudo apt-get install -y
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
    sudo apt-get -qqy install ./jdk-21_linux-x64_bin.deb
}


# Function to install Java on Fedora
install_java_fedora() {
    echo "Fedora-based system detected. Downloading and installing Oracle JDK 21..."
    # Download Oracle JDK 21 RPM
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.rpm

    # Install Oracle JDK 21
    sudo rpm -i jdk-21_linux-x64_bin.rpm
}

# Function to install Java on Red Hat/CentOS
install_java_redhat() {
    echo "Red Hat based system detected. Downloading and installing Oracle JDK 21..."
    # Download Oracle JDK 21 RPM
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.rpm

    # Install Oracle JDK 21
    sudo rpm -i jdk-21_linux-x64_bin.rpm
}

install_java_centos() {
    echo "CentOS based system detected. Downloading and installing Oracle JDK 21..."
    # Download Oracle JDK 21 RPM
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.rpm

    # Install Oracle JDK 21
    sudo rpm -i jdk-21_linux-x64_bin.rpm
}

# Function to install Java on Arch Linux
install_java_arch() {
    echo "Arch Linux detected. Installing OpenJDK 19..."
    sudo pacman -S wget jre-openjdk --noconfirm
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
        install_java_redhat
    elif [ -f /etc/arch-release ]; then
        install_java_arch
    elif [ -f /etc/centos-release ]; then
        install_java_centos
    elif [ -f /etc/ubuntu-release ]; then
        install_java_ubuntu
    else
        echo "Unsupported system. Please install the appropriate JDK manually."
        exit 1
    fi
}


# Check and install Java
install_java
