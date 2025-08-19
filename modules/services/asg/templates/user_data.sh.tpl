#!/bin/bash

apt-get update
apt-get install -y python3


cat > index.html <<EOF
<h1>Hello, World</h1>
<p>Environment: ${environment}</p>
<p>Project: ${project_name}</p>
<p>DB address: ${db_address}</p>
<p>DB port: ${db_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} &

