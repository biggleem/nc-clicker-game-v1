-- Enable Realtime for referrals so inviter gets notified when someone accepts their invite link.
-- Run in Supabase SQL Editor. If "already member" error: add table in Dashboard → Database → Replication → supabase_realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.referrals;
