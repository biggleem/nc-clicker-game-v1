# Deploy by copying this repo to another repo

You can deploy the Token Clicker app by pushing this project to a **new GitHub repo** and enabling Pages there. Use this if the current repo (nc-clicker-game-v1) keeps failing to deploy.

---

## 1. Create a new repo on GitHub

1. Go to **https://github.com/new**
2. **Repository name:** choose a name (e.g. **token-clicker-app**, **my-token-clicker**, **cardinal-clicker**).
3. **Public**, no need to add README or .gitignore.
4. Click **Create repository**.

---

## 2. Prepare the app for the new repo name

From this project folder (nc-clicker-game-v1), run:

```bash
node scripts/prepare-deploy-to-repo.js YOUR-NEW-REPO-NAME
```

Example:

```bash
node scripts/prepare-deploy-to-repo.js token-clicker-app
```

This updates all URLs in the app (manifest, links) so they use **biggleem.github.io/YOUR-NEW-REPO-NAME**. Then rebuild the wallet:

```bash
npm run build:wallet
```

---

## 3. Add the new repo as a remote and push

```bash
git add -A
git commit -m "Prepare for deploy to YOUR-NEW-REPO-NAME"
git remote add deploy https://github.com/biggleem/YOUR-NEW-REPO-NAME.git
git push deploy main
```

If the remote **deploy** already exists:

```bash
git remote set-url deploy https://github.com/biggleem/YOUR-NEW-REPO-NAME.git
git push deploy main
```

---

## 4. Enable GitHub Pages on the new repo

1. Open **https://github.com/biggleem/YOUR-NEW-REPO-NAME**
2. **Settings** → **Pages**
3. **Build and deployment** → **Source:** **Deploy from a branch**
4. **Branch:** **main** → **Folder:** **/ (root)**
5. Click **Save**

---

## 5. Open the site

After 1–2 minutes, open:

**https://biggleem.github.io/YOUR-NEW-REPO-NAME/**

The game and wallet will use this URL for the manifest, so Tonkeeper should connect correctly.

---

## Summary

| Step | Action |
|------|--------|
| 1 | Create new repo on GitHub |
| 2 | `node scripts/prepare-deploy-to-repo.js <repo-name>` then `npm run build:wallet` |
| 3 | `git add -A && git commit -m "..." && git remote add deploy https://github.com/biggleem/<repo-name>.git && git push deploy main` |
| 4 | In new repo: Settings → Pages → Deploy from branch → main → / (root) → Save |
| 5 | Open https://biggleem.github.io/<repo-name>/ |
