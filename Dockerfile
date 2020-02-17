FROM linuxserver/letsencrypt:latest as tmp

FROM scratch as prepare

COPY 25-config-reverse /etc/cont-init.d/
COPY --from=tmp /defaults/default /defaults/default
COPY --from=tmp /defaults/ldap.conf /defaults/ldap.conf
COPY --from=tmp /defaults/nginx.conf /defaults/nginx.conf
COPY --from=tmp /defaults/proxy.conf /defaults/proxy.conf
COPY --from=tmp /defaults/ssl.conf /defaults/ssl.conf
COPY --from=tmp /defaults/proxy-confs /defaults/proxy-confs

FROM scratch

COPY --from=prepare / /