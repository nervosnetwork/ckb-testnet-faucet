## faucet-service

## API

Request:

`GET /auth/verify` 

Support jsonp (Using JSON requests can cause cross-domain problems in the local test environment)

Response:

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| `status` |  `int` | 0: token is available; -1: unauthenticated; -2: received  |

```
{
    "status" : -1
}
```

Request:

`POST /ckb/faucet`

Parameters:

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| `address` | `string` | wallet address  |

Response:

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
