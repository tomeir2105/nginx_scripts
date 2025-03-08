# nginx scripts
virtual host and modules install scripts

# Remarks
##  This script was tested on Ubuntu / Debian Systems only

# NGINX Modules Install Script

## Overview

This script automates the installation and configuration of essential NGINX modules, including user authentication, secure pages, and CGI script execution.

## Usage

### Running the Script

bash
./nginx_modules_install.sh <domain> <nginx_username>


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
