#!/bin/bash
sudo apt install ansible
ansible-pull --ask-become-pass -U https://github.com/ism-hub/ansible.git nextcloud_client.yaml
