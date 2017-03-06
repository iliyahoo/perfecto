#!/usr/bin/bash

sudo tee /etc/profile.d/google-cloud-sdk.sh > /dev/null <<'EOF'
#!/bin/sh
#alias gcloud="(docker images google/cloud-sdk || docker pull google/cloud-sdk) > /dev/null;docker run -it --net="host" -v $HOME/.config:/.config -v /var/run/docker.sock:/var/run/doker.sock google/cloud-sdk gcloud"
alias gcloud="(docker images yanana/google-cloud-sdk-coreos || docker pull yanana/google-cloud-sdk-coreos) > /dev/null ; docker run -it --net="host" -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/.config:/.config yanana/google-cloud-sdk-coreos gcloud"
alias gcutil="(docker images google/cloud-sdk || docker pull google/cloud-sdk) > /dev/null;docker run -it --net="host" -v $HOME/.config:/.config google/cloud-sdk gcutil"
alias gsutil="(docker images google/cloud-sdk || docker pull google/cloud-sdk) > /dev/null;docker run -it --net="host" -v $HOME/.config:/.config google/cloud-sdk gsutil"
EOF
source  /etc/profile.d/google-cloud-sdk.sh

docker network create php

docker run -it --net="host" -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/.config:/.config yanana/google-cloud-sdk-coreos gcloud docker -- pull eu.gcr.io/kubernetes-13/mysql:latest
docker run -d --name mysql -h mysql -v ~/mysql/mysql_data_dir:/var/lib/mysql -v ~/mysql/mysql_logs:/var/log --net php eu.gcr.io/kubernetes-13/mysql

docker run -it --net="host" -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/.config:/.config yanana/google-cloud-sdk-coreos gcloud docker -- pull eu.gcr.io/kubernetes-13/php:latest
docker run -d -h php --name php -v ~/apache/php_root:/var/www/html -v ~/apache/php_logs:/var/log -v ~/apache/apache2:/etc/apache2 --net php eu.gcr.io/kubernetes-13/php

docker run -it --net="host" -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/.config:/.config yanana/google-cloud-sdk-coreos gcloud docker -- pull eu.gcr.io/kubernetes-13/nginx:latest
docker run -d -p 80:80 -h nginx --name nginx --net php -v ~/nginx/logs:/var/logs -v ~/nginx/html:/var/www/html -v ~/nginx/conf:/etc/nginx nginx

docker exec -i mysql mysql -u root -pperfecto < ~core/apache/names.sql
