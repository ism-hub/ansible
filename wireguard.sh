#!/bin/bash
sudo apt install ansible
read -p "Enter url (vpn.example.com): " vpn_url 
read -p "Enter peers (myPhone,...): " peers 
ansible-pull -U https://github.com/ism-hub/ansible.git -e "vpn_url=$vpn_url peers=$peers" wireguard.yaml
