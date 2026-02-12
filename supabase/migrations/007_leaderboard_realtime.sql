-- Enable Realtime for leaderboard so friend token counts update in real time.
-- Run in Supabase SQL Editor or via migration.
-- If this errors ("already member of publication"), enable in Dashboard: Database → Replication → supabase_realtime → add table "leaderboard".
ALTER PUBLICATION supabase_realtime ADD TABLE public.leaderboard;
