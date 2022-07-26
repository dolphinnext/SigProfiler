FROM ubuntu:xenial

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
RUN . /opt/conda/etc/profile.d/conda.sh && \ 
    conda activate base && \
    conda update conda && \
    conda install -c conda-forge mamba && \
    mamba env create -f /environment.yml && \
    mamba clean -a

RUN pip install SigProfilerMatrixGenerator
RUN pip install SigProfilerExtractor

RUN mkdir -p /project /nl /mnt /share
ENV PATH /opt/conda/envs/dolphinnext/bin:$PATH

# R Packages Installation
COPY install_packages.R /
RUN Rscript /install_packages.R
