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
| `address` | `string` | wallet address P2PH  |

#### Response:

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| `status` | `int` | 0: success; -1 -2: verify failed; -3: failed  |
| `txhash` | `string` | tx hash |
| `error` | `string` | error message |


```
{
    "status" : 0,
    "txhash" : "0x9a46fc47a4fbb6b155d46e26311a011d40f13a377e3f97084b45c856ffd29e9d"
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


#### Request:

`GET /ckb/address/random`

#### Response:

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| `privateKey` | `string` |  |
| `publicKey` | `string` |  |
| `address` | `string` |  |

```
{
    "privateKey" : "a9d8a7c054fc859ca353f5448f339df850aa4242a83c6ad6d13d6e6a790e0142",
    "publicKey" : "02f7d93237037b1743784e43ccc5442918a35d24b8c0975f1cdd6c94b6990e0bf9"
    "address" : "0x4ad91b77b10569ab1bbdd56674443607dc8379bc734f08f422a50066377a3eb5"
}
```
