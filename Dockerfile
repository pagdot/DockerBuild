FROM golang AS builder

RUN git clone https://github.com/rclone/rclone.git
WORKDIR /go/rclone

RUN make quicktest
RUN \
   CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
   make
RUN ./rclone version

# Begin final image
FROM lsiobase/alpine:3.11

RUN apk --no-cache add ca-certificates fuse

COPY --from=builder /go/rclone/rclone /usr/local/bin/
COPY root/ /

ENTRYPOINT [ "rclone" ]

VOLUME /config

WORKDIR /data
ENV XDG_CONFIG_HOME=/config