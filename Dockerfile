FROM ubuntu:16.04
MAINTAINER Carlos Wei <calos.wei.hk@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak

RUN \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://security.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN \
    dpkg --add-architecture i386 && \
    apt update && \
    apt install locales apt-transport-https ca-certificates curl sudo vim -y && \
    apt install tofrodos iproute2 gawk xvfb gcc git make net-tools libncurses5-dev zsh \
    tftpd zlib1g-dev libssl-dev flex bison libselinux1 gnupg wget diffstat chrpath socat \
    autoconf libtool tar unzip texinfo gcc-multilib build-essential libsdl1.2-dev libglib2.0-dev  \
    libssl-dev screen pax gzip vim net-tools cmake  android-tools-adb android-tools-fastboot      \
    autoconf  automake bc bison build-essential ccache codespell cscope curl device-tree-compiler \
    expect flex ftp-upload gdisk libattr1-dev libcap-dev libfdt-dev libftdi-dev libglib2.0-dev   \
    libgmp-dev libhidapi-dev libmpc-dev libpixman-1-dev libssl-dev libtool make mtools \
    netcat ninja-build python-crypto python3-crypto python-pyelftools ntpdate \
    python3-pyelftools rsync unzip uuid-dev xdg-utils xz-utils lzop cpio libcurl4-gnutls-dev \
    zlib1g-dev proxychains libqt5qml5 libqt5quick5 libqt5quickwidgets5 qml-module-qtquick2 \
    libgsettings-qt1 xinetd tftp-hpa aria2 libncursesw5 -y && \
    rm -rf /var/lib/apt-lists/* && \
    echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure dash

RUN curl https://mirrors.tuna.tsinghua.edu.cn/git/git-repo > /bin/repo && chmod a+x /bin/repo
RUN sed -i "1s/python/python3/" /bin/repo

RUN curl -fsSL https://raw.githubusercontent.com/carloscn/script/refs/heads/master/down_tool_chains/down_toolchain_armhf_linaro_6.3.1.sh | bash
RUN curl -fsSL https://raw.githubusercontent.com/carloscn/script/refs/heads/master/down_tool_chains/down_toolchain_aarch64_linaro_6.3.1.sh | bash

RUN groupadd build -g 1000
RUN useradd -ms /bin/bash -p build build -u 1028 -g 1000 && \
        usermod -aG sudo build && \
        echo "build:build" | chpasswd
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
        locale-gen
ENV LANG en_US.utf8
USER build
WORKDIR /home/build

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" || true

RUN git config --global user.email "carlos.wei.hk@gmail.com" && git config --global user.name "Carlos Wei"
