# Fix: "Update gh-pages branch" workflow keeps getting cancelled

The **"Update gh-pages branch"** workflow runs when GitHub Pages is set to deploy from the **gh-pages** branch (or when a custom workflow pushes to gh-pages). Cancellations usually happen because:

1. **Concurrency** – A new push cancels the previous run so only the latest deploy runs.
2. **Conflict** – You're using both "Deploy from a branch" with **gh-pages** and pushing from **main**, so the workflow that updates gh-pages keeps getting superseded.

**Recommended fix: deploy from `main` and stop using gh-pages.** Then you don't need the "Update gh-pages branch" workflow at all.

---

## Step 1: Use main + root (no gh-pages)

1. On GitHub: **Settings → Pages**.
2. Under **Build and deployment**:
   - **Source:** **Deploy from a branch**
   - **Branch:** **main** (not gh-pages)
   - **Folder:** **/ (root)**
3. Click **Save**.

GitHub will then serve your site directly from the `main` branch. No "Update gh-pages branch" workflow is involved. The workflow run you see might be an internal deploy; it may still show in Actions, but it won’t be the gh-pages–updating one.

---

## Step 2: Remove the "Deploy to GitHub Pages" workflow (stops failed deployments)

The failed entries in **Deployments → github-pages** are from the **"Deploy to GitHub Pages"** workflow. You **cannot delete** those past deployment records (GitHub keeps history), but you can stop new failures by removing the workflow:

1. On GitHub: open **biggleem/nc-clicker-game-v1** → **Code**.
2. Go to the **`.github/workflows/`** folder.
3. You should see a file like `deploy-pages.yml`, `jekyll.yml`, or similar (the one that shows as "Deploy to GitHub Pages" in Actions).
4. Open that file → click the **trash / Delete file** button (or the three-dots menu → **Delete file**).
5. Commit the deletion (e.g. "Remove Deploy to GitHub Pages workflow").

After this, the workflow will no longer run, so no new failed deployments will appear. The old failed entries will stay in the list but you can ignore them.

After this, **Settings → Pages** should still be **Deploy from a branch → main → / (root)**. The site will deploy from `main` on every push; no separate workflow is required.

---

## If runs still show as "Cancelled"

When you use **Deploy from a branch** with **main**, GitHub may still run an internal "Pages build and deployment" job. If that run is **cancelled**:

- **Cause:** Another push (or trigger) started before the previous run finished. GitHub cancels the old run and runs the new one.
- **Effect:** The **latest** push still deploys. The site should be up to date.
- **What to do:**  
  - **Option A:** Wait 1–2 minutes after a push before pushing again, so the run can finish.  
  - **Option B:** Ignore the cancellation – the most recent run wins and your site at **https://biggleem.github.io/nc-clicker-game-v1/** will reflect the latest `main`.

---

## Summary

| Goal | Action |
|------|--------|
| Stop "Update gh-pages branch" from mattering | **Settings → Pages** → Branch **main**, Folder **/ (root)** → Save |
| Stop custom gh-pages workflow | Delete `.github/workflows/*.yml` that deploys to gh-pages (if any) |
| Fewer cancelled runs | Wait 1–2 min after each push, or accept that the latest run wins |

Your app is static (HTML/JS at repo root), so **main + / (root)** is the right setup; no gh-pages branch and no custom deploy workflow are needed.
