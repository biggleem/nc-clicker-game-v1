# GitHub Pages – settings checklist (fix 404)

Your repo has all the files (including `index.html`). The 404 means **Pages is not publishing yet**. Do **one** of the two options below.

---

## Option A: Deploy from a branch (simplest)

1. Open **https://github.com/biggleem/nc-clicker-game-v1**
2. Click **Settings** (top tab bar of the repo).
3. Left sidebar → **Pages** (under "Code and automation").
4. Under **"Build and deployment"**:
   - **Source:** must be **"Deploy from a branch"** (not "None").
   - **Branch:** open the dropdown → choose **main** (not "None").
   - **Folder:** choose **/ (root)**.
5. Click **Save** (top right of that section).
6. Wait 2–5 minutes, then open **https://biggleem.github.io/nc-clicker-game-v1/**

**If you don’t see "main" in the Branch dropdown:** the default branch might have another name (e.g. `master`). Pick the branch that has `index.html` at the root.

---

## Option B: Deploy with GitHub Actions (if A doesn’t work)

A workflow file was added (`.github/workflows/deploy-pages.yml`) so you can publish via Actions.

1. Push the new workflow to GitHub (commit and push the `.github` folder if you haven’t).
2. Open **https://github.com/biggleem/nc-clicker-game-v1** → **Settings** → **Pages**.
3. Under **"Build and deployment"** → **Source:** choose **"GitHub Actions"**.
4. Save. No branch or folder to select.
5. Go to the **Actions** tab. Run the **"Deploy to GitHub Pages"** workflow (Run workflow) or push a commit to `main` to trigger it.
6. After the workflow succeeds (green check), wait 1–2 minutes and open **https://biggleem.github.io/nc-clicker-game-v1/**

---

## Must-check

- **Repo is public**  
  Settings → General → scroll to "Danger zone". If it says "Change repository visibility" and the repo is **Private**, make it **Public** (free accounts don’t get Pages for private repos).

- **You clicked Save**  
  After changing Source/Branch/Folder, the **Save** button must be clicked or the 404 will stay.

- **Correct URL**  
  Use **https://biggleem.github.io/nc-clicker-game-v1/** (with trailing slash). Replace `biggleem` with your real GitHub username if different.
