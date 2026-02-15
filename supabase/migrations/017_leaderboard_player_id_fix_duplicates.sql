-- 017: leaderboard.player_id (with duplicate fix)
-- Copy this entire file into Supabase → SQL Editor → New query → Run

-- Add column if not present
ALTER TABLE public.leaderboard ADD COLUMN IF NOT EXISTS player_id TEXT;

-- Backfill: existing rows get player_id = wallet_address
UPDATE public.leaderboard SET player_id = wallet_address WHERE wallet_address IS NOT NULL AND (player_id IS NULL OR player_id = '');

-- Fix duplicates: keep one row per player_id (smallest id), clear player_id on the rest
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

-- Drop index if it exists from a previous failed run
DROP INDEX IF EXISTS public.idx_leaderboard_player_id;

-- Create unique index
CREATE UNIQUE INDEX idx_leaderboard_player_id
ON public.leaderboard (player_id)
WHERE player_id IS NOT NULL AND player_id != '';

COMMENT ON COLUMN public.leaderboard.player_id IS 'Unique player id: wallet_address when connected, or guest_xxx for anonymous.';
