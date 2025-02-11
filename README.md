# 🚀 VPS Initialization Script

This script sets up a reverse proxy environment using Nginx and Portainer on a Rocky Linux VPS. It configures a containerized environment for managing Docker applications with a web interface.

## 📋 Prerequisites

- Rocky Linux (tested on Rocky Linux 8.x and 9.x)
- Docker installed and running
- Root access to the server
- Domain name pointing to your VPS (for Portainer access)

## 🛠️ What the Script Does

1. 📁 Creates necessary directories for Nginx configuration
2. 🔧 Sets up Nginx configuration with:
   - Main configuration file
   - Proxy settings for Portainer
3. 🌐 Creates a Docker network for communication between containers
4. 🐳 Deploys two Docker containers:
   - Portainer CE (Container Management UI)
   - Nginx (Reverse Proxy)

## 🚦 Installation

1. Save the script to your VPS (e.g., as `setup.sh`)
2. Make it executable:
   ```bash
   chmod +x ./setup.sh
   ```
3. Run it as root:
   ```bash
   sudo ./setup.sh
   ```

## ⚙️ Configuration Details

### Nginx
- Runs on port 80
- Configured with standard HTTP settings
- Includes proxy configuration for Portainer

### Portainer
- Runs on port 9443 (HTTPS)
- Accessible via `portainer.robinhi.fr`
- Uses persistent volume for data storage
- Auto-restarts on system reboot

## 🔒 Security Notes

- The script configures basic proxy headers for security
- Portainer runs with HTTPS enabled by default
- Make sure to:
  - Set up SSL/TLS certificates for production use
  - Configure proper firewall rules
  - Change default Portainer admin password upon first login

## 🌐 Accessing Services

After running the script:
1. Access Portainer at: `https://portainer.robinhi.fr`
2. Complete the initial setup by creating an admin account

## ⚠️ Important Notes

- Backup any existing Nginx configurations before running the script
- Ensure your domain DNS settings are properly configured
- The script assumes default Docker installation paths
- Modify the domain name in the Nginx configuration to match your domain

## 🔧 Maintenance

The containers are configured to:
- Start automatically on system boot
- Restart on failure
- Store logs in standard Docker log locations

## 📝 License

This script is provided as-is, feel free to modify and use it according to your needs.

## 🆘 Troubleshooting

If you encounter issues:
1. Check Docker logs:
   ```bash
   docker logs nginx_proxy
   docker logs portainer
   ```
2. Verify network configuration:
   ```bash
   docker network inspect proxy_network
   ```
3. Ensure all ports are accessible and not blocked by firewall
