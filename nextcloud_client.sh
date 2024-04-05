#!/bin/bash
sudo apt install ansible
read -p "Enter nextcloud user-name: " UNAME
read -p "Enter nextcloud user-pass: " PASS
read -p "Enter url (https://cloud.example.com): " SERVER 
ansible-pull --ask-become-pass -U https://github.com/ism-hub/ansible.git -e"UNAME=$UNAME PASS=$PASS SERVER=$SERVER" nextcloud_client.yaml
