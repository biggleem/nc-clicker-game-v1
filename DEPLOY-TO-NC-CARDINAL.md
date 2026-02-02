# Deploy Token Clicker to nc-clicker-game-v1 repo

The app is configured for **https://biggleem.github.io/nc-clicker-game-v1**. To get it running there:

## Option A: Push this repo to nc-clicker-game-v1

1. **Create the repo** (if it doesn’t exist):  
   GitHub → New repository → name: **nc-clicker-game-v1** → Create.

2. **Add it as a remote and push** (from this folder):
   ```bash
   git remote add nc https://github.com/biggleem/nc-clicker-game-v1.git
   git push nc main
   ```
   If the remote already exists: `git remote set-url nc https://github.com/biggleem/nc-clicker-game-v1.git` then `git push nc main`.

3. **Turn on GitHub Pages** for nc-clicker-game-v1:  
   Settings → Pages → Source: **Deploy from a branch** → Branch: **main** → Folder: **/ (root)** → Save.

4. Wait 1–2 minutes, then open **https://biggleem.github.io/nc-clicker-game-v1/**.

---

## Option B: Copy files into nc-clicker-game-v1

If nc-clicker-game-v1 already exists and has other content:

1. Clone nc-clicker-game-v1:  
   `git clone https://github.com/biggleem/nc-clicker-game-v1.git`
2. Copy into it (from this project):  
   `index.html`, `tonconnect-manifest.json`, `ton-config.js`, `supabase-config.js`, `assets/`, `dist/`, `src/`, and the rest of the app files (see list in repo root).
3. Commit and push:  
   `git add -A && git commit -m "Token Clicker app" && git push`
4. Ensure Pages is on for that repo (Settings → Pages → Deploy from branch → main → / (root)).

---

## If “still not working”

- **404:** Pages is off or wrong branch/folder. In the repo: Settings → Pages → Deploy from a branch → main → / (root) → Save.
- **Wallet won’t connect:** Use the live URL (biggleem.github.io/nc-clicker-game-v1), not file:// or localhost, and tap Approve in Tonkeeper.
- **Wrong repo name:** If your repo is different (e.g. `NC-Cardinal-Clicker-Game`), say the exact name and we can update the URLs in the app.
