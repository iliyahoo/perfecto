docker network create php

cd mysql
docker build -t mysql:5.7.17 .
docker run -d --name mysql -h mysql -v $PWD/mysql_data_dir:/var/lib/mysql -v $PWD/mysql_logs:/var/log --net php mysql:5.7.17
docker exec -i mysql mysql -u root -pperfecto < $PWD/names.sql

cd ../apache
docker build -t php .
docker run -d -h php --name php -v $PWD/php_root:/var/www/html -v $PWD/php_logs:/var/log -v $PWD/apache2:/etc/apache2 --net php php

# to get ip address of php container:
# docker network inspect php
http://172.19.0.3/phpinfo.php
http://172.19.0.3/names.php

# Terraform
> cd terraform

edit terraform.tfvars file
# retreive discovery_url
# specifying a proper size of etcd cluster
> curl https://discovery.etcd.io/new?size=1

> terraform plan
> terraform apply

kubectl config set-cluster kubestack --insecure-skip-tls-verify=true --server=https://104.199.18.99:6443

## Register the worker nodes
# Nodes will be named based on the following convention:
# ${cluster_name}-kube${count}.c.${project}.internal
cd ../kubernetes
cat <<EOF> testing-kube0.c.kubernetes-13.internal.json
{
  "kind": "Node",
  "apiVersion": "v1",
  "metadata": {
    "name": "testing-kube0.c.kubernetes-13.internal"
  },
  "spec": {
    "externalID": "testing-kube0.c.kubernetes-13.internal"
  }
}
EOF
kubectl create -f testing-kube0.c.kubernetes-13.internal.json
kubectl get node testing-kube0.c.kubernetes-13.internal

# push images to container registry
docker tag mysql:5.7.17 eu.gcr.io/kubernetes-13/mysql
gcloud docker -- push eu.gcr.io/kubernetes-13/mysql
docker tag php eu.gcr.io/kubernetes-13/php
gcloud docker -- push eu.gcr.io/kubernetes-13/php



#############################
cat <<EOF> php-deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: php
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: php
    spec:
      containers:
      - name: php
        image: eu.gcr.io/kubernetes-13/php:latest
        ports:
        - containerPort: 80
EOF
kubectl create -f php-deployment.yaml


cat <<EOF> mysql-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "mysql"
  labels:
    app: php
spec:
  containers:
    - name: mysql
      image: eu.gcr.io/kubernetes-13/mysql:latest
      ports:
        - name: mysql
          containerPort: 3306
EOF
kubectl create -f mysql-pod.yaml

cat <<EOF> php-service.yaml
kind: Service
apiVersion: v1
metadata:
  name: "php"
spec:
  selector:
    app: "php"
  ports:
    - protocol: "TCP"
      port: 80
      targetPort: 80
EOF
kubectl create -f php-service.yaml
