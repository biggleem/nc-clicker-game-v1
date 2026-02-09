-- Add token stake and game timing to rooms (for PVP wagers and countdown)
-- Run in Supabase SQL Editor if your rooms table doesn't have these yet.

ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS stake_amount INTEGER DEFAULT 5;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player1_name TEXT;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player2_name TEXT;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player1_clicks INTEGER DEFAULT 0;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player2_clicks INTEGER DEFAULT 0;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS game_started_at TIMESTAMPTZ;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS game_ends_at TIMESTAMPTZ;
