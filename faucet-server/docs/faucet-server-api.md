# CKB Testnet Faucet Server API

### Verify

`GET /auth/verify`

#### Response

```json
{
    "status":0,
    "message":"Request successful"
}
```

### Faucet

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

### Generate Address

`GET /ckb/address`

#### Parameters

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| privateKey | string | Only one of the private key or public key is required. |
| publicKey | string | Only one of the private key or public key is required. |

#### Response

```json
{
    "status":0,
    "message":"Request successful",
    "data":{
        "address":"ckt1q9gry5zgua0jse2vljymevpm7gey8pjvrptmslykrdt28k",
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
| -4 | Invalid private key  |
| -5 | Invalid public key  |
| -6 | Send transaction failed  |
| -7 | Publickey or privatekey not exist  |
