# NGX Tool Documentation

## Overview
The NGX tool is a bash script to manage Nginx configurations, sites, and logs. It provides various functionalities such as enabling/disabling sites, viewing logs, generating site configurations, and managing SSL certificates.

## Motivation

## Usage
The NGX tool supports the following commands:

### List Sites
- **Command:** `ngx list [--certs]`
- **Description:** Lists all sites in the `sites-available` directory and their enabled/disabled status.

### Enable Site
- **Command:** `ngx enable <SITE>`
- **Description:** Enables the specified site by creating a symbolic link in the `sites-enabled` directory.

### Disable Site
- **Command:** `ngx disable <SITE>`
- **Description:** Disables the specified site by removing the symbolic link from the `sites-enabled` directory.

### Site Status
- **Command:** `ngx status <SITE>`
- **Description:** Shows whether the specified site is enabled or disabled.

### Edit Site
- **Command:** `ngx edit <SITE>`
- **Description:** Opens the specified site configuration file in the default editor. If changes are made, prompts for an Nginx reload.

### Site Path
- **Command:** `ngx where <SITE>`
- **Description:** Displays the full path to the specified site configuration file.

### Site Root
- **Command:** `ngx root <SITE>`
- **Description:** Displays the root path of the specified site.

### View Logs
- **Command:** `ngx log <SITE> [error|access]`
- **Description:** Displays the specified log (error or access) of the site.

### Log Path
- **Command:** `ngx logpath <SITE> [error|access]`
- **Description:** Displays the path to the specified log (error or access) of the site.

### List Templates
- **Command:** `ngx templates`
- **Description:** Lists all available local and online templates.

### Generate Site Configuration
- **Command:** `ngx generate <SITE> [template] [--online]`
- **Alias:** `ngx new <SITE> [template] [--online]`
- **Description:** Generates a new site configuration using the specified template. If no template is provided, the base template is used. Optionally, use the `--online` flag to force a refetch from the online source. Otherwise if the template is already downloaded, it will be used.

### Remove Site
- **Command:** `ngx remove <SITE>`
- **Description:** Removes the specified site configuration and its associated log files.

### Request SSL Certificate
- **Command:** `ngx cert <SITE>`
- **Description:** Requests an SSL certificate for the specified site using Let's Encrypt.

### Generate Site Configuration and Request SSL Certificate
- **Command:** `ngx new+cert <SITE>`
- **Description:** Generates a new site configuration and requests an SSL certificate for the site.

### Start Nginx
- **Command:** `ngx start`
- **Description:** Starts the Nginx service.

### Restart Nginx
- **Command:** `ngx restart`
- **Description:** Restarts the Nginx service.

### Reload Nginx
- **Command:** `ngx reload`
- **Description:** Reloads the Nginx service.

### Stop Nginx
- **Command:** `ngx stop`
- **Description:** Stops the Nginx service.

### Get IP Address
- **Command:** `ngx ip`
- **Description:** Displays the server's IP address.

### Update NGX Tool
- **Command:** `ngx update-self`
- **Description:** Updates the NGX tool using wget.

### Show Help
- **Command:** `ngx help`
- **Description:** Displays the help information for the NGX tool.

### Show Version
- **Command:** `ngx version`
- **Description:** Displays the current version of the NGX tool.

### Edit Configuration
- **Command:** `ngx config`
- **Description:** Opens the NGX configuration file in the default editor.

### Generate Completions
- **Command:** `ngx completions`
- **Description:** Generates bash completions for the NGX tool.

## Configuration File
The tool uses a configuration file located at `$HOME/.ngx.conf`. If the file does not exist, it will be created automatically.  
It contains the following settings:

```bash
# NGX tool configuration file

# Preferred editor for editing site configurations
NGX_EDITOR=vim

# Cloudflare API token for DNS updates - Currently not fully implemented
NGX_CLOUDFLARE_API_TOKEN=your_cloudflare_api_token # Currently not used

# Server IP address
HOST_IP=your_server_ip # Fetched automatically if not set

# Directory where Nginx is installed
NGINX_DIR=/etc/nginx

# Directory for available Nginx site configurations
NGINX_SITES_AVAILABLE=$NGINX_DIR/sites-available

# Directory for enabled Nginx site configurations
NGINX_SITES_ENABLED=$NGINX_DIR/sites-enabled

# Directory for virtual hosts
VHOSTS=/var/www/vhosts

# Directory for logs
LOGS="/var/www/log"

# Directory for Nginx templates
TEMPLATE_PATH=$HOME/.ngx/templates
```

You can customize these settings according to your environment and preferences.
