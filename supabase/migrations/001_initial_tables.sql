-- Token Clicker: initial tables for leaderboard and PVP rooms
-- Run this in Supabase: SQL Editor → New query → paste → Run

-- Leaderboard (Friends page)
CREATE TABLE IF NOT EXISTS public.leaderboard (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  tokens BIGINT NOT NULL DEFAULT 0,
  wallet_address TEXT,
  ref_code TEXT,
  updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.leaderboard ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read leaderboard"
  ON public.leaderboard FOR SELECT TO anon USING (true);

CREATE POLICY "Anyone can insert row"
  ON public.leaderboard FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "Anyone can update row"
  ON public.leaderboard FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- PVP rooms (Multiplayer)
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

CREATE POLICY "Anyone can read rooms"
  ON public.rooms FOR SELECT TO anon USING (true);

CREATE POLICY "Anyone can create room"
  ON public.rooms FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "Anyone can update room"
  ON public.rooms FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- Optional: index for leaderboard sort
CREATE INDEX IF NOT EXISTS idx_leaderboard_tokens ON public.leaderboard (tokens DESC);
CREATE INDEX IF NOT EXISTS idx_rooms_status ON public.rooms (status);
