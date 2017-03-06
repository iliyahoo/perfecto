FROM ubuntu:16.04
MAINTAINER Iliya Strakovich "iliya@strakovich.com"
RUN apt-get -yqq update
RUN apt-get install -y curl
RUN apt-get -yqq install nginx
VOLUME ["/etc/nginx"]
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
