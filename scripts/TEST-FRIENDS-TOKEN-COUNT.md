# Test friends token count with the database

This checks that friend token counts work the same way the app does: join `friends_by_code` with `leaderboard` on `ref_code`.

## Run in Supabase

1. Open **Supabase Dashboard** → your project → **SQL Editor**.
2. Open `scripts/test-friends-token-count.sql`, copy its contents, paste into the editor, then **Run**.

## What the queries do

1. **Query 1** – Lists every friend row with the token count from `leaderboard` (same join the app uses). If a friend has no matching leaderboard row or their row has no `ref_code`, tokens show as `—`.

2. **Query 2** – Counts how many friend entries have a matching leaderboard row. If `missing_leaderboard_match` &gt; 0, those friends need a leaderboard row with `ref_code` set (e.g. they open the game, set name in Wallet → Settings, and Save so their code is synced).

3. **Query 3** – Lists all leaderboard rows that have a `ref_code`. These are the only rows that can show up as “X tokens” for a friend.

## If a friend shows 0 or no tokens

- Their **leaderboard** row must have `ref_code` set and it must match the code stored in `friends_by_code` (case-insensitive).
- In the app they should: open the game → Wallet → Settings → set name → Save (this syncs `ref_code` to the leaderboard).
- Realtime: ensure **Realtime** is enabled for `leaderboard` (e.g. run `supabase/migrations/007_leaderboard_realtime.sql` or enable in Dashboard → Database → Replication).

## Quick one-query check for one user

To see friends and token counts for a single player (replace `YOUR_WALLET_OR_PLAYER_ID`):

```sql
SELECT f.friend_name, f.friend_ref_code, lb.tokens
FROM public.friends_by_code f
LEFT JOIN public.leaderboard lb ON UPPER(TRIM(lb.ref_code)) = UPPER(TRIM(f.friend_ref_code))
WHERE f.user_wallet = 'YOUR_WALLET_OR_PLAYER_ID'
ORDER BY f.friend_ref_code;
```
