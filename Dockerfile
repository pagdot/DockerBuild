FROM ubuntu:latest

RUN apt update && apt install -y shntool cuetools flac mp3splt && rm -rf /var/lib/apt/lists/*

COPY cuesplit.sh /usr/bin/cuesplit

VOLUME [ "/input", "/output" ]

CMD [ "cuesplit" , "/input", "/output" ]