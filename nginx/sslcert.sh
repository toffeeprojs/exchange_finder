#!/bin/sh

apk add --no-cache openssl

CERT_DIR="/etc/nginx/sslcert"
CERT_NAME="localhost"
mkdir -p "$CERT_DIR"

if [ ! -f "$CERT_DIR/$CERT_NAME.crt" ]; then
  openssl req -x509 -nodes -days 3650 \
    -newkey rsa:2048 \
    -keyout "$CERT_DIR/$CERT_NAME.key" \
    -out "$CERT_DIR/$CERT_NAME.crt" \
    -subj "/CN=localhost"
fi

exit 0
