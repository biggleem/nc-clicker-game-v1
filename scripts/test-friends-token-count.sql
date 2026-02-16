-- ============================================================
-- Test: Friends token count with the database
-- ============================================================
-- Run this in Supabase Dashboard → SQL Editor (paste and Run).
-- It verifies the same join the app uses: friends_by_code + leaderboard
-- so friend token counts display correctly (and realtime updates work).
-- ============================================================

-- 1) All friends with their token count (join by ref_code)
--    App uses: leaderboard.ref_code ILIKE friend_ref_code
SELECT
  f.user_wallet AS "Your wallet/id",
  f.friend_ref_code AS "Friend code",
  f.friend_name AS "Friend name",
  COALESCE(lb.tokens::text, '—') AS "Tokens",
  CASE WHEN lb.id IS NOT NULL THEN 'yes' ELSE 'no' END AS "In leaderboard?"
FROM public.friends_by_code f
LEFT JOIN public.leaderboard lb
  ON UPPER(TRIM(lb.ref_code)) = UPPER(TRIM(f.friend_ref_code))
ORDER BY f.user_wallet, f.friend_ref_code;

-- 2) Summary
SELECT
  COUNT(*) AS total_friend_entries,
  COUNT(lb.id) AS with_leaderboard_match,
  COUNT(*) - COUNT(lb.id) AS missing_leaderboard_match
FROM public.friends_by_code f
LEFT JOIN public.leaderboard lb
  ON UPPER(TRIM(lb.ref_code)) = UPPER(TRIM(f.friend_ref_code));

-- 3) Leaderboard rows that have ref_code (needed for friends token count)
SELECT name, ref_code, tokens, player_id
FROM public.leaderboard
WHERE ref_code IS NOT NULL AND TRIM(ref_code) <> ''
ORDER BY ref_code;
