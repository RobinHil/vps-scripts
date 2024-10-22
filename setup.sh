#!/bin/bash

# Création du répertoire pour les configurations nginx
mkdir -p /var/local/proxy/conf.d

# Configuration principale de nginx
cat > /var/local/proxy/nginx.conf << 'EOF'
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    keepalive_timeout  65;

    include /etc/nginx/conf.d/*.conf;
}
EOF

# Configuration pour portainer
cat > /var/local/proxy/conf.d/robinh.conf << 'EOF'
server {
    listen 80;
    server_name portainer.robinh.fr;

    location / {
        proxy_pass https://portainer:9443;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Création du réseau Docker
docker network create proxy_network

# Lancement de Portainer
docker volume create portainer_data
docker run -d \
    -p 9443:9443 \
    --name portainer \
    --network proxy_network \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    --restart always \
    portainer/portainer-ce:latest

# Lancement de Nginx
docker run -d \
    --name nginx_proxy \
    --network proxy_network \
    -p 80:80 \
    -v /var/local/proxy/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v /var/local/proxy/conf.d:/etc/nginx/conf.d:ro \
    --restart always \
    nginx:latest
