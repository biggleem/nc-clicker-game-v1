-- PVP: atomic click increment RPC so both players see updates; enable Realtime for rooms.
-- Run in Supabase SQL Editor.

-- RPC: increment player1_clicks or player2_clicks for a room (atomic, returns new count).
CREATE OR REPLACE FUNCTION public.increment_pvp_clicks(room_id uuid, player_num int)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  new_clicks int := 0;
BEGIN
  IF player_num = 1 THEN
    UPDATE public.rooms
    SET player1_clicks = COALESCE(player1_clicks, 0) + 1,
        updated_at = now()
    WHERE id = room_id AND status = 'in_progress'
    RETURNING player1_clicks INTO new_clicks;
  ELSIF player_num = 2 THEN
    UPDATE public.rooms
    SET player2_clicks = COALESCE(player2_clicks, 0) + 1,
        updated_at = now()
    WHERE id = room_id AND status = 'in_progress'
    RETURNING player2_clicks INTO new_clicks;
  END IF;
  RETURN json_build_object('clicks', COALESCE(new_clicks, 0));
END;
$$;

-- Allow anon to call the RPC
GRANT EXECUTE ON FUNCTION public.increment_pvp_clicks(uuid, int) TO anon;
GRANT EXECUTE ON FUNCTION public.increment_pvp_clicks(uuid, int) TO authenticated;

-- Enable Realtime for rooms so postgres_changes (click updates) are pushed to the other player.
-- If this errors ("already member of publication"), enable in Dashboard: Database → Replication → supabase_realtime → add table "rooms".
ALTER PUBLICATION supabase_realtime ADD TABLE public.rooms;
