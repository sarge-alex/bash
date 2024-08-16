#!/bin/bash
wget -O- https://repository.salamek.cz/deb/salamek.gpg | tee /usr/share/keyrings/salamek-archive-keyring.gpg > /dev/null
echo "deb     [signed-by=/usr/share/keyrings/salamek-archive-keyring.gpg] https://repository.salamek.cz/deb/pub all main" | tee /etc/apt/sources.list.d/salamek.cz.list
apt update && apt install -y chromium-kiosk
echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" | tee /etc/apt/sources.list.d/backports.list
apt install -y qt5-qiosk
