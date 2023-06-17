# Ansible Scripts

Scripts to simplify the installation/configurations of programs.
Using ansible-pull.
Tested only on ubuntu.

# Usage

To install one of the programs simply type -

```
bash <(curl -s https://raw.githubusercontent.com/ism-hub/ansible/main/<prog-name>.sh)
```

for example, for installing fzf type -

```
bash <(curl -s https://raw.githubusercontent.com/ism-hub/ansible/main/fzf.sh)
```

# Available Scripts

## fzf

Installs fzf.
No need for sudo.

## tmux

Download my tmux conf (repo in this github) and set it.

## nvim (WIP)

WIP (work in progress).
Installs nvim and dependencies (ripgrep) and download my configuration (repo in this github)

## nextcloud-client

Downloading nextcloudcmd and creating a cronjob (every min) to -
Sync specified folders with the nextcloud-server.
Can edit which folders to sync by editing - `roles/nextcloud_client/tasks/main.yaml`
for example in that file we sync the server's /Documents/org to the client's ~/nextcloud/Documents/org/ -

```
  vars:
    nxtcld_server: http://192.168.1.88
    map_server_dir_to_local_dir:
      '/Documents/org': '~/nextcloud/Documents/org' # org files

```

The cronjob script is saved in `~/.local/bin/cron/nextcloudcmd_cronjob.sh`

In order for this to work it needs the nextcloud-client username and password.
User suppose to have a file called `nextcloud_user_info.yaml` next to this ansible directory,
The content of this directory should include the username and pass in this format -

```
---
nextcloud_user: <username>
nextcloud_pass: <pass>
```

TODO: explain where to put this file when using ansible-pull
Can also use `ansible-playbook --ask-become-pass nextcloud_client.yaml` if downloading the repo.
