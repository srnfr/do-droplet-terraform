#!/usr/bin/bash

apt update
apt install -y build-essential cmake

##Install Go
cd /home
wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz 
tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz
ln -s /usr/local/go/bin/go /usr/bin/

## Install libbpf
git clone --depth 1 https://github.com/libbpf/libbpf
cd libbpf/src/
make install

LD_LIBRARY_PATH=/usr/lib64/
export LD_LIBRARY_PATH

## Install xpid
git clone https://github.com/kris-nova/xpid.git
cd xpid
make all
