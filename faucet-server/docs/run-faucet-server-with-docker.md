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
$ sudo docker run -P 80:80 -d faucet \
  --wallet_private_key <private_key> \
  --node_url <node_url> \
  --github_oauth_client_id <client_id> \
  --github_oauth_client_secret <client_secret> \
  --send_capacity_count <send_capacity_count>
```

### Stop

```
$ sudo docker stop $CONTAINER_ID
```
