#!/usr/bin/env bash

while true
do
    PORT=$(( ((RANDOM<<15)|RANDOM) % 49152 + 10000 ))
    status="$(nc -z 127.0.0.1 $PORT < /dev/null &>/dev/null; echo $?)"
    if [ "${status}" != "0" ]; then
        break;
    fi
done
echo $PORT

export CUDA_VISIBLE_DEVICES=0

NGPUS=1

EPOCH=epoch_30

CFG_NAME=kitti_models/pvt_ssd/default/pvt_ssd
TAG_NAME=default

CKPT=output/cfgs/kitti_models/pvt_ssd/default/ckpt/checkpoint_epoch_80.pth

python -m torch.distributed.launch --nproc_per_node=${NGPUS} --master_port $PORT tools/test.py --launcher pytorch --cfg_file output/cfgs/$CFG_NAME.yaml --workers 4 --extra_tag $TAG_NAME --ckpt $CKPT

GT=data/kitti/gt.bin
EVAL=data/kitti/compute_detection_metrics_main
DT_DIR=output/$CFG_NAME/$TAG_NAME/eval/$EPOCH/val/default/final_result/data

$EVAL $DT_DIR/detection_pred.bin $GT
