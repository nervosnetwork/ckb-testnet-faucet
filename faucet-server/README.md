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
  --wallet_private_key <private_key> \
  --node_url <node_url> \
  --github_oauth_client_id <client_id> \
  --github_oauth_client_secret <client_secret> \
  --send_capacity_count <send_capacity_count>
```

## Run tests

```shell
swift test
```

Some API tests depends on a local CKB node to run. If a node is not found those tests would fail. To skip them:

```shell
SKIP_CKB_API_TESTS=1 swift test
```

## Documentations

 - [faucet-server-api](docs/faucet-server-api.md)
 - [run-faucet-server-with-docker](docs/run-faucet-server-with-docker.md)
