#!/bin/bash

# Function to check system state and get filename
checkSystemStateAndGetFilename() {
    local filePath="$1"
    
    # Do not use 'local' for filename if you want it to be global
    state=""
    filename=""  # Define filename without 'local' to make it global

    while true; do
        if [[ ! -f "$filePath" ]]; then
            echo "Error: File not found." >&2
            return 1
        fi

        state=""
        filename=""

        while IFS= read -r line; do
            if [[ "$line" == systemState:* ]]; then
                state="${line#*: }"
            elif [[ "$line" == fileName:* ]]; then
                filename="${line#*: }"
            fi
            echo "Waiting for signalling file..." >&2
        done < "$filePath"

        if [[ "$state" == "query" ]]; then
            echo "System state is 'query'. Filename: $filename" >&2
            break
        else
            echo "Waiting for system state to become 'query'..." >&2
            sleep 5
        fi
    done

    # Ensure the filename variable is populated before exporting
    if [[ -n "$filename" ]]; then
        export filename  # Export it to make it available globally
    else
        echo "Filename is empty. Exiting." >&2
        return 1
    fi
}

# Main script execution
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <file_path>" >&2
    exit 1
fi

checkSystemStateAndGetFilename "$1"
