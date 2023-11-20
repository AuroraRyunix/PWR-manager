#!/bin/bash
#Will allow TCP ports 8085 and 8231 trough the firewall
#this script is invoked by PWR_manager_installer_updater.sh
# Define the required TCP ports
TCP_port_1="8231"
TCP_port_2="8085"

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

# Check for iptables
if command -v iptables &> /dev/null; then
    # Allow ports 8085 and 8231 (TCP) through iptables
    sudo iptables -A INPUT -p tcp --dport $TCP_port_1 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport $TCP_port_2 -j ACCEPT

    # Save iptables rules
    sudo mkdir -p /etc/iptables
    sudo iptables-save > /etc/iptables/rules.v4
fi

# Check for nftables
if command -v nft &> /dev/null; then
    # Allow ports TCP_port_1 and TCP_port_2 (TCP) through nftables
    sudo nft add table inet filter
    sudo nft add chain inet filter input { type filter hook input priority 0 \; }
    sudo nft add rule inet filter input tcp dport {$TCP_port_2, $TCP_port_1} accept

    # Save nftables rules
    sudo mkdir -p /etc/nftables
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
if command -v firewall-cmd &> /dev/null && sudo systemctl is-active --quiet firewalld; then
    # Allow ports TCP_port_1 and TCP_port_2 (TCP) through firewalld
    sudo firewall-cmd --zone=public --add-port=$TCP_port_1/tcp --permanent
    sudo firewall-cmd --zone=public --add-port=$TCP_port_2/tcp --permanent
    sudo firewall-cmd --reload
fi

# Check for shorewall
if command -v shorewall &> /dev/null; then
    # Allow ports 8085 and 8231 (TCP) through shorewall
    echo "ACCEPT net tcp $TCP_port_1" | sudo tee -a /etc/shorewall/rules
    echo "ACCEPT net tcp $TCP_port_2" | sudo tee -a /etc/shorewall/rules

    # Save shorewall rules
    sudo shorewall save
    sudo shorewall restart
fi

# Check for PF (Packet Filter)
if command -v pfctl &> /dev/null; then
    # Allow ports 8085 and 8231 (TCP) through PF
    echo "pass in on egress proto tcp from any to any port {$TCP_port_1, $TCP_port_2}" | sudo tee -a /etc/pf.conf
    sudo pfctl -f /etc/pf.conf
fi

# Check for IPset
if command -v ipset &> /dev/null; then
    # Create an IPset for ports 8085 and 8231
    sudo ipset create allowed_ports hash:ip,port
    sudo ipset add allowed_ports 0.0.0.0/0,$TCP_port_1
    sudo ipset add allowed_ports 0.0.0.0/0,$TCP_port_2

    # Use iptables to allow traffic from the IPset
    sudo iptables -A INPUT -m set --match-set allowed_ports src -j ACCEPT

    # Save iptables rules
    sudo mkdir -p /etc/iptables
    sudo iptables-save > /etc/iptables/rules.v4
fi

# Check for iptables-restore and iptables-save
if command -v iptables-restore &> /dev/null && command -v iptables-save &> /dev/null; then
    # Allow ports 8085 and 8231 (TCP) through iptables-restore/iptables-save
    sudo mkdir -p /etc/iptables
    echo "-A INPUT -p tcp --dport $TCP_port_1 -j ACCEPT" | sudo tee -a /etc/iptables/rules.v4
    echo "-A INPUT -p tcp --dport $TCP_port_2 -j ACCEPT" | sudo tee -a /etc/iptables/rules.v4
    sudo iptables-restore < /etc/iptables/rules.v4
fi

# Add other firewall checks as needed

# Add more firewall rules as needed

echo "Firewall rules configured successfully for ports 8085 and 8231."
