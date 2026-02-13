-- Enable Realtime for friend_requests so the receiver gets notified when someone sends a request.
-- Run in Supabase SQL Editor. If "already member" error: add table in Dashboard → Database → Replication → supabase_realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.friend_requests;
