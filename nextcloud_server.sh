#!/bin/bash
sudo apt install ansible
read -p "Enter mail: " nxt_mail
read -p "Enter url: " nxt_url
ansible-pull --ask-become-pass -U https://github.com/ism-hub/ansible.git -e "mail=$nxt_mail url=$nxt_url" nextcloud_server.yaml
