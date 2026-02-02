# Create $CARD minter contract address

You need a **Jetton minter contract** on TON so the game backend can mint $CARD to players. The minter address goes in the backend Setup (http://localhost:3002/setup) as **$CARD minter contract address**.

## Option A: Official web deployer (easiest)

Use the official TON Jetton deployer. No code required.

### Testnet (free)

1. **Get testnet TON**  
   Open [@testgiver_ton_bot](https://t.me/testgiver_ton_bot) in Telegram and request testnet TON for your wallet address.

2. **Open the deployer**  
   [https://minter.ton.org?testnet=true](https://minter.ton.org?testnet=true)

3. **Connect wallet**  
   Click **Connect Wallet** and connect Tonkeeper or Telegram Wallet (use the same wallet that has testnet TON).

4. **Fill the form**
   - **Name:** `$CARD`
   - **Ticker:** `CARD`
   - **Image URL:** `https://raw.githubusercontent.com/biggleem/nc-clicker-game-v1/main/assets/cardinal.png`  
     (or any public image URL)
   - **Description (optional):** `1N Blockchain Token Clicker – earn by tapping the Cardinal.`

5. **Deploy**  
   Click **Deploy** and approve the transaction in your wallet. You need about **0.25 TON** (testnet is free from the faucet).

6. **Copy the minter address**  
   After the transaction confirms, the page shows your Jetton. The **contract address** of the minter (starts with `EQ...` or `UQ...`) is your **$CARD minter contract address**. Copy it.

7. **Use it in Token Clicker**  
   - Open http://localhost:3002/setup  
   - Paste this address into **$CARD minter contract address**  
   - Use the **same wallet’s** 24 words as **Admin mnemonic** (the deployer makes that wallet the minter admin)  
   - Save and restart the backend  

### Mainnet

1. Use [https://minter.ton.org](https://minter.ton.org) (no `?testnet=true`).
2. Your wallet must have at least **~0.25 TON** for deployment.
3. Same form and steps as testnet; then paste the minter address into Setup and set Admin mnemonic to the wallet that deployed (the admin).

---

## Option B: Deploy from this repo (Blueprint)

If you prefer to deploy from code and have Node.js installed:

```bash
# From nc-clicker-game-v1 repo root
npx create-ton@latest card-jetton -- --template tact-counter
# Or use the Jetton template if your create-ton version offers it
cd card-jetton
npm install
npm run build
npx blueprint run
```

Then copy the deployed minter address into the backend Setup.

---

## After you have the minter address

1. Open **http://localhost:3002/setup**
2. **Admin mnemonic:** 24 words of the wallet that **deployed** the Jetton (that wallet is the minter admin and pays for minting).
3. **$CARD minter contract address:** The minter address you got from minter.ton.org (or Blueprint).
4. **Network:** Testnet or Mainnet, same as where you deployed.
5. Click **Save to .env**, then **restart the backend** (stop and run `node index.js` again in the `backend/` folder).

Your **personal wallet** (e.g. Tonkeeper) that you use in the game can be different from the admin wallet; the minter address is the **contract**, not a wallet address.
