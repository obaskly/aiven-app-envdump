FROM busybox:1.36
EXPOSE 8080
CMD ["sh","-c","mkdir -p /w && env > /w/env.txt && echo ok > /w/index.html && httpd -f -p 8080 -h /w"]
