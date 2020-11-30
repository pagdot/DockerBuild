FROM lsiobase/alpine:3.11 as downloader

ARG VERSION=v1.53.3

RUN apk --no-cache add ca-certificates curl unzip

#Fetch and unpack
RUN curl -O https://downloads.rclone.org/${VERSION}/rclone-${VERSION}-linux-amd64.zip && \
   unzip rclone-${VERSION}-linux-amd64.zip

FROM lsiobase/alpine:3.11

ARG VERSION=v1.53.3

LABEL build_version="Pagdot version: ${VERSION}"
LABEL maintainer="pagdot"

RUN apk --no-cache add ca-certificates fuse && \
   sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

COPY --from=downloader rclone-${VERSION}-linux-amd64/rclone /usr/bin/rclone
COPY root/ /

VOLUME /config

ENV CONFIG /config/rclone.conf

WORKDIR /data
ENV XDG_CONFIG_HOME=/config