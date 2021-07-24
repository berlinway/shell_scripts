yum install bind-utils socat  -y 

curl https://get.acme.sh | sh -s email=my@example.com
acme.sh --issue --nginx -d vs.scuimage.xyz --dns \
 --yes-I-know-dns-manual-mode-enough-go-ahead-please 
 
acme.sh --renew -d vs.scuimage.xyz \
  --yes-I-know-dns-manual-mode-enough-go-ahead-please

acme.sh --install-cert -d vs.scuimage.xyz \
--key-file       /application/certs/vs/vskey.pem  \
--fullchain-file /application/certs/vs/vscert.pem \
--reloadcmd     "nginx -s reload"

acme.sh --installcert -d vs.scuimage.xyz --fullchainpath  \
    /application/certs/vs/vs.crt --keypath /application/certs/vs/vs.key 
	
	
server {
        server_name vs.scuimage.xyz;
 
        listen 56568 default ssl;
        ssl_certificate /application/certs/vs/vs.crt;
        ssl_certificate_key /application/certs/vs/vs.key;
        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;
         
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS';
    ssl_prefer_server_ciphers   on;
        location / {
              client_max_body_size 100m;
              proxy_set_header X-Forwarded-Host $host;
              proxy_set_header X-Forwarded-Server $host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_pass http://localhost:56567;
        }
    }

docker run -dit --name code-server -u root  -p 56567:8080  -v  /application/vs/.config:/home/coder/.config   -v  /application/vs/data/:/home/coder/project   -e PASSWORD=971228@Yb maverage/code-server-jdk:latest --auth password