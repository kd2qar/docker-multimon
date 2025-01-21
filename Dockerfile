from debian:stable as builder

RUN <<XYZ
cat <<SOURCES >>/etc/apt/sources.list.d/debian.sources
Types: deb-src
# http://snapshot.debian.org/archive/debian/20250113T000000Z
URIs: http://deb.debian.org/debian
Suites: stable stable-updates
Components: main
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
SOURCES

XYZ
#RUN sed -i 's:^path-exclude=/usr/share/man:#path-exclude=/usr/share/man:' \
#        /etc/dpkg/dpkg.cfg.d/excludes
#RUN sed -i 's:^path-exclude=/usr/share/man/*:#path-exclude=/usr/share/man/*:g' /etc/dpkg/dpkg.cfg.d/docker

RUN apt-get update
RUN apt-get install -y build-essential make cmake vim
RUN apt-get install -y libx11-dev
RUN apt-get install -y aptitude
RUN apt-get install -y locate && updatedb

ADD dot.vimrc /root/.vimrc

COPY <<DOT_BASHRC /root/.bashrc

alias ls='ls --color'
alias ll='ls -Alh'

DOT_BASHRC

WORKDIR /root/
RUN apt-get source multimon
RUN tar -czvf multimon-deb-source.tar.gz multimon-1.0

RUN apt-get install -y dpkg-dev devscripts
RUN apt build-dep multimon

COPY --chmod=755 <<BUILDDEP /root/multimon-1.0/buildit
#!/bin/bash
apt build-dep multimon
debuild -b -uc -us

BUILDDEP

WORKDIR /root/multimon-1.0
ADD gen.c.patch       /root/multimon-1.0/gen.c.patch
ADD unixinput.c.patch /root/multimon-1.0/unixinput.c.patch
RUN patch -p1 < gen.c.patch
RUN patch -p1 < unixinput.c.patch
RUN debuild -b -uc -us

WORKDIR /root/

