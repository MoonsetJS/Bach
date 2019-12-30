FROM ubuntu:16.04

# Install Commons 
RUN \
  apt-get update && \
  apt-get install -y \
        openssh-server \
        libmysqlclient-dev \
        curl \
        zsh \
        vim \
        tmux \
       	tree \
        sudo \
        git 

# Env variables
ENV UID="1000" \
    UNAME="developer" \
    GID="1000" \
    GNAME="developer" \
    SHELL="/bin/bash" \
    UHOME=/home/developer

# Create HOME dir
RUN mkdir -p "${UHOME}" \
    && chown "${UID}":"${GID}" "${UHOME}" \
# Create user
    && echo "${UNAME}:x:${UID}:${GID}:${UNAME},,,:${UHOME}:${SHELL}" \
    >> /etc/passwd \
    && echo "${UNAME}::17032:0:99999:7:::" \
    >> /etc/shadow \
# No password sudo
    && echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" \
    > "/etc/sudoers.d/${UNAME}" \
    && chmod 0440 "/etc/sudoers.d/${UNAME}" \
# Create group
    && echo "${GNAME}:x:${GID}:${UNAME}" \
    >> /etc/group



# Install Java.
RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y ant && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;


ARG SCALA_VERSION
ENV SCALA_VERSION ${SCALA_VERSION:-2.13.1}
ARG SBT_VERSION
ENV SBT_VERSION ${SBT_VERSION:-1.3.3}

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt

# Install Scala
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /usr/share && \
  mv /usr/share/scala-$SCALA_VERSION /usr/share/scala && \
  chown -R root:root /usr/share/scala && \
  chmod -R 755 /usr/share/scala && \
  ln -s /usr/share/scala/bin/scala /usr/local/bin/scala


## setup vim
# https://github.com/JAremko/alpine-vim/

USER $UNAME

# Install Pathogen
RUN mkdir -p \
    $UHOME/bundle \
    $UHOME/.vim/autoload \
    $UHOME/.vim_runtime/temp_dirs \
    && curl -LSso \
    $UHOME/.vim/autoload/pathogen.vim \
    https://tpo.pe/pathogen.vim \
    && echo "execute pathogen#infect('$UHOME/bundle/{}')" \
    > $UHOME/.vimrc \
    && echo "syntax on " \
    >> $UHOME/.vimrc \
    && echo "filetype plugin indent on " \
    >> $UHOME/.vimrc
    && echo "set number" \
    >> $UHOME/.vimrc

# Add SSH Key
ARG SSH_PRV_KEY
ARG SSH_PUB_KEY


RUN mkdir -p $UHOME/.ssh && \
    chmod 0700 $UHOME/.ssh && \
    ssh-keyscan github.com > $UHOME/.ssh/known_hosts

RUN echo "$SSH_PRV_KEY" > $UHOME/.ssh/id_rsa && \
    echo "$SSH_PUB_KEY" > $UHOME/.ssh/id_rsa.pub && \
    chmod 600 $UHOME/.ssh/id_rsa && \
    chmod 600 $UHOME/.ssh/id_rsa.pub


# Plugins
RUN cd $UHOME/bundle/ \
    && git clone --depth 1 https://github.com/pangloss/vim-javascript \
    && git clone --depth 1 https://github.com/scrooloose/nerdcommenter \
    && git clone --depth 1 https://github.com/godlygeek/tabular \
    && git clone --depth 1 https://github.com/Raimondi/delimitMate \
    && git clone --depth 1 https://github.com/nathanaelkane/vim-indent-guides \
    && git clone --depth 1 https://github.com/groenewege/vim-less \
    && git clone --depth 1 https://github.com/othree/html5.vim \
    && git clone --depth 1 https://github.com/elzr/vim-json \
    && git clone --depth 1 https://github.com/bling/vim-airline \
    && git clone --depth 1 https://github.com/easymotion/vim-easymotion \
    && git clone --depth 1 https://github.com/mbbill/undotree \
    && git clone --depth 1 https://github.com/majutsushi/tagbar \
    && git clone --depth 1 https://github.com/vim-scripts/EasyGrep \
    && git clone --depth 1 https://github.com/jlanzarotta/bufexplorer \
    && git clone --depth 1 https://github.com/kien/ctrlp.vim \
    && git clone --depth 1 https://github.com/scrooloose/nerdtree \
    && git clone --depth 1 https://github.com/jistr/vim-nerdtree-tabs \
    && git clone --depth 1 https://github.com/scrooloose/syntastic \
    && git clone --depth 1 https://github.com/tomtom/tlib_vim \
    && git clone --depth 1 https://github.com/marcweber/vim-addon-mw-utils \
    && git clone --depth 1 https://github.com/vim-scripts/taglist.vim \
    && git clone --depth 1 https://github.com/terryma/vim-expand-region \
    && git clone --depth 1 https://github.com/tpope/vim-fugitive \
    && git clone --depth 1 https://github.com/airblade/vim-gitgutter \
    && git clone --depth 1 https://github.com/fatih/vim-go \
    && git clone --depth 1 https://github.com/plasticboy/vim-markdown \
    && git clone --depth 1 https://github.com/michaeljsmith/vim-indent-object \
    && git clone --depth 1 https://github.com/terryma/vim-multiple-cursors \
    && git clone --depth 1 https://github.com/tpope/vim-repeat \
    && git clone --depth 1 https://github.com/tpope/vim-surround \
    && git clone --depth 1 https://github.com/vim-scripts/mru.vim \
    && git clone --depth 1 https://github.com/vim-scripts/YankRing.vim \
    && git clone --depth 1 https://github.com/tpope/vim-haml \
    && git clone --depth 1 https://github.com/SirVer/ultisnips \
    && git clone --depth 1 https://github.com/honza/vim-snippets \
    && git clone --depth 1 https://github.com/derekwyatt/vim-scala \
    && git clone --depth 1 https://github.com/christoomey/vim-tmux-navigator \
    && git clone --depth 1 https://github.com/ekalinin/Dockerfile.vim \
# Theme
    && git clone --depth 1 \
    https://github.com/altercation/vim-colors-solarized

RUN vim -E -c 'execute pathogen#helptags()' -c q ; return 0


ENV TERM=xterm-256color

# List of Vim plugins to disable
ENV DISABLE=""

## setup zsh
RUN curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

## Clone Bach repo
ARG GIT_USER_EMAIL
ARG GIT_USER_NAME
ARG GIT_REPO

RUN cd $UHOME/ \
    && git clone $GIT_REPO \
    && git config --global user.email "$GIT_USER_EMAIL" \
    && git config --global user.name "$GIT_USER_NAME"

WORKDIR $UHOME/Bach

CMD [ "zsh" ]
