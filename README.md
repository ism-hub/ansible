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

## nvim

Installs nvim and dependencies (ripgrep) and download my configuration (repo in this github)
## Nvim from container (WIP - need to test more)
Not using ansible (on the host),
Building a container with nvim inside of it,
Providing a script which given a directory will open the nvim from inside the container.
The installation copies files to ~/nvim_container and add that folder to the `$PATH` (`cnvim` (container-nvim) is sitting there)
### Usage
Installation - `bash <(curl -s https://raw.githubusercontent.com/ism-hub/ansible/main/nvim_container.sh)`
Usage - `cnvim <folder>`
## nextcloud-client

Creates Docker-Compose file in `~/servers/nclient`
The container calls `nextcloudcmd` to sync the folders in `vars/main.yml` (which are nextcloud folders) to `~/servers/nclient/nextcloud` (local folders)
(calls the command every 1 min using cronjob)
Can edit `vars/main` to add more folders to sync or change existing ones.

## Media-Server

Installs docker and creates docker-compose for Plex, Sonarr, Radarr, Jackett, Deluge.

Creates the following folders -

    ~/servers/media_server/notsynced/deluge/data/downloads  # mount for the deluge container - deluge downloads everything to here
    ~/servers/media_server/notsynced/deluge/data/finished   # part of the mount for the deluge container - sonarr/radarr copy&rename on finish to here
    ~/servers/media_server/synced/deluge/config             # mount for the deluge container - deluge's config
    ~/servers/media_server/synced/plex/config               # mount for the config of the plex container
    ~/servers/media_server/synced/sonarr/config             # mount for the config of the sonarr container
    ~/servers/media_server/synced/radarr/config             # mount for the config of the radarr container
    ~/servers/media_server/synced/jackett/config            # mount for the config of the jackett container
(notice - config mounts needed when updating to a new container, to not lose all the configuration)

Creates the following file -

        ~/servers/media_server/docker-compose.yml

Specifies the current user's uid and gid as the uid/gid to use inside the container.

(this way when the container creates files/folders inside the mounted folders it will be with the premissions of the current user)

Installs docker and add the current user to the 'docker' group

(this way the user doesn't need to use sudo and all the relative paths inside the dcoker-compose are of the current user)

running -

    docker compose -f ~/servers/media_server/docker-compose.yml up
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
6. When downloading something choose the `Root Folder` to be `/data/finished` (need to do once and it remembers for the next time) (without this the hard-link wont work and it will copy and use up more space)
(when deluge finish to download to `/data/downloads`, sonarr/radarr will hardlink it (with a more readable name to `/data/finished`))

## Nextcloud-Server

Creates docker-compose of nextcloud-server behind nginx-reverse-proxy with certificate to support https
(also installs docker like in the Media-Server)
The script asks for `url` this should be the url of the nextcloud-server 
The script asks for `mail` this is optional and for the certificate-container to notify on stuff

Create the following paths - 

    ~/servers/nextcloud/not_synced/for_https    # data needed for the certificate
    ~/servers/nextcloud/synced/var/www/html # the config and data of nextcloud
    ~/servers/nextcloud/synced/mariadb/var/lib/mysql  # the db nextcloud uses

## DDNS-Namecheap

Docker-Compose for updating the associated ip address of the domain from namecheap

The script asks for `namecheap_pass` can be obtained from here - 
The script asks for `domain` e.g. example.com
The script asks for `subdomain` e.g. www
The script asks for `interval` (update interval) e.g. 300s

For more info can check - `https://github.com/joshuamorris3/namecheap-ddns-update`

## Organice

Prepares docker-compose for the Organice webapp (hosting the webapp in the server).

Create the following path - 

    ~/server/organice

notice: the network in the docker-compose must be the same as the nginx-proxy one.

notice: inorder to use it with nextcloud's webdav - 

1. CORS - specifically the Cross-Origin - (cloud.example.com vs organice.example.com, `organice` calling `cloud` webdav and they are not considered the same origin)
Need to download the `WebAppPassword` in nextcloud (the admin can download this app) and set `https://organice.example.com` in the `WebDAV/CalDAV` section.

2. The public-share-WebDAV (also allow anonymous connections) continue to fail with CORS even after the change above, so need to use the remote WebDAV with the username and pass,
e.g. if you have your orgs fiels inside `Documents/org` this will be the path inside organice -

.

    WebDAV url: https://cloud.example.com/remote.php/dav/files/<user-name>/Documents/org 
    user: <user-name>
    pass: <user-pass>

## Wireguard (VPN) WIP

Creates docker-compose file based on `https://docs.linuxserver.io/images/docker-wireguard/`

Directory structure -

    ~/servers/wireguard/docker-compose.yaml
    ~/servers/wireguard/config/

The script asks for `vpn_url` (`SERVERURL`) e.g. vpn.example.com
The script asks for `peers` e.g. myPhone,...

notice: to have the correct ip-address in vpn.example.com can use the ddns script above

#### Connecting a (phone) client to the wireguard server

1. Download the wireguard app on yor phone
2. Add a tunnel using a QR-Code
2.1 from docs - To display the QR codes of active peers again, you can use the following command and list the peer numbers as arguments: docker exec -it wireguard /app/show-peer 1 4 5 or docker exec -it wireguard /app/show-peer myPC myPhone myTablet (Keep in mind that the QR codes are also stored as PNGs in the config folder).
3. Another option is to get the .conf file from - `~/servers/wireguard/config/peer_myPhone` by running `python3 -m http.server 7777` connect to the http server with the phone (internal network) and downloading it
