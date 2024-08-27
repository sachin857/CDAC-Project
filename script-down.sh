
#!/bin/bash

CUSTOM_SCRIPT="node-down.sh"
#ACTIVE_NODE_FILE="/root/project-2/db/active_node.csv"
> "/root/project-2/db/temp_node.csv"

check_gpu_difference() {


if [ -s "/root/project-2/db/active_node.csv" ]; then
    
    while read entry; do
	
	    MAIN_SERVER=$(echo "$entry" | cut -d',' -f1)
	    last_timestamp=$(echo "$entry" | cut -d',' -f2)
	    last_utilization=$(echo "$entry" | cut -d',' -f3 | tr -d '%')
	
	    last_timestamp_sec=$(date -d "$last_timestamp" +%s)
	    current_time_sec=$(date +%s)
	    time_diff=$((current_time_sec - last_timestamp_sec))

	    
	    
	    current_utilization=$(cat /root/project-2/db/a_metric)
	    
	    utilization_diff=$((last_utilization - current_utilization))

	    #echo "Time difference: $time_diff seconds"
	    #echo "Utilization difference: $utilization_diff%"

	    
	    if [ "${utilization_diff#-}" -lt 60 ]; then
	        
	        ssh -t $MAIN_SERVER $CUSTOM_SCRIPT
	       	       
	    else
	    	echo "$entry" >> "/root/project-2/db/temp_node.csv"
	    fi
    
    done < "/root/project-2/db/active_node.csv"
fi


if [ -s "/root/project-2/db/temp_node.csv" ]; then

    cat "/root/project-2/db/temp_node.csv" > "/root/project-2/db/active_node.csv"

fi

}


while true; do
    check_gpu_utilization
    sleep 120
done
