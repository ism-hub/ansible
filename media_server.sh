#!/bin/bash
sudo apt install ansible
ansible-pull --ask-become-pass -U https://github.com/ism-hub/ansible.git media_server.yaml
