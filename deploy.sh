#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'


if [ "$EUID" -ne 0 ]
  then echo -e "[${red}ERROR${plain}] Please run as root"
  exit
fi

while true; do
    read -r -p "Do you want install VPN Gost sever?:" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Y or N.";;
    esac
done

echo -e "${yellow}Downloading...${plain}"
wget https://github.com/go-gost/gost/releases/download/v3.0.0-rc8/gost_3.0.0-rc8_linux_amd64.tar.gz > /dev/null
# shellcheck disable=SC2181
if [[ "$?" != 0 ]]; then
    echo -e "[${red}ERROR${plain}] downloading file"
else
    echo -e "[${green}SUCCESS${plain}] Downloading"
fi

mkdir /opt/gost3
tar -xvzf ./gost_3.0.0-rc8_linux_amd64.tar.gz -C /opt/gost3

echo -e "${yellow}Create systemd service${plain}"
cat <<EOF >>/etc/systemd/system/gost.service
[Unit]
Description=GO Simple Tunnel
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/opt/gost3/gost -C /opt/gost3/gost.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOF

read -r -p "Enter port number (80 for default): " port
port=${port:-80}
read -r -p "Enter new VPN user login : " login
read -r -p "Enter password : " password


echo -e "${yellow}Create gost config${plain}"
cat <<EOF >>/opt/gost3/gost.yaml
services:
- name: service-relay-ws
  reload: 10s
  addr: ":$port"
  handler:
    type: relay
    auther: auther-0
  listener:
    type: ws
authers:
- name: auther-0
  auths:
  - username: $login
    password: $password
EOF

chmod +x /opt/gost3/gost
chmod 777 /opt/gost3/gost.yaml

echo -e "${yellow}Enable gost service${plain}"
systemctl enable gost
echo -e "${yellow}Running...${plain}"
systemctl start gost

echo -e "You can check status of service with command:${yellow}sudo systemctl status gost ${plain}"