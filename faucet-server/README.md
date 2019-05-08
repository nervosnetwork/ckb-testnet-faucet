# CKB Testnet Faucet Server

## Build dependencies

- Swift 4.2
- libsodium `brew install libsodium`

## Build

- `git clone https://github.com/nervosnetwork/ckb-testnet-faucet.git`
- `cd ./ckb-testnet-faucet/faucet-server`
- `swift build`

## Run

`./.build/debug/Run --env dev --github_oauth_client_id <client_id> --github_oauth_client_secret <client_secret>`


#### [faucet-server-api]()
#### [run-faucet-server-with-docker]()
