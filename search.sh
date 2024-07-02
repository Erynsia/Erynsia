#!/bin/bash

# ANSI color codes
GREEN='\033[92m'  # Green color
RED='\033[91m'    # Red color
RESET='\033[0m'   # Reset to default color

# Function to check domain status
check_domains() {
    while IFS= read -r domain; do
        domain=$(echo "$domain" | tr -d '[:space:]')  # Remove any leading/trailing whitespace
        if [ -z "$domain" ]; then
            continue  # Skip empty lines
        fi
        url="http://$domain"
        
        # Use curl with --max-time 5 to timeout after 5 seconds
        status_code=$(curl -s --max-time 5 -o /dev/null -w "%{http_code}" "$url")
        
        if [ $? -ne 0 ]; then
            echo -e "${domain}: ${RED}Connection Error${RESET}"
        elif [ "$status_code" == "200" ]; then
            echo -e "${domain}: ${GREEN}${status_code} OK${RESET}"
        elif [ "$status_code" == "404" ]; then
            echo -e "${domain}: ${RED}${status_code} Not Found${RESET}"
        else
            echo -e "${domain}: ${RED}${status_code} Error${RESET}"
        fi
    done < "$1"
}

# Main script
if [ ! -f "$1" ]; then
    echo "Usage: $0 <filename>"
    echo "Please provide a filename containing domain names (one per line)."
    exit 1
fi

echo "Domain Status:"
check_domains "$1"
