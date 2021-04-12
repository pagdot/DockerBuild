FROM lsiobase/alpine:3.11 as downloader

ARG VERSION=1.3.0

#Fetch and unpack
RUN wget https://github.com/slackhq/nebula/releases/download/v${VERSION}/nebula-linux-amd64.tar.gz && \
   tar -xzf nebula-linux-amd64.tar.gz || true # For some reason tar command exits with exit code 1 but it works fine

FROM lsiobase/alpine:3.11

ARG VERSION=1.3.0

LABEL build_version="Pagdot version: ${VERSION}"
LABEL maintainer="pagdot"

COPY --from=downloader /nebula /bin/nebula
COPY --from=downloader /nebula-cert /bin/nebula-cert
COPY root/ /

VOLUME /config

ENV CONFIG /config/confif.yml

WORKDIR /data
