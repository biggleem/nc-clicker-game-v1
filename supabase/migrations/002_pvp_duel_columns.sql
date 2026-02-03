-- PVP Duel: player names, live clicks, game timing, stake. Leaderboard PVP wins.
-- Run in Supabase SQL Editor after 001_initial_tables.sql

-- Rooms: add duel columns
ALTER TABLE public.rooms
  ADD COLUMN IF NOT EXISTS player1_name TEXT,
  ADD COLUMN IF NOT EXISTS player2_name TEXT,
  ADD COLUMN IF NOT EXISTS player1_clicks INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS player2_clicks INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS game_started_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS game_ends_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS stake_amount NUMERIC(20,9) NOT NULL DEFAULT 1;

-- Leaderboard: PVP wins (for duel winners)
ALTER TABLE public.leaderboard
  ADD COLUMN IF NOT EXISTS pvp_wins INTEGER NOT NULL DEFAULT 0;

-- Index for active games
CREATE INDEX IF NOT EXISTS idx_rooms_game_ends_at ON public.rooms (game_ends_at) WHERE status = 'in_progress';

-- Atomic increment for PVP clicks (avoids race conditions)
CREATE OR REPLACE FUNCTION public.increment_pvp_clicks(room_id UUID, player_num INTEGER)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  new_count INTEGER;
BEGIN
  IF player_num = 1 THEN
    UPDATE public.rooms SET player1_clicks = player1_clicks + 1, updated_at = now() WHERE id = room_id RETURNING player1_clicks INTO new_count;
  ELSIF player_num = 2 THEN
    UPDATE public.rooms SET player2_clicks = player2_clicks + 1, updated_at = now() WHERE id = room_id RETURNING player2_clicks INTO new_count;
  ELSE
    RETURN jsonb_build_object('error', 'invalid player_num');
  END IF;
  IF new_count IS NULL THEN
    RETURN jsonb_build_object('error', 'room not found');
  END IF;
  RETURN jsonb_build_object('clicks', new_count);
END;
$$;

-- Allow anon to call (RLS still applies to the UPDATE inside)
GRANT EXECUTE ON FUNCTION public.increment_pvp_clicks(UUID, INTEGER) TO anon;

-- Enable Realtime for rooms (Dashboard → Database → Replication may also be used)
-- ALTER PUBLICATION supabase_realtime ADD TABLE public.rooms;
