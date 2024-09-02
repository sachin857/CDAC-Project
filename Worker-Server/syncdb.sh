
#!/bin/bash


while true; do

 
    echo $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print $1}') > /root/project-2/db/a_metric

 # make sure to add master ip below
    rsync /root/project-2/db/* <master-ip>:/root/project-2/db/

    
    sleep 120
done





