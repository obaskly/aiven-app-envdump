FROM alpine:3.20
RUN apk add --no-cache curl python3 iproute2
EXPOSE 8080
COPY srv.py /srv.py
CMD ["python3","-u","/srv.py"]
