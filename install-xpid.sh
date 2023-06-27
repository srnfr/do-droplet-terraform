#!/usr/bin/bash

apt update
apt install -y build-essential cmake libelf-dev libbpf-dev

##Install Go
cd /home
wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz 
tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz
ln -s /usr/local/go/bin/go /usr/bin/

LD_LIBRARY_PATH=/usr/lib64/
export LD_LIBRARY_PATH

## Install xpid
git clone https://github.com/kris-nova/xpid.git
cd xpid
make all
