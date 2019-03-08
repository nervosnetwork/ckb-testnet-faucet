## faucet-service

## API

Request:

`GET /verify` JSONP (Using JSON requests can cause cross-domain problems in the local test environment)

Response:

| Name   |      Type      |  Description |
|----------|:-------------:|:------|
| `status` |  `int` | 0: token is available; -1: unauthenticated; -2: received  |

```
callback({
    "status" : -1
})
```
