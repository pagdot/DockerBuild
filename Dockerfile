FROM ubuntu:latest AS prepare

RUN apt update && \
   apt install -y git && \
   git clone https://notabug.org/Aesir/chimera.git && \
   rm -rf chimera/.git

FROM python:latest

COPY --from=prepare /chimera /chimera

RUN mkdir /config && mkdir /data && \
   ln -s /config /chimera/db && \
   pip install -r chimera/requirements.txt

WORKDIR /chimera
VOLUME [ "/config" ]

ENTRYPOINT [ "python", "/chimera/main.py" ]