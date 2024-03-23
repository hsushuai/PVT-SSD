FROM nvcr.io/nvidia/pytorch:20.11-py3

# Initialize mamba
SHELL ["/bin/bash", "-c"]

RUN rm -rf /opt/conda && apt-get update
RUN wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" \
    && bash Miniforge3.sh -b
RUN echo "export PATH="/root/miniforge3/bin:$PATH"" >> ~/.bashrc && source ~/.bashrc

# Set up environment
RUN apt-get install -y libgl1-mesa-glx

# Install packages
RUN /root/miniforge3/bin/mamba install -y pytorch==1.11.0 torchvision==0.12.0 cudatoolkit=11.1 -c pytorch -c conda-forge
RUN /root/miniforge3/bin/mamba install -y -c fvcore -c iopath -c conda-forge fvcore iopath
RUN /root/miniforge3/bin/mamba install -y pytorch3d -c pytorch3d

RUN /root/miniforge3/bin/pip3 install numpy==1.19.5 protobuf==3.19.4 scikit-image==0.19.2 waymo-open-dataset-tf-2-2-0 \
    nuscenes-devkit==1.0.5 einops==0.6.0 spconv-cu111 numba scipy pyyaml easydict fire tqdm shapely matplotlib \
    opencv-python addict pyquaternion awscli open3d pandas future pybind11 tensorboardX tensorboard Cython
RUN wget https://data.pyg.org/whl/torch-1.11.0%2Bcu113/torch_scatter-2.0.9-cp310-cp310-linux_x86_64.whl \
    -O /tmp/torch_scatter-2.0.9-cp310-cp310-linux_x86_64.whl \
    && /root/miniforge3/bin/pip3 install /tmp/torch_scatter-2.0.9-cp310-cp310-linux_x86_64.whl
