FROM ubuntu:16.04

RUN apt -y update

RUN apt -y install \
	git \
	wget \
	autoconf \
	automake \
	make \
	gcc \
	perl \
	zlib1g-dev \
	bzip2 \
	libbz2-dev \
	xz-utils \
	liblzma-dev \
	curl \
	libcurl4-openssl-dev \
	libssl-dev \
	ncurses-dev \
	graphviz \
	unzip \
	zip \
	rsync

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

COPY environment.yml /
ARG MAMBA_DOCKERFILE_ACTIVATE=1
RUN . /opt/conda/etc/profile.d/conda.sh && \ 
    conda activate base && \
    conda update conda && \
    conda install -c conda-forge mamba && \
    mamba env create -f /environment.yml && \
    mamba clean -a


RUN mkdir -p /project /nl /mnt /share
ENV PATH /opt/conda/envs/dolphinnext/bin:$PATH

RUN apt-get update
RUN apt-get install -y --reinstall build-essential
RUN cd /usr/local/share && git clone https://github.com/AlexandrovLab/SigProfilerMatrixGenerator.git
COPY install.py /usr/local/share/SigProfilerMatrixGenerator/SigProfilerMatrixGenerator/
RUN pip install /usr/local/share/SigProfilerMatrixGenerator 
COPY installMouse.py /
RUN python installMouse.py  
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools.static.binary && \
    mv bedtools.static.binary /usr/local/bin/bedtools && chmod 755 /usr/local/bin/bedtools

