# APT Proxy Setup Script

## Overview

This Bash script, `setup_apt_proxy.sh`, is designed to automate the configuration of an APT proxy, update the system's APT package list, and set up a cron job to perform these tasks nightly. The script is ideal for environments where an APT proxy is used to cache package downloads to improve network efficiency.

Heres a quick oneliner to get started:

```bash
sudo wget -qO /usr/local/bin/setup_apt_proxy.sh https://raw.githubusercontent.com/Paul1404/setup_apt_proxy.sh/main/setup_apt_proxy.sh && sudo chmod +x /usr/local/bin/setup_apt_proxy.sh && sudo /usr/local/bin/setup_apt_proxy.sh
```

## Features

- **APT Proxy Configuration**: Automatically sets or updates the APT proxy configuration file.
- **APT Update and Upgrade**: Updates and upgrades the APT package lists and installed packages.
- **Cron Job Setup**: Sets up a cron job to run the script every night at 01:00 to ensure the proxy configuration and package lists are always up-to-date.
- **Non-Interactive Execution**: Designed to run non-interactively, making it suitable for automated environments.

## Requirements

- **Operating System**: Linux (Debian-based distributions recommended)
- **Permissions**: The script must be run with root or sudo privileges.
- **APT Proxy**: Requires a functional APT proxy server (e.g., `apt-cacher-ng`) configured and running.

## Installation

1. **Download the Script**: Place the `setup_apt_proxy.sh` script in `/usr/local/bin/` or another directory in your `PATH`.
2. **Make the Script Executable**:
   ```bash
   sudo chmod +x /usr/local/bin/setup_apt_proxy.sh

Usage
-----

Run the script with `sudo` to perform all tasks:

```bash
sudo /usr/local/bin/setup_apt_proxy.sh
```

The script will:

* Update and upgrade APT packages.
* Set or update the APT proxy configuration.
* Set up a cron job to run the script nightly at 01:00.

Script Details
--------------

### Functions

* `set_apt_proxy()`: Configures the APT proxy settings.
* `setup_cron()`: Adds a cron job to run the script nightly.
* `update_apt()`: Updates and upgrades APT packages.
* `main()`: Main function that orchestrates the script's execution.

### Variables

* `PROXY_URL`: The URL of the APT proxy server.
* `APT_CONF`: The path to the APT proxy configuration file.
* `SCRIPT_PATH`: The path to this script.
* `CRON_JOB`: The cron job schedule and command.

### Cron Job

The cron job is set up to run every night at 01:00. To view the current cron jobs, use:

```bash
sudo crontab -l
```

Troubleshooting
---------------

* **Permission Issues**: Ensure the script is run with `sudo` or as the root user.
* **Cron Job Not Added**: If the cron job does not appear, verify the script's logic and ensure the system's `cron` service is running.

Contributing
------------

If you have suggestions or improvements, feel free to submit a pull request or open an issue on the GitHub repository.

License
-------

This script is licensed under the MIT License. See the LICENSE file for more details.
