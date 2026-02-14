-- PVP wins count on leaderboard (required for wins to be saved after duels).
-- Run in Supabase SQL Editor (Dashboard → SQL Editor → New query → paste → Run).

ALTER TABLE public.leaderboard ADD COLUMN IF NOT EXISTS pvp_wins INTEGER DEFAULT 0;
