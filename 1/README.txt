docker network create php

cd mysql
docker build -t mysql:5.7.17 .
docker run -d --name mysql -h mysql -v $PWD/mysql_data_dir:/var/lib/mysql -v $PWD/mysql_logs:/var/log --net php mysql:5.7.17
docker exec -i mysql mysql -u root -pperfecto < $PWD/names.sql

cd ../apache
docker build -t php .
docker run -d -h php --name php -v $PWD/php_root:/var/www/html -v $PWD/php_logs:/var/log -v $PWD/apache2:/etc/apache2 --net php php

http://172.19.0.3/phpinfo.php
http://172.19.0.3/names.php
