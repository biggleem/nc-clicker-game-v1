# GitHub Pages setup

Your site shows **"There isn't a GitHub Pages site here"** until GitHub Pages is enabled and has finished deploying.

---

## Fix 404: enable Pages (exact steps)

1. **Open the repo:**  
   **https://github.com/biggleem/nc-clicker-game-v1**  
   (If your repo is under a different user or org, replace `biggleem` with that username.)

2. **Open Settings.**  
   Use the **Settings** tab at the top of the repo (not your profile settings).

3. **Open the Pages section.**  
   In the **left sidebar**, find **“Code and automation”** and click **Pages**.

4. **Set “Build and deployment”.**  
   - **Source:** choose **“Deploy from a branch”** (not “GitHub Actions”).  
   - **Branch:** open the dropdown and select **main** (or **master** if that’s your default branch).  
   - **Folder:** choose **“/ (root)”**.

5. **Save.**  
   Click **Save**. The page may reload.

6. **Wait.**  
   Wait **2–5 minutes**. The first deploy can be slow.

7. **Open your site.**  
   **https://biggleem.github.io/nc-clicker-game-v1/**  
   (Use your actual GitHub username instead of `biggleem` if different.)  
   Try with and without a trailing slash. Do a hard refresh (Ctrl+Shift+R).

---

## Still 404?

- **Repo visibility:** If the repo is **private**, GitHub Pages does **not** work on free accounts. Make the repo **Public** (Settings → General → Danger zone → Change visibility), or use a paid plan.
- **Correct repo:** The URL is always `https://<username>.github.io/<repo-name>/`. So for repo `nc-clicker-game-v1` by user `biggleem` it’s `https://biggleem.github.io/nc-clicker-game-v1/`. If the repo is under an **organization**, use the org name: `https://<org>.github.io/nc-clicker-game-v1/`.
- **Branch and folder:** In Settings → Pages, the branch must be the one that has `index.html` (usually **main**), and the folder must be **/ (root)**.
- **Cache:** Try another browser or an incognito window, and use **https://biggleem.github.io/nc-clicker-game-v1/** (with trailing slash).

---

## After it works

- Your site will be at **https://biggleem.github.io/nc-clicker-game-v1/** (replace username if needed).
- Pushing to the selected branch will trigger a new deploy; wait a minute and refresh.
