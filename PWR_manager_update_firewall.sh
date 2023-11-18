#!/bin/bash

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

# Check for iptables
if command -v iptables &> /dev/null; then
    # Allow ports 8085 and 8231 (TCP) through iptables
    sudo iptables -A INPUT -p tcp --dport 8085 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 8231 -j ACCEPT

    # Save iptables rules
    sudo service iptables save
    sudo service iptables restart
fi

# Check for nftables
if command -v nft &> /dev/null; then
    # Allow ports 8085 and 8231 (TCP) through nftables
    sudo nft add table inet filter
    sudo nft add chain inet filter input { type filter hook input priority 0 \; }
    sudo nft add rule inet filter input tcp dport {8085, 8231} accept

    # Save nftables rules
    sudo nft list ruleset > /etc/nftables.conf
    sudo systemctl restart nftables
fi

# Check for UFW
if command -v ufw &> /dev/null; then
    # Allow ports 8085 and 8231 (TCP) through UFW
    sudo ufw allow 8085/tcp
    sudo ufw allow 8231/tcp
fi

# Check for firewalld
if command -v firewall-cmd &> /dev/null; then
    # Allow ports 8085 and 8231 (TCP) through firewalld
    sudo firewall-cmd --zone=public --add-port=8085/tcp --permanent
    sudo firewall-cmd --zone=public --add-port=8231/tcp --permanent
    sudo firewall-cmd --reload
fi

# Check for shorewall
if command -v shorewall &> /dev/null; then
    # Allow ports 8085 and 8231 (TCP) through shorewall
    sudo echo "ACCEPT net tcp 8085" >> /etc/shorewall/rules
    sudo echo "ACCEPT net tcp 8231" >> /etc/shorewall/rules

    # Save shorewall rules
    sudo shorewall save
    sudo shorewall restart
fi

# Check for PF (Packet Filter)
if command -v pfctl &> /dev/null; then
    # Allow ports 8085 and 8231 (TCP) through PF
    sudo echo "pass in on egress proto tcp from any to any port {8085, 8231}" >> /etc/pf.conf
    sudo pfctl -f /etc/pf.conf
fi

# Check for IPset
if command -v ipset &> /dev/null; then
    # Create an IPset for ports 8085 and 8231
    sudo ipset create allowed_ports hash:ip,port
    sudo ipset add allowed_ports 0.0.0.0/0,8085
    sudo ipset add allowed_ports 0.0.0.0/0,8231

    # Use iptables to allow traffic from the IPset
    sudo iptables -A INPUT -m set --match-set allowed_ports src -j ACCEPT

    # Save iptables rules
    sudo service iptables save
    sudo service iptables restart
fi

# Check for iptables-restore and iptables-save
if command -v iptables-restore &> /dev/null && command -v iptables-save &> /dev/null; then
    # Allow ports 8085 and 8231 (TCP) through iptables-restore/iptables-save
    sudo echo "-A INPUT -p tcp --dport 8085 -j ACCEPT" >> /etc/iptables/rules.v4
    sudo echo "-A INPUT -p tcp --dport 8231 -j ACCEPT" >> /etc/iptables/rules.v4
    sudo iptables-restore < /etc/iptables/rules.v4
    sudo iptables-save > /etc/iptables/rules.v4
fi

# Add other firewall checks as needed

# Add more firewall rules as needed

echo "Firewall rules configured successfully for ports 8085 and 8231."
