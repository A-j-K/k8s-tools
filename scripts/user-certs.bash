#!/bin/bash
set -e

CUSER=`stat -c '%U' .`

if [[ `whoami` != "${CUSER}" ]]; then
	echo "This script needs to be run as yourself"
	exit 1
fi

if [[ -z $1 ]]; then
	echo "Usage: $0 <groupname>"
	exit 1
else
	GRP="$1"
	echo "==> Using group ${GRP}"
fi

KEY=${KUBERNETES_PKI_CA_KEY}
CRT=${KUBERNETES_PKI_CA_CRT}

if [[ ! -r $KEY || ! -r ${CRT} ]]; then
	echo "Cannot read cluster creds"
	exit 1
fi

echo "==> Generating user's private key"
openssl genrsa -out cluster.${CUSER}.key 2048

echo "==> Creating user's signing request"
openssl req -new -key cluster.${CUSER}.key -out cluster.${CUSER}.csr -subj "/CN=${CUSER}/O=${GRP}"

echo "==> Signing the user's request"
echo "openssl x509 -req -in cluster.${CUSER}.csr -CA ${CRT} -CAkey ${KEY} -CAcreateserial -out cluster.${CUSER}.crt -days 36500"

echo "==> Setting ownerships"
chown ${CUSER}:${CUSER} cluster.${CUSER}.key cluster.${CUSER}.csr
chmod 400 cluster.${CUSER}.key cluster.${CUSER}.csr






