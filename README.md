# Libcurl docker

- [Libcurl docker](#libcurl-docker)
  - [EX 1: file transfer using curl (command line)](#ex-1-file-transfer-using-curl-command-line)
    - [setup network](#setup-network)
    - [server: setup](#server-setup)
    - [client: file transfer](#client-file-transfer)
    - [references](#references)
  - [EX 2: file transfer using libcurl (c library)](#ex-2-file-transfer-using-libcurl-c-library)
    - [setup network](#setup-network-1)
    - [terminal for server](#terminal-for-server)
    - [terminal for client](#terminal-for-client)
    - [server setup](#server-setup-1)
    - [client setup](#client-setup)
    - [client: file transfer using libcurl (C)](#client-file-transfer-using-libcurl-c)
    - [references](#references-1)

## EX 1: file transfer using curl (command line)

Set up 2 docker containers:

- server
- client

Goal: `server` has a file `lorem.txt` which we want to fetch from the client using [libcurl](https://everything.curl.dev/libcurl).

clean-up previous setups: `docker system prune`

pull server image: `docker pull maksimdrachov/sftp-server`

pull client image: `docker pull maksimdrachov/sftp-client-curl`

### setup network

`cd ~/libcurl-docker/EX-1`

Start containers/network: `docker-compose up`

`docker-compose.yml`:

```yml
version: "3.7"

services:
    server:
        image: maksimdrachov/sftp-server-curl
        stdin_open: true
        tty: true
        volumes:
            - ./server-volume:/ext-files/
    client:
        image: maksimdrachov/sftp-client-curl
        stdin_open: true
        tty: true
```

![docker-compose](images/EX-1/docker-compose.png)

### server: setup

Open bash terminal:

`docker exec -ti ex-1_server_1 bash`

Move `lorem.txt` to `/data/sftp_usr/upload`:

`mv /ext-files/lorem.txt /data/sftp_usr/upload/`

Restart ssh:

`service ssh restart`

![server](images/EX-1/server.png)

### client: file transfer

`docker exec -ti ex-1_client_1 bash`

from `client` terminal (password is `sftp`): 

```
curl sftp://server/upload/lorem.txt -k -u sftp_usr
```

![file-transfer](images/EX-1/file-transfer.png)

To save the file add `-o lorem.txt`:

```
curl sftp://server/upload/lorem.txt -k -u sftp_usr -o lorem.txt
```

![client](images/EX-1/client.png)

### references

[docker-openssh-server](https://github.com/linuxserver/docker-openssh-server)

## EX 2: file transfer using libcurl (c library)

### setup network

`cd ~/libcurl-docker/EX-2`

Start containers/network: `docker-compose up`

### terminal for server

`docker exec -ti ex-2_server_1 /bin/bash`

### terminal for client

`docker exec -ti ex-2_client_1 /bin/bash`

### server setup

```
apt-get update 
apt-get install ssh -y 
service ssh restart
service ssh status
cd ext-files
chmod +x sftp_setup.sh
./sftp_setup.sh
```

Move `lorem.txt` to `/data/sftp_usr/upload`:

`mv /ext-files/lorem.txt /data/sftp_usr/upload/`

### client setup

```
apt-get update
apt-get install git -y
apt-get install build-essential -y
apt-get install libcurl4-openssl-dev -y
git clone https://github.com/curl/curl.git
cd curl/docs/examples
g++ sftpget.c -l curl -o sftpget.out
```

### client: file transfer using libcurl (C)

### references

[`curl/docs/examples/sftpget.c`](https://github.com/curl/curl/blob/master/docs/examples/sftpget.c)

[C API](https://everything.curl.dev/libcurl)

[C++ API](https://everything.curl.dev/libcurl/cplusplus)

[libcurl examples](https://everything.curl.dev/libcurl/examples)