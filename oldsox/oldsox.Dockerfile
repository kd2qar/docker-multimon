from debian:stable as builder

RUN apt-get update
RUN apt-get install -y build-essential make cmake vim
RUN apt-get install -y libx11-dev
RUN apt-get install -y aptitude
RUN apt-get install -y locate && updatedb

#OpencoreAMR-NB/WB http://sourceforge.net/projects/opencore-amr  Apache
#VisualOn AMR-WB   http://sourceforge.net/projects/opencore-amr  Apache
#AO                http://xiph.org/ao                    GPL
#FLAC              http://flac.sourceforge.net           BSD
#LADSPA            http://www.ladspa.org                 LGPL + plugins' l
#Lame MP3 encoder  http://lame.sourceforge.net           LGPL
#Twolame MP2 enc.  http://www.twolame.org                LGPL
#libltdl           http://www.gnu.org/software/libtool   LGPL
#MAD MP3 decoder   http://www.underbit.com/products/mad  GPL
#MP3 ID3 tags      http://www.underbit.com/products/mad  GPL
#Magic             http://www.darwinsys.com/file         BSD
#Ogg Vorbis        http://www.vorbis.com                 BSD
#Opus              http://www.opus-codec.org/            BSD
#PNG               http://www.libpng.org/pub/png         zlib (BSD-like)
#Sndfile           http://www.mega-nerd.com/libsndfile   LGPL
#WavPack           http://www.wavpack.com                BSD

RUN apt-get install -y ffmpeg lame libasound-dev libvorbis-dev libmp3lame-dev libmp3lame-ocaml-dev \
	libtwolame-dev libflac-dev gawk libsamplerate-dev libsndfile-dev libgsmme-dev \
	libgsm1-dev libmad0-dev aoflagger-dev aom-tools libsndfile-dev libavfilter-dev \
	libavcodec-dev libavdevice-dev libavc1394-dev libavif-dev libavifile-0.7-dev libavutil-dev  \
	libvo-amrwbenc-dev libopencore-amrwb-dev  
RUN apt-get install -y libao-dev libffmpegthumbnailer-dev libopencore-amrnb-dev libvo-amrwbenc-dev \
	libvo-amrwbenc-dev ladspa-sdk-dev 
RUN apt-get install -y libladspa-ocaml-dev libmp3lame-ocaml-dev libopus-ocaml-dev libmad-ocaml-dev \
	libflac-ocaml-dev 

RUN apt-get install -y libpng-dev  libwavpack-dev libopusenc-dev libopusfile-dev \
	libvorbisidec-dev libmagic-dev libibmad-dev libibumad-dev libflac++-dev libaom-dev

RUN apt-get install -y ladspa-sdk-dev  bs2b-ladspa csladspa dpf-plugins-ladspa \
	guitarix-ladspa invada-studio-plugins-ladspa lsp-plugins-ladspa rubberband-ladspa 

RUN	apt-get install -y wah-plugins vco-plugins tap-plugins swh-plugins ste-plugins rev-plugins \
	omins mcp-plugins lsp-plugins-ladspa ladspa-sdk invada-studio-plugins-ladspa guitarix-ladspa \
	fil-plugins dpf-plugins-ladspa csladspa cmt caps bs2b-ladspa blop blepvco autotalent ambdec \
	amb-plugins

COPY <<VIMRC /root/.vimrc
set background=dark
set mouse=
set shiftwidth=2
set tabstop=4
syntax on
VIMRC

COPY <<DOT_BASHRC /root/.bashrc

alias ls='ls --color'
alias ll='ls -Alh'

DOT_BASHRC

RUN apt-get install -y dpkg-dev devscripts

RUN git clone https://git.code.sf.net/p/sox/code /root/sox-code

WORKDIR /root/sox-code/

#git checkout tags/sox-14.2.0 ## will not build
RUN git tag --list>/root/tags
#RUN git checkout tags/sox-14.4.2
# sox-14-4.1 is old enough to map the deprecated arguments to
#            the equivalent new arguments
RUN git checkout tags/sox-14.4.1

RUN autoreconf -i --force
RUN ./configure
RUN make && make install
RUN make install

WORKDIR /root/
