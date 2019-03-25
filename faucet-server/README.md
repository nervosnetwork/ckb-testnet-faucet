## faucet-service

## Build dependencies

- Swift 4.2
- libsodium `brew install libsodium`

## Build

- `git clone https://github.com/nervosnetwork/ckb-testnet-faucet.git`
- `cd ./ckb-testnet-faucet/faucet-server`
- `swift build`

## Run

`./.build/debug/Run --env dev --github_oauth_client_id <client_id> --github_oauth_client_secret <client_secret>`

## API

#### Request:

`GET /auth/verify` 

Support jsonp (Using JSON requests can cause cross-domain problems in the local test environment)

#### Response:

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| `status` |  `int` | 0: token is available; -1: unauthenticated; -2: received  |

```
{
    "status" : -1
}
```


#### Request:

`POST /ckb/faucet`

#### Parameters:

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| `address` | `string` | wallet address  |

#### Response:

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| `status` | `int` | 0: token is available; -1: unauthenticated; -2: received  |
| `txhash` | `string` | tx hash |

```
{
    "status" : 0,
    "txhash" : "xxxxxx"
}
```

#### Request:

`GET /ckb/address`

#### Parameters:

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| `privateKey` | `string` | Only one of the private key or public key is required. |
| `publicKey` | `string` | Only one of the private key or public key is required. |

#### Response:

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| `status` | `int` | 0: Ok; -1: No public or private key; -2: Invalid public or private key  |
| `address` | `string` | Wallet address |
| `error` | `string` | Error message |

```
{
    "status" : 0,
    "address" : "0xbc374983430db3686ab181138bb510cb8f83aa136d833ac18fc3e73a3ad54b8b"
}
```
