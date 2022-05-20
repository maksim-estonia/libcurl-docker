# Libcurl docker

Set up 2 docker containers:

- server
- client

Goal: `server` has a file `lorem.txt` which we want to fetch from the client using [libcurl](https://everything.curl.dev/libcurl).

## step 1: setup docker containers

cleanup previous setups: `docker system prune`

### 1.1 setup network

[docker-openssh-server](https://github.com/linuxserver/docker-openssh-server)

`docker-compose.yml`

```yml
version: "3.7"

services:
    server:
        image: ubuntu:20.04
        stdin_open: true
        tty: true
        volumes:
            - ./ext-files:/ext-files/
    client:
        image: ubuntu:20.04
        stdin_open: true
        tty: true
```

`cd libcurl-docker/step_1`

Start containers/network: `docker-compose up`

Open terminal for server: `docker exec -ti step_1_server_1 /bin/bash`

Open terminal for client: `docker exec -ti step_1_client_1 /bin/bash`

### 1.2 server setup

```
apt-get update 
apt-get install ssh -y (8/50)
service ssh restart
service ssh status
cd ext-files
chmod +x sftp_setup.sh
./sftp_setup.sh
```

### 1.3 client setup

[Documentation]((https://everything.curl.dev/get/linux))

In `client` container:

```
apt-get update
apt-get -y install curl
```

## step 2: execute file transfer using command-line

### client

```
curl sftp://172.18.0.2/ -u sftp_usr
```

### client: 

[`curl sftp://example.com/file.zip -u user`](https://everything.curl.dev/usingcurl/scpsftp)

```
curl sftp://server/ext-files/lorem.txt -u sftp_usr
```

## step 3: execute file transfer using libcurl (c library)

[`curl/docs/examples/sftpget.c`](https://github.com/curl/curl/blob/master/docs/examples/sftpget.c)