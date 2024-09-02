
#!/bin/bash

# Continuously monitor GPU utilization and sync the data with the master node
while true; do

    # Capture the current GPU utilization percentage and save it to the a_metric file
    echo $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print $1}') > /root/project-2/db/a_metric

    # Sync the GPU metric and other data from the worker node to the master node using rsync
    rsync /root/project-2/db/* <master-ip>:/root/project-2/db/

    # Wait for 120 seconds before repeating the process
    sleep 120
done





