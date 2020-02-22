FROM ubuntu:latest

COPY cuesplit.sh /usr/bin/cuesplit

RUN apt update && \
   apt install -y shntool cuetools flac mp3splt && \
   rm -rf /var/lib/apt/lists/* && \
   chmod +x /usr/bin/cuesplit

VOLUME [ "/input", "/output" ]

CMD [ "cuesplit" , "/input", "/output" ]