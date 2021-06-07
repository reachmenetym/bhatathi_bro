#!/bin/bash
apt upgrade
apt install nginx -y 
rm -rf /etc/nginx/sites-enabled/*
cat <<EOF > /etc/nginx/sites-enabled/proxy.conf
upstream app_backend {
  %{ for ip in module.app_instance.app_private_ips ~}
    server ${ip}:8484;
  %{ endfor ~}
}

server {
    listen 80;
    server_name _;
    location / {
      proxy_pass http://app_backend;
    }
  }
EOF

systemctl enable nginx.service
systemctl restart nginx.service