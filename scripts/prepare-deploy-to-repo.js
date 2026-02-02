/**
 * Prepare the app to deploy to a different GitHub repo.
 * Usage: node scripts/prepare-deploy-to-repo.js <new-repo-name>
 * Example: node scripts/prepare-deploy-to-repo.js my-token-clicker
 *
 * Replaces "nc-clicker-game-v1" with the new repo name in:
 * - index.html, src/wallet.js, tonconnect-manifest.json
 * - backend/index.js, contracts/card-metadata.json, contracts/DEPLOY-CARD.md
 * Then run: npm run build:wallet
 * Then: git add -A && git remote add deploy https://github.com/biggleem/NEW_REPO.git && git push deploy main
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');

const newRepo = process.argv[2];
if (!newRepo || !/^[a-zA-Z0-9_-]+$/.test(newRepo)) {
  console.error('Usage: node scripts/prepare-deploy-to-repo.js <new-repo-name>');
  console.error('Example: node scripts/prepare-deploy-to-repo.js my-token-clicker');
  process.exit(1);
}

const OLD = 'nc-clicker-game-v1';
const files = [
  'index.html',
  'src/wallet.js',
  'tonconnect-manifest.json',
  'backend/index.js',
  'contracts/card-metadata.json',
  'contracts/DEPLOY-CARD.md',
  'ENABLE-PAGES.md',
  'PAGES-FIX-NOW.md',
  'PAGES-SETTINGS-CHECKLIST.md',
  'GITHUB-PAGES.md',
  'README.md',
  'WALLET-TEST.md',
  'DEPLOY-TO-NC-CARDINAL.md',
];

let updated = 0;
for (const file of files) {
  const filePath = path.join(root, file);
  if (!fs.existsSync(filePath)) continue;
  let content = fs.readFileSync(filePath, 'utf8');
  const newContent = content.split(OLD).join(newRepo);
  if (newContent !== content) {
    fs.writeFileSync(filePath, newContent);
    console.log('Updated:', file);
    updated++;
  }
}

console.log('\nDone. Updated', updated, 'files.');
console.log('Next: npm run build:wallet');
console.log('Then: git add -A && git commit -m "Prepare for deploy to ' + newRepo + '"');
console.log('Then: git remote add deploy https://github.com/biggleem/' + newRepo + '.git  (or set-url if exists)');
console.log('Then: git push deploy main');
console.log('In GitHub: repo ' + newRepo + ' → Settings → Pages → Deploy from branch → main → / (root) → Save');
console.log('Site: https://biggleem.github.io/' + newRepo + '/');
