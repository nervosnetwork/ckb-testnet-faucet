# CKB Testnet Faucet Server

## Dependencies

- Swift 5
- libsodium
- Vapor

## Build

```shell
brew install libsodium
brew tap vapor/tap
brew install vapor/tap/vapor

git clone https://github.com/nervosnetwork/ckb-testnet-faucet.git
cd ./ckb-testnet-faucet/faucet-server
swift build
```

## Run

```
./.build/debug/Run --env dev \
  --wallet_private_key <private_key> \
  --node_url <node_url> \
  --github_oauth_client_id <client_id> \
  --github_oauth_client_secret <client_secret> \
  --send_capacity_count <send_capacity_count>
```

## Documentations

 - [faucet-server-api](docs/faucet-server-api.md)
 - [run-faucet-server-with-docker](docs/run-faucet-server-with-docker.md)
