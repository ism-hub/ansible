#! /bin/bash

# downloads the nvim_container files (only if not exists) into '~/nvim_container' and augments the $PATH to have ~/nvim_container
# (notice, as we only downloading if doest already exists we can use this script to augment the $PATH in different shells)
# typing 'cnvim' will now run our nvim from the container

INSTALL_DIR=$HOME/nvim_container

if [ ! -d "$INSTALL_DIR" ]; then
    # for a lack of a better way to download a whole folder from git
    mkdir $INSTALL_DIR
    (cd $INSTALL_DIR && curl https://raw.githubusercontent.com/ism-hub/ansible/main/nvim_container/Dockerfile -O)
    (cd $INSTALL_DIR && curl https://raw.githubusercontent.com/ism-hub/ansible/main/nvim_container/cnvim -O)
    (cd $INSTALL_DIR && curl https://raw.githubusercontent.com/ism-hub/ansible/main/nvim_container/entrypoint.sh -O)
    chmod u+x $INSTALL_DIR/cnvim
    # add to path (add line to .bashrc only if doesn't exist)
    LINE="export PATH=$INSTALL_DIR:"
    LINE+='$PATH'
    FILE=~/.bashrc
    grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
fi

export PATH="$INSTALL_DIR:$PATH"
