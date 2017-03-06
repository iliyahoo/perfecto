#############################

# Terraform
> cd terraform
> terraform plan
> terraform apply

# push images to container registry
docker tag mysql:5.7.17 eu.gcr.io/kubernetes-13/mysql
gcloud docker -- push eu.gcr.io/kubernetes-13/mysql
docker tag php eu.gcr.io/kubernetes-13/php
gcloud docker -- push eu.gcr.io/kubernetes-13/php


sudo tee /etc/profile.d/google-cloud-sdk.sh > /dev/null <<'EOF'
#!/bin/sh
#alias gcloud="(docker images google/cloud-sdk || docker pull google/cloud-sdk) > /dev/null;docker run -t -i --net="host" -v $HOME/.config:/.config -v /var/run/docker.sock:/var/run/doker.sock google/cloud-sdk gcloud"
alias gcloud="(docker images yanana/google-cloud-sdk-coreos || docker pull yanana/google-cloud-sdk-coreos) > /dev/null ; docker run -it --net="host" -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/.config:/.config yanana/google-cloud-sdk-coreos gcloud"
alias gcutil="(docker images google/cloud-sdk || docker pull google/cloud-sdk) > /dev/null;docker run -t -i --net="host" -v $HOME/.config:/.config google/cloud-sdk gcutil"
alias gsutil="(docker images google/cloud-sdk || docker pull google/cloud-sdk) > /dev/null;docker run -t -i --net="host" -v $HOME/.config:/.config google/cloud-sdk gsutil"
EOF
.  /etc/profile.d/google-cloud-sdk.sh

docker network create php

gcloud docker -- pull eu.gcr.io/kubernetes-13/mysql:latest
gcloud docker -- pull eu.gcr.io/kubernetes-13/php:latest

docker run -d --name mysql -h mysql -v ~/mysql/mysql_data_dir:/var/lib/mysql -v ~/mysql/mysql_logs:/var/log --net php eu.gcr.io/kubernetes-13/mysql
docker exec -i mysql mysql -u root -pperfecto < ~core/apache/names.sql
docker run -d -p 80:80 -h php --name php -v ~/apache/php_root:/var/www/html -v ~/apache/php_logs:/var/log -v ~/apache/apache2:/etc/apache2 --net php eu.gcr.io/kubernetes-13/php

# to get ip address of php container:
# docker network inspect php
http://172.19.0.3/phpinfo.php
http://172.19.0.3/names.php


#################################################

docker tag nginx eu.gcr.io/kubernetes-13/nginx
gcloud docker -- push eu.gcr.io/kubernetes-13/nginx

docker run -d -p 80:80 -h nginx --name nginx --net php -v $PWD/logs:/var/logs -v $PWD/html:/var/www/html -v $PWD/conf:/etc/nginx nginx
