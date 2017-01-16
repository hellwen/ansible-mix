#! /bin/sh

KUBE_MASTER=192.168.72.128

KUBE_HOME=/usr/local/kubernetes
CERT_PATH=/srv/kubernetes

rm -rf ${CERT_PATH}/*

openssl genrsa -out ${CERT_PATH}/ca.key 2048
openssl req -x509 -new -nodes -key ${CERT_PATH}/ca.key -subj "/CN=${KUBE_MASTER}" -days 10000 -out ${CERT_PATH}/ca.crt

openssl genrsa -out ${CERT_PATH}/server.key 2048
openssl req -new -key ${CERT_PATH}/server.key -subj "/CN=${KUBE_MASTER}" -out ${CERT_PATH}/server.csr
openssl x509 -req -in ${CERT_PATH}/server.csr -CA ${CERT_PATH}/ca.crt -CAkey ${CERT_PATH}/ca.key -CAcreateserial -out ${CERT_PATH}/server.cert -days 10000

> ${CERT_PATH}/abac.csv
# user 
# readonly
# kind: pods, events
# namespace
echo '{"user":"dean"}' >> ${CERT_PATH}/abac.csv
echo '{"user":"kubelet"}' >> ${CERT_PATH}/abac.csv

> ${CERT_PATH}/basic_auth.csv
echo "dean.wu,dean,dean" >> ${CERT_PATH}/basic_auth.csv
echo "kubelet.wu,kubelet,kubelet" >> ${CERT_PATH}/basic_auth.csv
