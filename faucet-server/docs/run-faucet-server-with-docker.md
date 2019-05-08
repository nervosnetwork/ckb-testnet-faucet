## Run faucet-server with Docker

### Prerequisite
- docker
- docker-compose

`git clone https://github.com/nervosnetwork/ckb-testnet-faucet.git && cd ./ckb-testnet-faucet`

### Build images
```
$ cd ./faucet-server/
$ sudo docker-compose build
```

### Run 

```
$ sudo docker-compose up -d
$ sudo docker exec -it faucet-server_vapor_1 bash
$ swift build -c release
$ ./.build/release/Run --hostname 0.0.0.0 --port 8080 
```

### Stop

```
Control + C
$ exit
$ sudo docker-compose stop
```
