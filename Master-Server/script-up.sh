#!/bin/bash


CUSTOM_SCRIPT="node-up.sh"
THRESHOLD_HIGH=70
INTERVAL=2


ACTIVE_NODE_FILE="/root/project-2/db/active_node.csv"


check_gpu_utilization() {
    utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print $1}')
    echo "Current GPU utilization: $utilization%"

    if [ "$utilization" -gt "$THRESHOLD_HIGH" ]; then
        echo "GPU utilization above $THRESHOLD_HIGH%. Sending alert to main server."
        

       while read ip;do

			if grep -q $ip "/root/project-2/db/active_node.csv";then
				
				continue
				echo "found"
				
			else
				timestamp=$(date '+%Y-%m-%d %H:%M:%S')
		      
		        echo "$ip,$timestamp,$utilization%" >> "$ACTIVE_NODE_FILE"
				ssh -t $ip $CUSTOM_SCRIPT
			fi	

		done < "/root/project-2/db/workers"
    fi
}


while true; do
    check_gpu_utilization
    sleep $INTERVAL
done
-------------------------------------


#!/bin/bash

CUSTOM_SCRIPT="node-up.sh"  # The script to run on worker nodes to start Docker containers
THRESHOLD_HIGH=70  # GPU utilization threshold to trigger scaling up
INTERVAL=2  # Time interval in seconds between checks

ACTIVE_NODE_FILE="/root/project-2/db/active_node.csv"  # File storing active nodes' information

check_gpu_utilization() {
    # Get the current GPU utilization percentage
    utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print $1}')
    echo "Current GPU utilization: $utilization%"

    # Check if GPU utilization exceeds the high threshold
    if [ "$utilization" -gt "$THRESHOLD_HIGH" ]; then
        echo "GPU utilization above $THRESHOLD_HIGH%. Sending alert to main server."
        
        # Loop through each IP address in the worker list
        while read ip; do
            # Check if the IP is already in the active node file
            if grep -q $ip "/root/project-2/db/active_node.csv"; then
                continue  # Skip if the IP is already active
                echo "found"
            else
                # Record the IP, timestamp, and GPU utilization in the active node file
                timestamp=$(date '+%Y-%m-%d %H:%M:%S')
                echo "$ip,$timestamp,$utilization%" >> "$ACTIVE_NODE_FILE"
                
                # SSH into the worker node and run the scale-up script
                ssh -t $ip $CUSTOM_SCRIPT
            fi    
        done < "/root/project-2/db/workers"  # Read worker IPs from the workers file
    fi
}

# Continuously check GPU utilization and scale up if necessary
while true; do
    check_gpu_utilization
    sleep $INTERVAL  # Wait for the specified interval before checking again
done








