FROM busybox:1.36
EXPOSE 8080
COPY probe.sh /probe.sh
CMD ["sh","-c","sh /probe.sh 2>&1; mkdir -p /w && echo ok > /w/index.html && httpd -f -p 8080 -h /w"]
