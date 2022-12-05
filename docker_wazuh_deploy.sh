#!/bin/bash

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

compose_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

curl -L "https://github.com/docker/compose/releases/download/$compose_version/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


mkdir -p /opt/docker

cd /opt/docker&&git clone https://github.com/wazuh/wazuh-docker.git -b v4.3.10 --depth=1

cd /opt/docker/wazuh-docker/single-node&&docker-compose -f generate-indexer-certs.yml run --rm generator


sed -i "s/- wazuh_/- .\/data\/wazuh_/g" /opt/docker/wazuh-docker/single-node/docker-compose.yml

sed -i "s/- filebeat/- .\/data\/filebeat/g" /opt/docker/wazuh-docker/single-node/docker-compose.yml
sed -i "s/- wazuh-/- .\/data\/wazuh-/g" /opt/docker/wazuh-docker/single-node/docker-compose.yml
cd /opt/docker/wazuh-docker/single-node&&awk 'NR<89' docker-compose.yml > temp&& mv temp docker-compose.yml

cd /opt/docker/wazuh-docker/single-node/&&docker-compose up -d
cd /opt/docker/wazuh-docker/single-node/&&docker-compose down
chmod -R 777 /opt/docker/wazuh-docker/single-node/config
chmod -R 777 /opt/docker/wazuh-docker/single-node/data
cd /opt/docker/wazuh-docker/single-node/&&docker-compose up -d
