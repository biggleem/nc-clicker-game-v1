-- Internal wallet: every player has a leaderboard row (by wallet or player_id for guests)
-- Enables token sharing for all players.

-- Add player_id: same as wallet_address when connected, or guest_xxx for anonymous
ALTER TABLE public.leaderboard ADD COLUMN IF NOT EXISTS player_id TEXT;

-- Backfill: existing rows get player_id = wallet_address
UPDATE public.leaderboard SET player_id = wallet_address WHERE wallet_address IS NOT NULL AND (player_id IS NULL OR player_id = '');

-- Uniqueness so one row per player (wallet or guest)
CREATE UNIQUE INDEX IF NOT EXISTS idx_leaderboard_player_id ON public.leaderboard (player_id) WHERE player_id IS NOT NULL AND player_id != '';

COMMENT ON COLUMN public.leaderboard.player_id IS 'Unique player id: wallet_address when connected, or guest_xxx for anonymous. Used for internal wallet and token sharing.';
