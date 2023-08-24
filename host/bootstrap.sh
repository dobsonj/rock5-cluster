#!/bin/bash

# Enable NOPASSWD sudo to avoid prompt for ansible scripts
echo 'rock ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/rock
chmod 440 /etc/sudoers.d/rock

# install bridge-utils before messing with interfaces
apt-get install -y bridge-utils

# Change SSH host key
rm /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server

# Change machine ID (used to generate MAC addresses, must be unique)
rm /var/lib/dbus/machine-id /etc/machine-id
dbus-uuidgen --ensure
systemd-machine-id-setup
systemctl restart networking

# Disable network manager
nmcli c delete enP4p65s0
nmcli c delete "Wired connection 1"
systemctl disable --now NetworkManager
systemctl disable --now wpa_supplicant

# Create network bridge
rm /etc/network/interfaces.d/br0
brctl addbr br0
brctl addif br0 enP4p65s0

cat > /etc/network/interfaces.d/bridge <<EOF
auto lo
iface lo inet loopback

iface enP4p65s0 inet manual

# Bridge setup
auto br0
iface br0 inet dhcp
    bridge_ports enP4p65s0
EOF

# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/99-ipforward.conf
sysctl -p /etc/sysctl.d/99-ipforward.conf
systemctl restart networking

# allow access for qemu-bridge-helper
[ -f /etc/qemu/bridge.conf ] || mkdir -p /etc/qemu && echo 'allow br0' > /etc/qemu/bridge.conf
