-- Rematch window: 60s after game ends to request rematch in same room.
-- Run in Supabase SQL Editor.

ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS rematch_until TIMESTAMPTZ;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player1_wants_rematch BOOLEAN DEFAULT false;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS player2_wants_rematch BOOLEAN DEFAULT false;
