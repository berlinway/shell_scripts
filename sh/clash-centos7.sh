#!/bin/bash
systemctl stop clash
cd /application/clash
wget -O /application/clash/config.yaml   https://sub.djxyy.xyz/link/kRmZcbH2pXFVOTDv?clash=1
sed -i 's/127.0.0.1:9090/0.0.0.0:9999/g' config.yaml
sed -i 's/allow-lan: false/allow-lan: true/g' config.yaml
sed -i 's/socks-port: 7891/socks-port: 5432/g' config.yaml
sed -i 's/port: 7890/port: 5433/g' config.yaml
systemctl start clash