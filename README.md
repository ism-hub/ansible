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

## Media-Server

Installs docker and creates docker-compose for Plex, Sonarr, Radarr, Jackett, Deluge.

Creates the following folders -

    ~/media_server/notsynced/deluge/data    # mount for the deluge container - deluge downloads everything to here
    ~/media_server/synced/deluge/config     # mount for the deluge container - deluge's config
    ~/media_server/synced/plex/config       # mount for the config of the plex container
    ~/media_server/synced/sonarr/config     # mount for the config of the sonarr container
    ~/media_server/synced/radarr/config     # mount for the config of the radarr container
    ~/media_server/synced/jackett/config    # mount for the config of the jackett container
(notice - config mounts needed when updating to a new container, to not lose all the configuration)

Creates the following file -

        ~/media_server/docker-compose.yml

Specifies the current user's uid and gid as the uid/gid to use inside the container.

(this way when the container creates files/folders inside the mounted folders it will be with the premissions of the current user)

Installs docker and add the current user to the 'docker' group

(this way the user doesn't need to use sudo and all the relative paths inside the dcoker-compose are of the current user)

running -

    docker compose -f ~/media_server/docker-compose.yml up
will start all the containers, but there is still need for manual configuration using the UI - 

Plex configuration - 

1. claim the Plex server by entering - `http://<server-ip>:32400/web`
    Add Library - Movies and TV should be `/data` (notice `/data` in all the containers is mounted to `~/media_server/notsynced/deluge/data` )

Deluge configuration - 
1. Enter deluge - `http://<server-ip>:8112/` pass is `deluge`
2. Change the download folder to `/data/downloads` (Preferences -> Download to:)
3. (optional) copy torrent files to `/data/torrents` (Preferences -> Copy of .torrent files to:)
4. (optional) add the `Label` plugin (Preferences -> Plugins -> Label)
5. (IMPORTANT) delete torrents after it reaches some seeding ratio (Preferences -> Queue -> Share Ratio Reached -> tick the box and choose `Remove torrent`)
    (sonarr/radarr using deluge to download the series/movie, after the series/movie is done downloading sonarr/radarr copy (hard-link) the movie to a different folder,
    so deleting the torrent+data from deluge won't delete the series/movie from sonarr/radarr (same when deleting the series/movie from sonarr/radarr won't delete it from deluge)
    so we need to specify deluge to delete the data automatically
    (when some seeding ration is achieved (0 is ok ration as well, 0 means that sonarr/radarr will copy (hard-link) the data and then deluge will delete his copy of it and won't seed at all))

Sonnar/Radarr configuration -

1. Enter Sonarr/Raddar `http://<server-ip>:8989/` / `http://<server-ip>:7878/`
2. In Radarr only - fill the authentication screen (I use `Disabled for Local Addresses`)
3. Add Deluge as Download-Clients - Setting -> Download Client -> <press + sign> -> click on deluge -> fill the form (mainly the deluge pass and the `Host` as the ip of the server)
4. Add Indexers (using Jacket) - basically enter Jackett `http://<server-ip>:9117/` and follow the instructions there (press `Add indexer` choose some (like 1337x, ThePirateBay, Torrentz, etc.) and follow `Adding a Jackett indexer in Sonarr or Radarr`)
5. Rename episodes/Movies (Settings -> Media Management -> Rename Episodes/Movies <click the choice-box>)
6. When downloading something choose the `Root Folder` to be `/data` (need to do once and it remembers for the next time) (without this the hard-link wont work and it will copy and use up more space)

## Nextcloud-Server

TODO: this also need the docker installation and adding the user to the current group (should seperate that script to avoid duplication)

Creates docker-compose of nextcloud-server behind nginx-reverse-proxy with certificate to support https
(also installs docker like in the Media-Server)
The script asks for `url` this should be the url of the nextcloud-server 
The script asks for `mail` this is optional and for the certificate-container to notify on stuff

