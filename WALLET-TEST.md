# TON wallet connection – test checklist

Use this to verify the wallet connects before moving on.

## Where to test

- **Best:** **https://biggleem.github.io/nc-clicker-game-v1** (live). Tonkeeper trusts this URL; localhost can sometimes get "Connection declined."
- **Or:** `npx serve . -p 3001` then open **http://localhost:3001** (Wallet may work; if you see "Connection declined," use the live URL.)

## Steps

1. **Open the app** in a desktop browser (Chrome/Edge/Firefox).
2. **Go to the Wallet page** (bottom nav → WALLET).
3. **Click "CONNECT WALLET (Tonkeeper / Telegram)."**
   - A modal should open with a QR code and wallet options.
4. **On your phone:** Open **Tonkeeper**, scan the QR code.
5. **In Tonkeeper:** Tap the green **Approve** button (do not tap Decline).
6. **On desktop:** Return to the browser tab. Either:
   - The wallet may connect automatically when the tab regains focus, or
   - Click the green **"I approved – check connection"** button.
7. **Success:** You see your TON address (short form) and a DISCONNECT button; the "Connect wallet" block is hidden.

## If it doesn’t connect

- Make sure you tapped **Approve** in Tonkeeper.
- Use the **live URL** (biggleem.github.io) if you were on localhost.
- Click **"I approved – check connection"** and wait for the "Checking…" loop (up to ~18 seconds).
- Hard refresh the page (Ctrl+Shift+R) and try again.
- In the browser console (F12 → Console), check for red errors and report them if you need help.

## After a successful test

You can move on to the next features; the wallet is ready for withdraw and future TON features.
