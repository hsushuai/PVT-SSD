FROM nvidia/cuda:11.1.1-devel-ubuntu18.04

# Install basic utilities and dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    wget \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and switch to it
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
    && chown -R user:user /app \
    && echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user

USER user
ENV HOME=/home/user

# Install Miniconda and Python 3.7
ENV CONDA_AUTO_UPDATE_CONDA=false \
    PATH=/home/user/miniconda/bin:$PATH
RUN curl -sLo ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh \
    && chmod +x ~/miniconda.sh \
    && ~/miniconda.sh -b -p ~/miniconda \
    && rm ~/miniconda.sh \
    && ~/miniconda/bin/conda install -y python==3.7 \
    && ~/miniconda/bin/conda clean -ya

# Install PyTorch and dependencies
RUN ~/miniconda/bin/conda install -y pytorch==1.10.1 torchvision==0.11.2 cudatoolkit=11.1 -c pytorch \
    && ~/miniconda/bin/conda clean -ya

# Set the default command to python3
CMD ["python3"]
