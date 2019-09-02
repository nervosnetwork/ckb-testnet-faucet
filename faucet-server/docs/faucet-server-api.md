# CKB Testnet Faucet Server API

### Auth and Verify by GitHub

`GET /auth/verify`

#### Response

```json
{
    "status":0,
    "message":"Request successful"
}
```

### Claim Testnet Tokens

`GET /ckb/faucet`

#### Parameters

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| address |  string | Wallet address.  |

#### Response

```json
{
    "status":0,
    "message":"Request successful",
    "data":{
        "txHash":"0xeb33b0982e109eacbadb99caab918e42d5760a33eb3f54bfe27966ab6f50c2e4"
    }
}
```

### Response Status

| Code   |  Message |
|----------|:------|
| 0 | Request successful  |
| -1 | Unauthenticated  |
| -2 | Received  |
| -3 | Invalid address  |
| -6 | Send transaction failed  |
