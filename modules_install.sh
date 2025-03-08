#!/usr/bin/env bash
######################################
# Created by : Meir
# Purpose : nginx modules install script
# Date : 7/3/25
# Version : 1
#set -x
set -o errexit
set -o pipefail
set -o nounset
#####################################

NGINX_VERSION=$(nginx -v 2>&1 | awk -F/ '{print $2}' | sed 's/ .*//')
HTPASSWD_FILE="/etc/nginx/.htpasswd"
UTILITIES=(
    'apache2-utils' 
    'nginx-extras'
    'libpam0g-dev'
    'libpam-modules'
    'fcgiwrap'
)

show_help() {
    echo "Usage: $0 <domain> <nginx_username>"
    echo "Installs required modules for NGINX."
    echo
    echo "Arguments:"
    echo "  <domain>          The domain name for NGINX configuration."
    echo "  <nginx_username>  The username for HTTP authentication."
    echo
    echo "Options:"
    echo "  -h, --help        Show this help message and exit."
    exit 0
}

if [[ $# -lt 2 ]]; then
    echo "Error: Missing arguments."
    show_help
    exit 1
fi
# This can not be first, beacuse $1 $2 need exist check
NGINX_USERNAME="$2"
DOMAIN="$1"

if [[ $# -eq 1 && ( "$1" == "-h" || "$1" == "--help" ) ]]; then
    show_help
    exit 1
fi

# VERIFY NOT ROOT USER
if [ "$(id -u)" -eq 0 ]; then
    echo "Run script with non-root user."
    exit 1
fi


main_script() {
    echo "This tool will install user_dir, secure page and cgi example script on nginx"
    echo "NGINX Version $NGINX_VERSION"
    echo "Installing packages in background... have patience"
    update_apt
    install_utilities
    check_user_dir_module
    check_auth_module
    #check_cgi_module
    #create_new_user_password
    #add_auth_to_nginx
    add_cgi_to_nginx
    echo "browse to http://$DOMAIN/cgi-bin/test.cgi to check cgi"
    echo "use - curl -u user:password -I http://$DOMAIN/secure/"
}

update_apt(){
        sudo apt-get update > /dev/null 2>&1
}

install_utilities(){
    for UTIL in "${UTILITIES[@]}"; do
        sudo apt-get install -y $UTIL > /dev/null 2>&1
        if dpkg -s $UTIL &>/dev/null; then
            echo "$UTIL installed successfully."
        else
            echo "$UTIL installation failed."
            exit 1
        fi
    done
}

create_new_user_password(){
    echo "Enter password for nginx user"
    sudo htpasswd -c $HTPASSWD_FILE $NGINX_USERNAME
    if [ ! -f "$HTPASSWD_FILE" ]; then
        echo "Error: The .htpasswd file does not exist at $HTPASSWD_FILE."
        exit 1
    fi
    if [ ! -s "$HTPASSWD_FILE" ]; then
        echo "Error: The .htpasswd file is empty."
        exit 1
    fi
    if ! grep -q "^$NGINX_USERNAME:" "$HTPASSWD_FILE"; then
        echo "Error: User '$NGINX_USERNAME' not found in the .htpasswd file."
        exit 1
    fi
    echo "NGINX user $NGINX_USERNAME created."
}

add_auth_to_nginx() {
    conf_file="/etc/nginx/sites-available/$DOMAIN"
    
    if [ ! -f "$conf_file" ]; then
        echo "Error: $DOMAIN does not exist."
        exit 1
    fi
    
    if grep -q "location /secure" "$conf_file"; then
        echo "Error: The location /secure block already exists in the configuration file."
        exit 1
    fi
    
    if [ ! -d  "/var/www/$DOMAIN/html/secure" ]; then 
        echo "Creating secure folder"
        sudo mkdir -p "/var/www/$DOMAIN/html/secure"
        echo "This is the secure area" | sudo tee "/var/www/$DOMAIN/html/secure/index.html"
    fi
    
    echo "Adding the authentication block for /secure to $conf_file"
    
    sudo sed -i '$s/}$//' $conf_file # Inline REMOVE LAST }
    echo "    location /secure {
            auth_basic \"Restricted Access\";
            auth_basic_user_file /etc/nginx/.htpasswd;
            root /var/www/$DOMAIN/html;
            index index.html; 
        }
    }" | sudo tee -a "$conf_file"
    echo "Testing the NGINX configuration for syntax errors..."
    sudo nginx -t
    if [ $? -ne 0 ]; then
        echo "Error: NGINX configuration test failed. Please fix the errors above."
        exit 1
    fi
    
    echo "Reloading NGINX to apply the auth changes..."
    sudo systemctl restart nginx
}


add_cgi_to_nginx() {
    conf_file="/etc/nginx/sites-available/$DOMAIN"
    if grep -q "location /cgi-bin" "$conf_file"; then
        echo "Error: The location /secure block already exists in the configuration file."
        exit 1
    fi
    echo "Adding cgi to $conf_file"
    sudo sed -i '$s/}$//' $conf_file # Inline REMOVE LAST }
    echo "    location /cgi-bin/ {
        root /usr/lib;
        fastcgi_pass unix:/run/fcgiwrap.socket;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
        }
    }" | sudo tee -a "$conf_file"
    echo "Testing the NGINX configuration for syntax errors."
    sudo nginx -t
    if [ $? -ne 0 ]; then
        echo "Error: NGINX configuration test failed. Please fix the errors above."
        exit 1
    fi
    echo "Reloading NGINX and fcgiwrap to apply the cgi changes..."
    sudo systemctl restart fcgiwrap
    sudo systemctl restart nginx
    # create an example script
    sudo mkdir -p /usr/lib/cgi-bin
    echo -e '#!/bin/bash\necho "Content-type: text/plain"\necho\necho "Hello, CGI!"' | sudo tee /usr/lib/cgi-bin/test.cgi
    sudo chmod +x /usr/lib/cgi-bin/test.cgi
}

check_user_dir_module(){
    minimum_version="1.7.4"
    # Hope versions fits to this method... very complicated to check.
    nginx_min_version_number=$(echo "$NGINX_VERSION" | tr -d '.')
    minimum_version_number=$(echo "$minimum_version" | tr -d '.')
    
    # Compare the numeric versions
    if [[ "$nginx_min_version_number" -lt "$minimum_version_number" ]]; then
        echo "Your NGINX version $NGINX_VERSION is not supported."
        echo "Missing userdir module."
        exit 1
    else
        echo "USER DIR is supported ($NGINX_VERSION > 1.7.4)"
    fi
}



check_auth_module(){
    echo check_auth_module
}

check_cgi_module(){
    echo check_cgi_module
}


main_script
