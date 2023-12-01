#!/bin/bash
sudo apt install ansible
read -p "Enter mail (optional, to get letsencrypt updates): " lets_encrypt_mail 
read -p "Enter url (cloud.example.com): " nextcloud_url 
ansible-pull --ask-become-pass -U https://github.com/ism-hub/ansible.git -e "lets_encrypt_mail=$lets_encrypt_mail nextcloud_url=$nextcloud_url" nextcloud_server.yaml
