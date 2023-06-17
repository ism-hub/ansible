#!/bin/bash
sudo apt install ansible
ansible-pull -U https://github.com/ism-hub/ansible.git tmux.yaml
