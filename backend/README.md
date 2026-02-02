# Token Clicker Backend

Admin wallet and $CARD mint API. Add your **minter address** and **admin mnemonic** in `.env`; the app loads the minter from `GET /api/config`.

## Setup

1. Copy `.env.example` to `.env`.
2. Set:
   - **ADMIN_MNEMONIC** – 24-word mnemonic of the wallet that is the **minter admin** (only this wallet can mint $CARD).
   - **TON_CARD_MINTER_ADDRESS** – Your deployed $CARD Jetton minter contract address.
   - **TON_NETWORK** – `testnet` or `mainnet`.
   - **ADMIN_API_KEY** (optional) – Secret for `/api/admin/*` endpoints.

```bash
cd backend
cp .env.example .env
# edit .env
npm install
npm start
```

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/config` | Public. Returns `{ cardMinterAddress, network }`. App uses this to show minter and enable withdraw. |
| POST | `/api/withdraw` | Body: `{ address, amount }`. Mints `amount` $CARD to `address` (admin wallet sends tx). |
| POST | `/api/admin/mint` | Same as withdraw; requires header `x-api-key: ADMIN_API_KEY`. |
| GET | `/api/admin/status` | Requires `x-api-key`. Returns config status (no secrets). |

## App config

In the **frontend** `ton-config.js` set:

```js
window.TON_CONFIG = {
  backendUrl: 'http://localhost:3002',  // or your deployed backend URL
};
```

The app will:
1. Fetch `GET /api/config` and set the minter address (and show it in Wallet).
2. On "Withdraw", call `POST /api/withdraw` with the connected wallet address and amount; backend mints $CARD to that address.

## Admin controls

- **Withdraw (player):** User clicks Withdraw in the app → frontend calls `POST /api/withdraw` → backend sends mint tx from admin wallet.
- **Admin mint:** You can mint to any address with:
  ```bash
  curl -X POST http://localhost:3002/api/admin/mint \
    -H "Content-Type: application/json" \
    -H "x-api-key: YOUR_ADMIN_API_KEY" \
    -d '{"address":"EQ...","amount":100}'
  ```

## Security

- Keep **ADMIN_MNEMONIC** and **ADMIN_API_KEY** secret; never commit `.env`.
- Use a **dedicated wallet** as minter admin (not your main wallet).
- Use **testnet** first; get testnet TON from [@testgiver_ton_bot](https://t.me/testgiver_ton_bot).
