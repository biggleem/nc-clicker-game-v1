-- =============================================================================
-- ALL MIGRATIONS FOR SUPABASE SQL EDITOR
-- Copy this file into Supabase → SQL Editor → New query.
-- Run the whole file once on a fresh project, or run sections individually if
-- you've already applied some (use -- to comment out applied sections).
-- =============================================================================

-- ========== 001: Initial tables (leaderboard, rooms) ==========
-- Token Clicker: initial tables for leaderboard and PVP rooms
CREATE TABLE IF NOT EXISTS public.leaderboard (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  tokens BIGINT NOT NULL DEFAULT 0,
  wallet_address TEXT,
  ref_code TEXT,
  updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.leaderboard ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read leaderboard" ON public.leaderboard;
CREATE POLICY "Anyone can read leaderboard"
  ON public.leaderboard FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS "Anyone can insert row" ON public.leaderboard;
CREATE POLICY "Anyone can insert row"
  ON public.leaderboard FOR INSERT TO anon WITH CHECK (true);

DROP POLICY IF EXISTS "Anyone can update row" ON public.leaderboard;
CREATE POLICY "Anyone can update row"
  ON public.leaderboard FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS public.rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'finished')),
  player1_wallet TEXT,
  player2_wallet TEXT,
  winner_wallet TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.rooms ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read rooms" ON public.rooms;
CREATE POLICY "Anyone can read rooms"
  ON public.rooms FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS "Anyone can create room" ON public.rooms;
CREATE POLICY "Anyone can create room"
  ON public.rooms FOR INSERT TO anon WITH CHECK (true);

DROP POLICY IF EXISTS "Anyone can update room" ON public.rooms;
CREATE POLICY "Anyone can update room"
  ON public.rooms FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE INDEX IF NOT EXISTS idx_leaderboard_tokens ON public.leaderboard (tokens DESC);
CREATE INDEX IF NOT EXISTS idx_rooms_status ON public.rooms (status);


-- ========== 002: Rooms stake and game fields ==========
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS stake_amount INTEGER DEFAULT 5;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player1_name TEXT;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player2_name TEXT;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player1_clicks INTEGER DEFAULT 0;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player2_clicks INTEGER DEFAULT 0;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS game_started_at TIMESTAMPTZ;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS game_ends_at TIMESTAMPTZ;


-- ========== 003: Friends by code ==========
CREATE TABLE IF NOT EXISTS public.friends_by_code (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_wallet TEXT NOT NULL,
  friend_ref_code TEXT NOT NULL,
  friend_name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.friends_by_code ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read friends_by_code" ON public.friends_by_code;
CREATE POLICY "Anyone can read friends_by_code"
  ON public.friends_by_code FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS "Anyone can insert friends_by_code" ON public.friends_by_code;
CREATE POLICY "Anyone can insert friends_by_code"
  ON public.friends_by_code FOR INSERT TO anon WITH CHECK (true);

CREATE INDEX IF NOT EXISTS idx_friends_by_code_user ON public.friends_by_code (user_wallet);
CREATE UNIQUE INDEX IF NOT EXISTS idx_friends_by_code_user_ref ON public.friends_by_code (user_wallet, friend_ref_code);


-- ========== 004: Friends by code delete policy ==========
DROP POLICY IF EXISTS "Anyone can delete friends_by_code" ON public.friends_by_code;
CREATE POLICY "Anyone can delete friends_by_code"
  ON public.friends_by_code FOR DELETE TO anon USING (true);


-- ========== 005: Rooms RPC + Realtime ==========
DROP FUNCTION IF EXISTS public.increment_pvp_clicks(uuid, int);
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

GRANT EXECUTE ON FUNCTION public.increment_pvp_clicks(uuid, int) TO anon;
GRANT EXECUTE ON FUNCTION public.increment_pvp_clicks(uuid, int) TO authenticated;

DO $$ BEGIN ALTER PUBLICATION supabase_realtime ADD TABLE public.rooms; EXCEPTION WHEN OTHERS THEN IF SQLERRM NOT LIKE '%already%member%' THEN RAISE; END IF; END $$;


-- ========== 006: Rooms rematch ==========
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS rematch_until TIMESTAMPTZ;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player1_wants_rematch BOOLEAN DEFAULT false;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player2_wants_rematch BOOLEAN DEFAULT false;


-- ========== 007: Leaderboard Realtime ==========
DO $$ BEGIN ALTER PUBLICATION supabase_realtime ADD TABLE public.leaderboard; EXCEPTION WHEN OTHERS THEN IF SQLERRM NOT LIKE '%already%member%' THEN RAISE; END IF; END $$;


-- ========== 008: Referrals table + delete policy ==========
CREATE TABLE IF NOT EXISTS public.referrals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  inviter_ref_code TEXT NOT NULL,
  invited_name TEXT NOT NULL,
  invited_wallet TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.referrals ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can delete referrals" ON public.referrals;
CREATE POLICY "Anyone can delete referrals"
  ON public.referrals FOR DELETE TO anon USING (true);

DROP POLICY IF EXISTS "Anyone can read referrals" ON public.referrals;
CREATE POLICY "Anyone can read referrals"
  ON public.referrals FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS "Anyone can insert referrals" ON public.referrals;
CREATE POLICY "Anyone can insert referrals"
  ON public.referrals FOR INSERT TO anon WITH CHECK (true);

CREATE INDEX IF NOT EXISTS idx_referrals_inviter ON public.referrals (inviter_ref_code);


-- ========== 009: Referrals Realtime ==========
DO $$ BEGIN ALTER PUBLICATION supabase_realtime ADD TABLE public.referrals; EXCEPTION WHEN OTHERS THEN IF SQLERRM NOT LIKE '%already%member%' THEN RAISE; END IF; END $$;


-- ========== 010: Leaderboard ref_code ==========
ALTER TABLE public.leaderboard ADD COLUMN IF NOT EXISTS ref_code TEXT;


-- ========== 011: Friend requests table ==========
CREATE TABLE IF NOT EXISTS public.friend_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  from_wallet TEXT NOT NULL,
  to_wallet TEXT NOT NULL,
  from_name TEXT NOT NULL,
  to_name TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.friend_requests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read friend_requests" ON public.friend_requests;
CREATE POLICY "Anyone can read friend_requests"
  ON public.friend_requests FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS "Anyone can insert friend_requests" ON public.friend_requests;
CREATE POLICY "Anyone can insert friend_requests"
  ON public.friend_requests FOR INSERT TO anon WITH CHECK (true);

DROP POLICY IF EXISTS "Anyone can update friend_requests" ON public.friend_requests;
CREATE POLICY "Anyone can update friend_requests"
  ON public.friend_requests FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE INDEX IF NOT EXISTS idx_friend_requests_to_wallet ON public.friend_requests (to_wallet);
CREATE INDEX IF NOT EXISTS idx_friend_requests_from_wallet ON public.friend_requests (from_wallet);
CREATE INDEX IF NOT EXISTS idx_friend_requests_status ON public.friend_requests (status);
CREATE UNIQUE INDEX IF NOT EXISTS idx_friend_requests_pair ON public.friend_requests (from_wallet, to_wallet);


-- ========== 012: Friend requests Realtime ==========
DO $$ BEGIN ALTER PUBLICATION supabase_realtime ADD TABLE public.friend_requests; EXCEPTION WHEN OTHERS THEN IF SQLERRM NOT LIKE '%already%member%' THEN RAISE; END IF; END $$;


-- ========== 013: Rooms wager agreement ==========
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player1_wager_agreed BOOLEAN DEFAULT false;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player2_wager_agreed BOOLEAN DEFAULT false;


-- ========== 014: Leaderboard pvp_wins ==========
ALTER TABLE public.leaderboard ADD COLUMN IF NOT EXISTS pvp_wins INTEGER DEFAULT 0;


-- ========== 015: Leaderboard pvp_tokens_won ==========
ALTER TABLE public.leaderboard ADD COLUMN IF NOT EXISTS pvp_tokens_won INTEGER DEFAULT 0;


-- ========== 016: Rooms room_name ==========
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS room_name TEXT;


-- ========== 017: Leaderboard player_id (guests + duplicate fix) ==========
ALTER TABLE public.leaderboard ADD COLUMN IF NOT EXISTS player_id TEXT;

UPDATE public.leaderboard SET player_id = wallet_address WHERE wallet_address IS NOT NULL AND (player_id IS NULL OR player_id = '');

UPDATE public.leaderboard
SET player_id = NULL
WHERE id IN (
  SELECT id FROM (
    SELECT id,
           ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY id) AS rn
    FROM public.leaderboard
    WHERE player_id IS NOT NULL AND player_id != ''
  ) sub
  WHERE rn > 1
);

DROP INDEX IF EXISTS public.idx_leaderboard_player_id;

CREATE UNIQUE INDEX idx_leaderboard_player_id
ON public.leaderboard (player_id)
WHERE player_id IS NOT NULL AND player_id != '';

COMMENT ON COLUMN public.leaderboard.player_id IS 'Unique player id: wallet_address when connected, or guest_xxx for anonymous.';


-- ========== 018: Rooms player ready (both click Ready → 5s countdown → race) ==========
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player1_ready BOOLEAN DEFAULT false;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player2_ready BOOLEAN DEFAULT false;
