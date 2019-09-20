# faucet-ui

The React front end app for CKB Testnet Faucet.

## Quick Start

You need `node >= 12` and `yarn >= 1.14` to build and run faucet-ui.

Before starting faucet-ui, you should create the `.env` file in directory `ckb-testnet-faucet/faucet-ui/`, copy parameter from `ckb-testnet-faucet/faucet-ui/example.env`.

`REACT_APP_API_HOST` is API host (faucet-server app), such as `http://localhost:8080`.

`REACT_APP_GITHUB_OAUTH_CLIENT_ID` is the [Github Ouath](https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/) Client ID.

Run `yarn install` to install all dependencies.

Then run `yarn start` to start this UI app and view in browser(`http://localhost:3000`) .
