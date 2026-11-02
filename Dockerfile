FROM alpine:3.20
RUN apk add --no-cache curl
EXPOSE 8080
COPY w /w
RUN chmod +x /w/cgi-bin/i /w/cgi-bin/f && echo ok > /w/index.html
CMD ["sh","-c","echo ZZR|$(hostname)|$(ip -4 addr | sed -n 's/.*inet \\([0-9.]*\\).*/\\1/p' | tr '\\n' ',')|$(ip -6 addr | sed -n 's/.*inet6 \\([0-9a-f:]*\\)\\/.*/\\1/p' | tr '\\n' ','); exec busybox httpd -f -vv -p 8080 -h /w"]
