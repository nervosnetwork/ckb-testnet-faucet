## Run faucet-server with Docker

### Prerequisite
- docker


`git clone https://github.com/nervosnetwork/ckb-testnet-faucet.git && cd ./ckb-testnet-faucet`

### Build images
```
$ cd ./faucet-server/
$ sudo docker build -t faucet .
```

### Run 

```
$ sudo docker run -P 80:80 -d faucet --github_oauth_client_id xxx --github_oauth_client_secret xxxxx
```

### Stop

```
$ sudo docker stop $CONTAINER_ID
```
