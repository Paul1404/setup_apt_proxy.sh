#!/bin/bash

# ==============================================
# Script Name: setup_apt_proxy.sh
# Author: Paul Dresch
# Date: 2024-09-05
# Description: This script configures the APT proxy settings,
#              performs an APT update and upgrade, and sets up a cron job 
#              to run the script nightly at 01:00.
# Usage: sudo /usr/local/bin/setup_apt_proxy.sh
# ==============================================

# Exit immediately if a command exits with a non-zero status
set -e

# Constants
PROXY_URL="http://apt-cacher.home.local:3142"
APT_CONF="/etc/apt/apt.conf.d/01proxy"
SCRIPT_PATH="/usr/local/bin/setup_apt_proxy.sh"
CRON_JOB="0 1 * * * $SCRIPT_PATH"

# Function: set_apt_proxy
# Description: Configures the APT proxy settings.
set_apt_proxy() {
    echo "Configuring APT proxy..."
    if [ -f "$APT_CONF" ]; then
        echo "APT proxy already set. Updating proxy URL..."
        sudo sed -i "s|^Acquire::http::Proxy \".*\"|Acquire::http::Proxy \"$PROXY_URL\"|g" "$APT_CONF"
    else
        echo "Setting APT proxy for the first time..."
        echo "Acquire::http::Proxy \"$PROXY_URL\";" | sudo tee "$APT_CONF" > /dev/null
    fi
    echo "APT proxy configuration complete."
}

# Function: setup_cron
# Description: Sets up a cron job to run this script every night at 01:00.
setup_cron() {
    echo "Setting up cron job..."

    # Check if the cron job already exists to avoid duplication
    if sudo crontab -l 2>/dev/null | grep -qF "$SCRIPT_PATH"; then
        echo "Cron job already exists."
    else
        # Add the cron job to the root user's crontab
        (sudo crontab -l 2>/dev/null; echo "$CRON_JOB") | sudo crontab -
        echo "Cron job added."
    fi

    echo "Cron job set to run every night at 01:00."
}

# Function: update_apt
# Description: Updates and upgrades APT packages.
update_apt() {
    echo "Updating APT..."
    sudo apt-get update -y && sudo apt-get upgrade -y
    echo "APT update and upgrade complete."
}

# Function: main
# Description: Main function to execute the script's logic.
main() {
    # Update APT
    update_apt

    # Run APT proxy setup
    set_apt_proxy

    # Setup cron job
    setup_cron

    echo "All tasks completed successfully."
}

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use sudo." >&2
    exit 1
fi

# Start the script
main
