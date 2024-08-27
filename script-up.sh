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
