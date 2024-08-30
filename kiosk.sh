#!/bin/bash
wget -O- https://repository.salamek.cz/deb/salamek.gpg | tee /usr/share/keyrings/salamek-archive-keyring.gpg > /dev/null
echo "deb     [signed-by=/usr/share/keyrings/salamek-archive-keyring.gpg] https://repository.salamek.cz/deb/pub all main" | tee /etc/apt/sources.list.d/salamek.cz.list
apt update && apt install -y chromium-kiosk
echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" | tee /etc/apt/sources.list.d/backports.list
apt install -y qt5-qiosk
# Variables
file="/etc/ssh/sshd_config"
param[1]="PermitRootLogin"
#param[2]="PubkeyAuthentication"
#param[3]="AuthorizedKeysFile"
param[4]="PasswordAuthentication"
# Create a backup
cp "$file" "$file.bak"
# Edit the file to set parameters
for i in {1..4}; do
    sed -i "s/^${param[$i]}.*/${param[$i]} yes/" "$file"
done
# Reload SSH configuration
systemctl reload sshd
echo "Configuration updated successfully!"
test