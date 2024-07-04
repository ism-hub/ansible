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

RUN locale-gen en_US.UTF-8

# create user so our mounted files will have the correct uid:gid
# user should override
# add user to sudoers
RUN deluser --remove-home ubuntu
RUN groupadd -g $GID -o $IUNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $IUNAME
RUN usermod -aG sudo $IUNAME
RUN echo "$IUNAME ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/$IUNAME

# install .net stuff
RUN sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0

# go stuff
RUN wget https://go.dev/dl/go1.22.4.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz

# install cloud stuff
#install SAM
RUN wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
RUN unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
RUN ./sam-installation/install
RUN rm aws-sam-cli-linux-x86_64.zip
RUN rm -r sam-installation
# install cargo-lambda
RUN apt-get update && \
    apt-get install -y pipx
USER $IUNAME
RUN pipx install cargo-lambda
RUN pipx ensurepath
# install Zig (cargo toolchain wants it)
RUN wget https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz -P ~
RUN tar xf ~/zig-linux-x86_64-0.13.0.tar.xz -C ~
RUN ln -s ~/zig-linux-x86_64-0.13.0/zig ~/.local/bin/zig
RUN rm ~/zig-linux-x86_64-0.13.0.tar.xz
# aws-vault
RUN wget https://github.com/99designs/aws-vault/releases/download/v7.2.0/aws-vault-linux-amd64 -O ~/.local/bin/aws-vault
RUN chmod u+x ~/.local/bin/aws-vault
RUN echo 'AWS_VAULT_BACKEND=file' >> ~/.bashrc
RUN echo 'AWS_REGION=eu-north-1' >> ~/.bashrc
# aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o ~/awscliv2.zip
RUN unzip ~/awscliv2.zip -d ~
RUN sudo ~/aws/install

USER root
# our root-dir
RUN mkdir $ROOT
RUN mkdir $ROOT/host_fs

RUN chown -R $UID:$GID ${ROOT}
USER $IUNAME
# some problems using only rustup (instead of cargo), but I think rustup and this can cause problems.. need to check (formatting doesn't work if I install only cargo)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN mkdir -p ~/obsidian/
RUN ansible-pull -U https://github.com/ism-hub/ansible.git fzf.yaml
RUN ansible-pull -U https://github.com/ism-hub/ansible.git bash.yaml
RUN ansible-pull -U https://github.com/ism-hub/ansible.git tmux.yaml
RUN ansible-pull -U https://github.com/ism-hub/ansible.git npm.yaml
RUN ansible-pull -U https://github.com/ism-hub/ansible.git nvim.yaml
RUN sudo npm install -g neovim

# go stuff cont. 1
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile

# .net stuff cont. (omnisharp lsp)
RUN mkdir ~/.omnisharp
RUN touch ~/.omnisharp/omnisharp.json
RUN echo '{ \n\
  "RoslynExtensionsOptions": { \n\
    "documentAnalysisTimeoutMs": 30000, \n\
    "enableDecompilationSupport": true, \n\
    "enableImportCompletion": true, \n\
    "enableAnalyzersSupport": true, \n\
    "inlayHintsOptions": { \n\
        "enableForParameters": true, \n\
        "forLiteralParameters": true, \n\
        "forIndexerParameters": true, \n\
        "forObjectCreationParameters": true, \n\
        "forOtherParameters": true, \n\
        "suppressForParametersThatDifferOnlyBySuffix": false, \n\
        "suppressForParametersThatMatchMethodIntent": false, \n\
        "suppressForParametersThatMatchArgumentName": false, \n\
        "enableForTypes": true, \n\
        "forImplicitVariableTypes": true, \n\
        "forLambdaParameterTypes": true, \n\
        "forImplicitObjectCreation": true \n\
    } \n\
  } \n\
}' > ~/.omnisharp/omnisharp.json

USER root
# RUN pip3 install neovim

COPY ./entrypoint.sh ${ROOT}/entrypoint.sh
RUN chmod u+x ${ROOT}/entrypoint.sh

ENV REAL_RUN=1

ENTRYPOINT ["/bin/bash", "/rfolder/entrypoint.sh"]
