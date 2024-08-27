#!/bin/bash

#echo $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print $1}') > /root/project-2/db/a_metric
#rsync /root/project-2/db/* 192.168.82.164:/root/project-2/db/
#echo "1" >> /root/project-2/db/test

while true; do
    echo $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print $1}') > /root/project-2/db/a_metric
    rsync /root/project-2/db/* 192.168.82.164:/root/project-2/db/
    sleep 120
done
