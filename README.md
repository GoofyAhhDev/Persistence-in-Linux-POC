# Persistence in Linux POC

## DISCLAIMER
_Disclaimer: This script is provided for educational purposes only. Please use it responsibly and only on systems for which you have proper authorization or permission, preferably permission obtained through a signed contract. The author (GoofyAhhDev) accepts no responsibility for any misuse or damage caused by this tool._

## Overview
This project demonstrates the use of different persistence techniques on Linux systems. The techniques showcased allow an attacker to maintain access to a system even after reboots, logins, or other interruptions. This proof-of-concept (POC) focuses on several MITRE Att&&CK methods of persistence.
## Features
- **SSH Key Backdoor**: Enables SSH access to root using a public key.
- **Cron Job**: Schedules a reverse shell to run at every system reboot.
- **Systemd Reverse Shell Service**: Creates a reverse shell service that runs continuously after a system reboot.
- **Bashrc Reverse Shell Trigger**: Modifies the root's `.bashrc` file to execute a reverse shell whenever a root login occurs.

## Requirements
- **Operating System**: Ubuntu 22.04 (or any similar Linux distribution)
- **Dependencies**:
  - NGINX (optional, if you plan to serve the PHP files for reverse shell)
  - PHP (optional, if you're using PHP-based reverse shell exploits)
  - Bash
  - SSH (to enable SSH key-based login)

## Installation

### 1. Install Ubuntu 22.04
Start with a fresh installation of Ubuntu 22.04 or use an existing system.

### 2. Install Required Dependencies

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install nginx php-fpm php-mysql -y
```
This installs the required packages, including NGINX for serving PHP files and PHP for executing reverse shell payloads if needed.

### 3. SSH Configuration

Ensure that SSH key-based authentication is enabled on your traget system. The script will automatically enable it by modifying the SSH config.

### 4. Upload PHP Files (Optional)

If you're using my PHP files for reverse shells or testing vulnerabilities, upload them to /var/www/html or a specific directory within your NGINX server root.

```bash
sudo cp /path/to/your/php/files/* /var/www/html/
```


## How to use

Add from notepad at home
