FROM ubuntu:noble

ENV TZ=Europe/Helsinki \
    DEBIAN_FRONTEND=noninteractive

ENV LANG=en_US.UTF-8
# ENV LC_ALL=en_US.UTF-8

ARG IUNAME=notroot
ARG UID=1000
ARG GID=1000
ARG ROOT=/rfolder

# notice linux-tools is for perf
RUN apt-get update && \
    apt-get install locales bash sudo ansible git fuse unzip fd-find fswatch curl wget build-essential gcc make -y
# linux-tools-common linux-tools-generic linux-tools-$(uname -r) -y

# install .net stuff
RUN sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0

# go stuff
RUN wget https://go.dev/dl/go1.22.4.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz

RUN locale-gen en_US.UTF-8

RUN deluser --remove-home ubuntu

# create user so our mounted files will have the correct uid:gid
# user should override
# add user to sudoers
RUN groupadd -g $GID -o $IUNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $IUNAME
RUN usermod -aG sudo $IUNAME
RUN echo "$IUNAME ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/$IUNAME

# our root-dir
RUN mkdir $ROOT
RUN mkdir $ROOT/host_fs

RUN chown -R $UID:$GID ${ROOT}
USER $IUNAME
# some problems using only rustup (instead of cargo), but I think rustup and this can cause problems.. need to check (formatting doesn't work if I install only cargo)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN mkdir -p ~/servers/nclient/nextcloud/Documents/obsidian/
RUN ansible-pull -U https://github.com/ism-hub/ansible.git fzf.yaml
RUN ansible-pull -U https://github.com/ism-hub/ansible.git bash.yaml
RUN ansible-pull -U https://github.com/ism-hub/ansible.git tmux.yaml
RUN ansible-pull -U https://github.com/ism-hub/ansible.git npm.yaml
RUN ansible-pull -U https://github.com/ism-hub/ansible.git nvim.yaml
RUN sudo npm install -g neovim

# go stuff cont. 1
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile

USER root
# RUN pip3 install neovim

COPY ./entrypoint.sh ${ROOT}/entrypoint.sh
RUN chmod u+x ${ROOT}/entrypoint.sh

ENV REAL_RUN=1

ENTRYPOINT ["/bin/bash", "/rfolder/entrypoint.sh"]
