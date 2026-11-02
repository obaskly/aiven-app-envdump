FROM busybox:1.36
EXPOSE 8080
CMD ["sh","-c","echo ENVDUMP_BEGIN; env; echo ENVDUMP_END; mkdir -p /w && echo ok > /w/index.html && httpd -f -p 8080 -h /w"]
