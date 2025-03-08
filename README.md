# nginx scripts
virtual host and modules install scripts

### Remarks
This scripts were tested on Ubuntu / Debian Systems only

# NGINX Modules Install Script

## Overview
This script automates the installation and configuration of essential NGINX modules, 
including user authentication, secure pages, and CGI script execution.

## Usage

### Running the Script
bash
chmod +x modules_install.sh
./modules_install.sh <domain> <nginx_username>


### Arguments
- <domain>: The domain name for the NGINX configuration.
- <nginx_username>: The username for HTTP authentication.

### Options
- -h, --help: Show help message and exit.

## Features
- Installs required utilities for NGINX:
  - apache2-utils
  - nginx-extras
  - libpam0g-dev
  - libpam-modules
  - fcgiwrap
- Configures authentication for secure pages.
- Enables CGI script execution.
- Verifies required NGINX modules.
- Ensures non-root execution for security.
- Automatically updates and installs necessary packages.

## Prerequisites
- NGINX must be installed.
- The script must be run with a *non-root user*.
- Ensure the domain is properly configured in NGINX.

## Example Usage
bash
./nginx_modules_install.sh example.com myuser


This will:
1. Install required NGINX modules.
2. Configure HTTP authentication for /secure/ path.
3. Enable CGI execution at /cgi-bin/.
4. Provide an example CGI script at http://example.com/cgi-bin/test.cgi.

## Notes
- The script automatically updates package lists.
- If NGINX version is below *1.7.4*, the script will exit due to missing user_dir support.
- Authentication settings and CGI configurations are appended to NGINX site configuration.

## Troubleshooting
- Run nginx -t to check for syntax errors in the configuration.
- Ensure /usr/lib/cgi-bin/test.cgi has execute permissions (chmod +x).
- If authentication fails, check the .htpasswd file at /etc/nginx/.htpasswd.

## License
This script is provided as-is with no warranty. Use at your own risk



# Nginx Virtual Host Install Script

## Overview
This Bash script automates the process of setting up an Nginx virtual host on a Linux system. It performs the following actions:
- Checks if Nginx is installed and running.
- Creates a domain folder with appropriate permissions.
- Generates an Nginx configuration file for the virtual host.
- Creates a symbolic link to enable the site.
- Adds an `index.html` file for basic validation.
- Tests the Nginx configuration.
- Updates `/etc/hosts` for local development.

## Requirements
- A Linux-based system (Debian/Ubuntu recommended).
- Nginx installed (`sudo apt update && sudo apt install nginx -y`).
- `systemctl` for service management.
- `firefox` for opening the site automatically.

## Installation
Clone this repository and navigate into the directory:
```sh
git clone https://github.com/yourusername/nginx-modules-install.git
cd nginx-modules-install
```

## Usage
To create a new virtual host, run the script with the desired domain name:
```sh
./nginx_setup.sh example.com
```

### Options:
- `-h`, `--help`: Display usage information.
- `domain_name`: The name of the virtual host (e.g., `example.com`).

## Features
- **Automated Nginx Check**: Ensures Nginx is installed and running.
- **Virtual Host Setup**: Creates the necessary directory structure.
- **Config Generation**: Generates a valid Nginx configuration.
- **Error Handling**: Cleans up if something goes wrong.
- **Local Testing**: Adds the domain to `/etc/hosts`.

## Example
```sh
./nginx_setup.sh mysite.local
```
This will:
1. Verify Nginx installation.
2. Create `/var/www/mysite.local` and subdirectories.
3. Generate an Nginx config file in `/etc/nginx/sites-available/`.
4. Enable the site with a symlink in `/etc/nginx/sites-enabled/`.
5. Restart Nginx and validate the configuration.
6. Open the new site in Firefox.

## Troubleshooting
If you encounter issues:
- Check Nginx status: `systemctl status nginx`
- Test configuration manually: `nginx -t`
- Remove a virtual host: Run the script again with the same domain and choose "yes" when prompted.

## License
This project is licensed under the MIT License.

## Author
Created by Meir on 7/3/25.
