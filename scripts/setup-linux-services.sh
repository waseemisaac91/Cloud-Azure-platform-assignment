#!/usr/bin/env bash
# Optional tasks on the Linux VM: swap, Apache, MySQL and Samba.
# Run on the VM (over SSH). The Samba password is set interactively at the end.
set -euo pipefail

sudo apt update

# 1 GiB swap file (the VM has only 1 GiB RAM)
if ! swapon --show | grep -q /swapfile; then
  sudo fallocate -l 1G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
fi
free -h

# Apache web server and a simple web site
sudo apt install -y apache2
echo "<h1>Hello from Azure - Waseem Isaac</h1>" | sudo tee /var/www/html/index.html
sudo systemctl status apache2 --no-pager | head -5

# MySQL server and a database
sudo apt install -y mysql-server
sudo mysql -e "CREATE DATABASE IF NOT EXISTS studentdb; SHOW DATABASES;"

# Samba file share (tested locally; port 445 is NOT opened to the Internet)
sudo apt install -y samba smbclient
sudo mkdir -p /srv/samba/share
sudo chmod 777 /srv/samba/share
if ! grep -q '^\[share\]' /etc/samba/smb.conf; then
  sudo tee -a /etc/samba/smb.conf > /dev/null <<'CONF'

[share]
   path = /srv/samba/share
   read only = no
   browsable = yes
CONF
fi
sudo systemctl restart smbd

echo
echo "Next: set the Samba password with   sudo smbpasswd -a azureuser"
echo "Then test with   smbclient //localhost/share -U azureuser -c 'ls'"
