#!/bin/bash
apt update
apt install -y golang-go
# count=0
# while [ "${count}" -le 5 ];do
#     sleep 10
#     if [ -f /tmp/webapp ];then
#         cp /tmp/webapp /opt/webapp
#         chmod +x /opt/webapp
#         break
#         fi
# done
sleep 10
cp /tmp/webapp.go /opt/
cd /opt
go build webapp.go 

cat <<EOF > /etc/systemd/system/webapp.service
[Unit]
Description=Web Application
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/opt/webapp

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable webapp.service
systemctl start webapp.service