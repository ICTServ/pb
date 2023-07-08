FROM alpine:latest

ARG PBV=0.16.7

RUN apk update && apk add curl wget unzip
RUN addgroup -S pb && adduser -S pb -G pb
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${PBV}/pocketbase_${PBV}_linux_amd64.zip -O '/tmp/pb.zip'
RUN unzip /tmp/pb.zip -d /usr/local/bin/
RUN rm /tmp/pb.zip


RUN mkdir /pb_data
RUN chown pb:pb /usr/local/bin/pb
RUN chown pb:pb /pb_data
RUN chmod 710 /usr/local/bin/pb



VOLUME /pb_data
USER pb
EXPOSE 8090

ENTRYPOINT ["/usr/local/bin/pb", "serve", "--http=0.0.0.0:8090", "--dir=/pb_data"]
