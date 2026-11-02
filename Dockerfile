FROM alpine:3.20
RUN apk add --no-cache curl socat
EXPOSE 8080
COPY probe.sh /probe.sh
CMD ["sh","-c","sh /probe.sh 2>&1; mkdir -p /w && echo ok > /w/index.html && exec busybox httpd -f -p 8080 -h /w"]
