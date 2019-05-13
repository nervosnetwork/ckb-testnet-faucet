# CKB Testnet Faucet Server

## Dependencies

- Swift 5.0.1
- libsodium `brew install libsodium`

## Build

- `git clone https://github.com/nervosnetwork/ckb-testnet-faucet.git`
- `cd ./ckb-testnet-faucet/faucet-server`
- `swift build`

## Run

```
./.build/debug/Run --env dev \
  --node_url <node_url>
  --github_oauth_client_id <client_id> \
  --github_oauth_client_secret <client_secret> \
  --send_capacity_count <send_capacity_count>
```

## Documentations

 - [faucet-server-api]()
 - [run-faucet-server-with-docker]()
