-- Wager must be agreed by both players before game starts.
-- Run in Supabase SQL Editor (Dashboard → SQL Editor → New query → paste → Run).

ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player1_wager_agreed BOOLEAN DEFAULT false;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player2_wager_agreed BOOLEAN DEFAULT false;
