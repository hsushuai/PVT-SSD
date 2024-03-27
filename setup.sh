# image url: dsw-registry-vpc.cn-shanghai.cr.aliyuncs.com/pai/pytorch:2.1-gpu-py311-cu118-ubuntu22.04
conda install -y pytorch==1.10.1 torchvision==0.11.2 cudatoolkit=11.1 -c pytorch -c conda-forge && \
conda install -y -c fvcore -c iopath -c conda-forge fvcore iopath && \
conda install -y pytorch3d -c pytorch3d && \
pip install numpy==1.19.5 protobuf==3.19.4 scikit-image==0.19.2 waymo-open-dataset-tf-2-2-0 nuscenes-devkit==1.0.5 einops==0.6.0 spconv-cu111 numba scipy pyyaml easydict fire tqdm shapely matplotlib opencv-python addict pyquaternion awscli open3d pandas future pybind11 tensorboardX tensorboard Cython && \
pip install torch-scatter -f https://data.pyg.org/whl/torch-1.10.1+cu111.html && \
git clone https://github.com/Nightmare-n/PVT-SSD
cd PVT-SSD && python setup.py develop --user

# prepare kitti dataset
openxlab dataset download --dataset-repo OpenDataLab/KITTI_Object --source-path /raw/data_object_calib.zip && \
openxlab dataset download --dataset-repo OpenDataLab/KITTI_Object --source-path /raw/data_object_image_2.zip && \
openxlab dataset download --dataset-repo OpenDataLab/KITTI_Object --source-path /raw/data_object_label_2.zip && \
openxlab dataset download --dataset-repo OpenDataLab/KITTI_Object --source-path /raw/data_object_velodyne.zip && \
cd OpenDataLab___KITTI_Object/raw && \
unzip data_object_calib.zip && \
rm data_object_calib.zip && \
unzip data_object_image_2.zip && \
rm data_object_image_2.zip && \
unzip data_object_label_2.zip && \
rm data_object_label_2.zip && \
unzip data_object_velodyne.zip && \
rm data_object_velodyne.zip && \
mv training ../../data/kitti/ && \
mv testing ../../data/kitti/ && \
cd ../../ && \
rm -r OpenDataLab___KITTI_Object