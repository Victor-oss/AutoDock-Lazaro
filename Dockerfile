FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Baixar AutoDock 4.2
RUN wget --no-check-certificate https://autodock.scripps.edu/wp-content/uploads/sites/56/2021/10/autodocksuite-4.2.6-x86_64Linux2.tar \
    && tar -xvf autodocksuite-4.2.6-x86_64Linux2.tar \
    && mv x86_64Linux2/autodock4 /usr/local/bin \
    && mv x86_64Linux2/autogrid4 /usr/local/bin \
    && chmod +x /usr/local/bin/autodock4 /usr/local/bin/autogrid4 \
    && rm -rf x86_64Linux2 autodocksuite-4.2.6-x86_64Linux2.tar

WORKDIR /data
