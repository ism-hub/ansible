#!/bin/bash
sudo apt install ansible
read -p "Enter namecheap pass (The Dynamic DNS Password from namecheap.com's dashboard -> Advanced DNS page for the domain with the A records you want to update.)" namecheap_pass
read -p "Enter domain (example.com): " domain 
read -p "Enter subdomain (wwww): " subdomain 
read -p "Enter interval (300s): " interval 
ansible-pull -U https://github.com/ism-hub/ansible.git -e "namecheap_pass=$namecheap_pass domain=$domain subdomain=$subdomain interval=$interval" ddns_namecheap.yaml
