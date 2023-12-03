#!/bin/bash
sudo apt install ansible
read -p "Enter organice-url (organice.example.com): " organice_url 
ansible-pull -U https://github.com/ism-hub/ansible.git -e "organice_url=$organice_url" organice.yaml
