
#!/bin/bash

CUSTOM_SCRIPT="node-down.sh"  # The script to run on worker nodes to stop Docker containers
> "/root/project-2/db/temp_node.csv"  # Clear the temporary node file

check_gpu_difference() {

    # Check if the active node file is not empty
    if [ -s "/root/project-2/db/active_node.csv" ]; then
        
        # Loop through each entry in the active node file
        while read entry; do
        
            # Extract IP address, timestamp, and last recorded GPU utilization from the entry
            MAIN_SERVER=$(echo "$entry" | cut -d',' -f1)
            last_timestamp=$(echo "$entry" | cut -d',' -f2)
            last_utilization=$(echo "$entry" | cut -d',' -f3 | tr -d '%')
        
            # Convert timestamp to seconds since epoch for time difference calculation
            last_timestamp_sec=$(date -d "$last_timestamp" +%s)
            current_time_sec=$(date +%s)
            time_diff=$((current_time_sec - last_timestamp_sec))  # Calculate time difference
        
            # Get the current GPU utilization on the worker node
            current_utilization=$(cat /root/project-2/db/a_metric)
            utilization_diff=$((last_utilization - current_utilization))  # Calculate GPU utilization difference
        
            # Check if the utilization difference is less than 60%
            if [ "${utilization_diff#-}" -lt 60 ]; then
                ssh -t $MAIN_SERVER $CUSTOM_SCRIPT  # SSH into the worker node and run the scale-down script
            else
                echo "$entry" >> "/root/project-2/db/temp_node.csv"  # Keep the node active by storing in temp file
            fi
        
        done < "/root/project-2/db/active_node.csv"  # Read active nodes from the active node file
    fi

    # Replace the active node file with the temporary file if it is not empty
    if [ -s "/root/project-2/db/temp_node.csv" ]; then
        cat "/root/project-2/db/temp_node.csv" > "/root/project-2/db/active_node.csv"
    fi
}

# Continuously check GPU utilization differences and scale down if necessary
while true; do
    check_gpu_difference
    sleep 120  # Wait for 2 minutes before checking again
done








