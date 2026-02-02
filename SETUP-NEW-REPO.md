# Set up the nc-clicker-game-v1 repository

This project is a copy of the Token Clicker game, configured for the **nc-clicker-game-v1** repo and **https://biggleem.github.io/nc-clicker-game-v1/**.

## 1. Create the repository on GitHub

1. Go to **https://github.com/new**
2. **Repository name:** `nc-clicker-game-v1`
3. **Public**, and leave **Add a README** unchecked (this folder already has files)
4. Click **Create repository**

## 2. Push this folder to the new repo

From this folder (`nc-clicker-game-v1`) in a terminal:

```powershell
git add -A
git commit -m "Initial commit: nc-clicker-game-v1"
git remote add origin https://github.com/biggleem/nc-clicker-game-v1.git
git push -u origin main
```

If the repo already had a remote or you use SSH:

```powershell
git remote add origin git@github.com:biggleem/nc-clicker-game-v1.git
git push -u origin main
```

## 3. Enable GitHub Pages

1. On GitHub: **biggleem/nc-clicker-game-v1** → **Settings** → **Pages**
2. **Source:** Deploy from a branch
3. **Branch:** main → **/ (root)**
4. Click **Save**
5. Wait 2–5 minutes, then open **https://biggleem.github.io/nc-clicker-game-v1/**

Done. The game will be live at that URL.
