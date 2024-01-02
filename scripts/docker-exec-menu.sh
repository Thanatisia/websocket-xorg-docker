#!/bin/env bash
: "
Docker container execution script

- Operational Flow
    - For/While loop until break condition is met
        - Break Conditions
            - If keyword 'q' or 'quit' is entered
        - Get user input
            - Sanitize
        - Enter the container
            - Execute command as a background process '&'
"
# Initialize Variables
container_name="${1:-""}"
shell="${SHELL:-/bin/bash}"
input_str=""

# Check if container is provided
if [[ "$container_name" != "" ]]; then
    # Check if container exists
    # Begin execution menu
    while true; do
        # Get user input
        read -p "> " input_str
        
        # Break condition
        if [[ "$input_str" == "q" ]] || [[ "$input_str" == "quit" ]]; then
            exit
        else
            # Execute command in container
            docker exec -t $container_name $shell -c "$input_str" &
        fi

        # Sleep for half a second to flush and finish the previous standard output before proceeding
        sleep 0.5

        # Reset user input
        input_str=""
    done
    # echo -e "Container $container_name does not exists."
else
    echo -e "Container not provided."
fi


