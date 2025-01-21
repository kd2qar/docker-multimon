FROM debian:stable-slim

WORKDIR /root/

ADD multimon_1.0-7.1_amd64.deb /root/multimon_1.0-7.1_amd64.deb

#RUN sed -i 's:^path-exclude=/usr/share/man/*:#path-exclude=/usr/share/man/*:'   /etc/dpkg/dpkg.cfg.d/docker
RUN sed -i 's:^path-exclude /usr/share/man/*:#path-exclude /usr/share/man/*:g' /etc/dpkg/dpkg.cfg.d/docker

RUN apt-get update;
RUN apt-get install -y man manpages man-db manpages-dev;
RUN apt-get install -y vim vim-common sox libsox-fmt-all sudo less locate;
RUN dpkg -i multimon_1.0-7.1_amd64.deb
RUN updatedb;

COPY --chmod=755 <<"BASHALIAS" /root/.bash_aliases;
alias dir='dir --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -Alh'
alias ls='ls --color=auto'
alias vdir='vdir --color=auto'
BASHALIAS

COPY <<"VIMRCLOCAL" /etc/vim/vimrc.local
set background=dark

if has("autocmd")
  filetype plugin indent on
endif

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

syntax on
set showmatch
set mouse=
VIMRCLOCAL

COPY --chmod=055 <<MARKSUDO /etc/sudoers.d/mark
mark    ALL=(ALL) NOPASSWD: ALL
MARKSUDO
COPY --chmod=055 <<KD2QARSUDO /tc/sudoers.d/kd2qar
kd2qar  ALL=(ALL) NOPASSWD: ALL
KD2QARSUDO

ADD dot.bashrc /root/.bashrc

WORKDIR /soxfiles

CMD /bin/bash

