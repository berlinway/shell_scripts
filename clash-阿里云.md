# 阿里云安装clash自动化过程

## 1、安装clash

```bash
mkdir -p /application/clash
cd /application/clash
wget https://github.com/Dreamacro/clash/releases/download/v1.6.5/clash-linux-amd64-v1.6.5.gz
tar -xf clash-linux-amd64-v1.6.5.gz 
mv clash-linux-amd64 clash
chmod +x  clash

wget -O /application/clash/config.yaml   https://sub.djxyy.xyz/link/kRmZcbH2pXFVOTDv?clash=1
sed -i 's/127.0.0.1:9090/0.0.0.0:9999/g' config.yaml
sed -i 's/allow-lan: false/allow-lan: true/g' config.yaml
sed -i 's/socks-port: 7891/socks-port: 5432/g' config.yaml
sed -i 's/port: 7890/port: 5433/g' config.yaml

cat >>/etc/systemd/system/clash.service<<EOF
[Unit]
Description=Clash daemon, A rule-based proxy in Go.
After=network.target

[Service]
Type=simple
Restart=always
ExecStart=/application/clash/clash -f /application/clash/config.yaml 

[Install]
WantedBy=multi-user.target
EOF

systemctl  enable clash
systemctl  start clash
```

## 2、定时任务

每天凌晨6.00执行

./sh/clash.sh

```bash
#!/bin/bash
systemctl stop clash
cd /application/clash
wget -O /application/clash/config.yaml   https://sub.djxyy.xyz/link/kRmZcbH2pXFVOTDv?clash=1
sed -i 's/127.0.0.1:9090/0.0.0.0:9999/g' config.yaml
sed -i 's/allow-lan: false/allow-lan: true/g' config.yaml
sed -i 's/socks-port: 7891/socks-port: 5432/g' config.yaml
sed -i 's/port: 7890/port: 5433/g' config.yaml
systemctl start clash
```

