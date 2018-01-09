#!/bin/bash

export HAPROXY_USER=
export NGINX_USER=
export NODEJS_USER=

export HAPROXY_PORT=80
export NGINX_PORT=8000
export NODEJS_PORT=5500

if [ ! -z $HAPROXY_USER ] && [ ! -z $NGINX_USER ] && [ ! -z $NODEJS_USER ] && [ ! -z $HAPROXY_PORT ] && [ ! -z $NGINX_PORT ] && [ ! -z $NODEJS_PORT ]
then
  ansible-playbook -i inventories/servers site.yml
else
  echo "Please assign values to the above variables"
  exit 1
fi
