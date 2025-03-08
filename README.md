# nginx scripts
virtual host and modules install scripts

# Remarks
##  This script was tested on Ubuntu / Debian Systems only

# Nginx Modules Install Script - modules_install.sh

## Overview
This is a Bash script to automate the installation and configuration of virtual hosts for Nginx on Ubuntu/Debian systems.

## Features
- Checks if Nginx is installed and running
- Creates a new virtual host with proper folder structure and permissions
- Generates an Nginx configuration file
- Enables the virtual host and restarts Nginx
- Adds the domain to /etc/hosts
- Provides cleanup functionality for failed installations

## Prerequisites
- Ubuntu/Debian-based system
- Nginx installed (sudo apt update && sudo apt install nginx -y)
- User with sudo privileges

## Installation
Clone this repository or download the script.


