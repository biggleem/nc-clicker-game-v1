/**
 * Run migration 017 (leaderboard.player_id) on your Supabase project.
 *
 * Option A – CLI (if you already ran supabase login and db:link):
 *   npm run db:push
 *
 * Option B – This script: tries db push; if it fails, prints SQL and Dashboard link.
 */
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', '017_leaderboard_player_id_internal_wallet.sql');
const sql = fs.readFileSync(migrationPath, 'utf8');
const dashboardUrl = 'https://supabase.com/dashboard/project/kjzuyncvahefckizbigb/sql/new';

function main() {
  try {
    execSync('npx supabase db push', {
      stdio: 'inherit',
      cwd: path.join(__dirname, '..'),
    });
    console.log('Migration applied via Supabase CLI.');
    return;
  } catch (e) {
    // Not linked or not logged in
  }

  console.log('');
  console.log('Supabase CLI is not linked or not logged in. Run the migration manually:');
  console.log('');
  console.log('1. Open SQL Editor:');
  console.log('   ' + dashboardUrl);
  console.log('');
  console.log('2. Paste and run this SQL:');
  console.log('---');
  console.log(sql);
  console.log('---');
  console.log('');
  console.log('Or link the CLI then push:');
  console.log('   npx supabase login');
  console.log('   npm run db:link');
  console.log('   npm run db:push');
}

main();
