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

# Function: log
# Description: Outputs log messages with a timestamp
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function: set_apt_proxy
# Description: Configures the APT proxy settings.
set_apt_proxy() {
    log "Configuring APT proxy..."
    if [ -f "$APT_CONF" ]; then
        log "APT proxy already set. Checking if update is needed..."
        current_proxy=$(grep -oP '(?<=Acquire::http::Proxy ").*?(?=";)' "$APT_CONF" || true)
        if [ "$current_proxy" != "$PROXY_URL" ]; then
            log "Updating APT proxy URL..."
            sudo sed -i "s|^Acquire::http::Proxy \".*\"|Acquire::http::Proxy \"$PROXY_URL\"|g" "$APT_CONF"
            log "APT proxy URL updated."
        else
            log "APT proxy URL is already set to the desired value. No update needed."
        fi
    else
        log "Setting APT proxy for the first time..."
        echo "Acquire::http::Proxy \"$PROXY_URL\";" | sudo tee "$APT_CONF" > /dev/null
        log "APT proxy configuration complete."
    fi
}

# Function: setup_cron
# Description: Sets up a cron job to run this script every night at 01:00.
setup_cron() {
    log "Setting up cron job..."

    # Check if the cron job already exists to avoid duplication
    if sudo crontab -l 2>/dev/null | grep -qF "$SCRIPT_PATH"; then
        log "Cron job already exists."
    else
        # Add the cron job to the root user's crontab
        (sudo crontab -l 2>/dev/null; echo "$CRON_JOB") | sudo crontab -
        log "Cron job added."
    fi

    log "Cron job set to run every night at 01:00."
}

# Function: update_apt
# Description: Updates and upgrades APT packages.
update_apt() {
    log "Updating APT..."
    sudo apt-get update -y && sudo apt-get upgrade -y
    log "APT update and upgrade complete."
}

# Function: check_script_location
# Description: Checks if the script is in the correct location and moves it if necessary.
check_script_location() {
    if [ "$(realpath "$0")" != "$SCRIPT_PATH" ]; then
        log "Script is not located at $SCRIPT_PATH. Moving it..."
        sudo mv "$0" "$SCRIPT_PATH"
        sudo chmod +x "$SCRIPT_PATH"
        log "Script moved to $SCRIPT_PATH and made executable."
        log "Please run the script again from its new location."
        exit 0
    else
        log "Script is already in the correct location."
    fi
}

# Function: main
# Description: Main function to execute the script's logic.
main() {
    # Check if the script is in the correct location
    check_script_location

    # Update APT
    update_apt

    # Run APT proxy setup
    set_apt_proxy

    # Setup cron job
    setup_cron

    log "All tasks completed successfully."
}

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use sudo." >&2
    exit 1
fi

# Start the script
main
