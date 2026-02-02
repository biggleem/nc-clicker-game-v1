# Best approach to deploy Token Clicker

Use **two parts**: frontend on GitHub Pages (free), backend on a Node host (free tier).

---

## 1. Frontend → GitHub Pages (recommended)

- **Cost:** Free  
- **Why:** Already set up; static files (HTML, JS, assets) and TonConnect work from a single origin.

**Steps:**

1. Push your code to `main` on `github.com/biggleem/nc-clicker-game-v1`.
2. In the repo: **Settings → Pages**.
3. **Source:** “Deploy from a branch”.
4. **Branch:** `main`, **Folder:** `/ (root)`.
5. Click **Save**. Wait 1–2 minutes.
6. Site: **https://biggleem.github.io/nc-clicker-game-v1/**

**Root must contain:** `index.html`, `.nojekyll`, `assets/`, `dist/wallet.js`, `ton-config.js`, `supabase-config.js`, `tonconnect-manifest.json`. No build step needed.

---

## 2. Backend → Render or Railway (recommended)

The backend is a Node/Express app in `backend/`. It provides `/api/config`, `/api/withdraw`, `/api/admin/mint`, etc.

### Option A: Render (free tier)

1. Go to [render.com](https://render.com), sign in with GitHub.
2. **New → Web Service**. Connect repo `biggleem/nc-clicker-game-v1`.
3. **Settings:**
   - **Root Directory:** `backend`
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Instance type:** Free (may spin down after ~15 min idle; first request can be slow).
4. **Environment:** Add variables (use “Secret” for sensitive ones):
   - `PORT` = `3002` (or leave default; Render sets `PORT`)
   - `TON_NETWORK` = `testnet` or `mainnet`
   - `TON_CARD_MINTER_ADDRESS` = your minter address
   - `ADMIN_MNEMONIC` = your 24-word admin wallet mnemonic (secret)
   - `ADMIN_API_KEY` = optional secret for admin endpoints
5. Deploy. Note the URL, e.g. `https://nc-clicker-game-v1-api.onrender.com`.

### Option B: Railway (free tier)

1. Go to [railway.app](https://railway.app), sign in with GitHub.
2. **New Project → Deploy from GitHub** → select `nc-clicker-game-v1`.
3. Add **root directory:** `backend`. Railway will detect Node and run `npm install` + `npm start`.
4. **Variables:** Add the same env vars as above (`PORT`, `TON_NETWORK`, `TON_CARD_MINTER_ADDRESS`, `ADMIN_MNEMONIC`, `ADMIN_API_KEY`).
5. **Settings → Generate Domain**. Copy the URL, e.g. `https://nc-clicker-game-v1-production-xxxx.up.railway.app`.

---

## 3. Point frontend to the backend (production)

After the backend is live:

1. Open **`ton-config.js`** in the repo root.
2. Set **`PRODUCTION_BACKEND_URL`** to your backend URL (no trailing slash), e.g.  
   `var PRODUCTION_BACKEND_URL = 'https://nc-clicker-game-v1-api.onrender.com';`
3. Commit and push to `main`. GitHub Pages will serve the update; the live site will then use this backend for config, withdraw, and admin.

**Behavior:**  
- On **https://biggleem.github.io/nc-clicker-game-v1** the app uses `PRODUCTION_BACKEND_URL`.  
- On **localhost** it uses `http://localhost:3002` so you can develop with a local backend.

---

## 4. CORS

The backend uses `cors()` with no origin restriction, so requests from `https://biggleem.github.io` are allowed. If you lock CORS down later, allow origin `https://biggleem.github.io`.

---

## Summary

| Part      | Where              | URL / note                                      |
|-----------|--------------------|-------------------------------------------------|
| Frontend  | GitHub Pages       | https://biggleem.github.io/nc-clicker-game-v1/       |
| Backend   | Render or Railway  | Set in `ton-config.js` → `PRODUCTION_BACKEND_URL` |
| Supabase  | Already cloud      | Configured in `supabase-config.js`              |

**Frontend-only:** If you only need the game + TonConnect (no withdraw), GitHub Pages alone is enough; leave `PRODUCTION_BACKEND_URL` empty until you deploy the backend.
