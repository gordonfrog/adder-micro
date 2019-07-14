#!/bin/bash
#source ~/.bashrc
source /Users/Shared/Jenkins/.bashrc

GITSHA=$(git rev-parse --short HEAD)

case "$1" in
  container)
    sudo -u jenkins docker build -t adderservice:$GITSHA .
    sudo -u jenkins docker tag adderservice:$GITSHA gordonfrog/adderservice:$GITSHA 
    sudo -i -u jenkins docker push gordonfrog/adderservice:$GITSHA 
  ;;
  deploy)
    sed -e s/_NAME_/adderservice/ -e s/_PORT_/8080/  < ../deployment/service-template.yml > svc.yml
    sed -e s/_NAME_/adderservice/ -e s/_PORT_/8080/ -e s/_IMAGE_/gordonfrog\\/adderservice:$GITSHA/ < ../deployment/deployment-template.yml > dep.yml
    sudo -i -u jenkins kubectl apply -f $(pwd)/svc.yml
    sudo -i -u jenkins kubectl apply -f $(pwd)/dep.yml
  ;;
  *)
    echo 'invalid build command'
    exit 1
  ;;
esac

