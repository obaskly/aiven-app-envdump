FROM alpine:3.19
RUN apk add --no-cache curl busybox
EXPOSE 8080
COPY run.sh /run.sh
CMD ["sh","/run.sh"]
