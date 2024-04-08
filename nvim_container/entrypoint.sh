# we need that the nvim user will be the curernt user so it will have access to the same files the host user has
# and also if it creates a new file it will be with the corret user on the host
CUR_UID=$(id notroot -u)
CUR_GID=$(id notroot -g)

# change the nvim-user inside of the container (named it 'notroot') to match UID and GID
# if gid is different
if ! [ $CUR_GID = $GID ]; then
    groupmod -g $GID notroot
    # change all the prev files uid and gid (don't touch host)
    find / -path /rfolder/host_fs -prune -o -gid $CUR_GID -exec chgrp -v $GID '{}' \;
fi

# if uid is different
if ! [ $CUR_UID = $UID ]; then
    usermod -u $UID -g $GID notroot
    # change all the prev files uid and gid (don't touch host)
    find / -path /rfolder/host_fs -prune -o -uid $CUR_UID -exec chown -v -h $UID '{}' \;
fi

# become the user and start nvim
echo "nvim /rfolder/host_fs" | su - notroot
# sudo -u notroot nvim -c 'cd /rfolder/host_fs/'
