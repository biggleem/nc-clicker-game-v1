-- 021: Token sends (wallet transactions: record when a player sends tokens to another)
-- Run in Supabase SQL Editor. Used to show "Recent sends" in Wallet → Send.

CREATE TABLE IF NOT EXISTS public.token_sends (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_player_id TEXT NOT NULL,
  recipient_player_id TEXT,
  recipient_label TEXT,
  amount INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.token_sends ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can insert token_sends" ON public.token_sends;
CREATE POLICY "Anyone can insert token_sends"
  ON public.token_sends FOR INSERT TO anon WITH CHECK (true);

DROP POLICY IF EXISTS "Anyone can read token_sends" ON public.token_sends;
CREATE POLICY "Anyone can read token_sends"
  ON public.token_sends FOR SELECT TO anon USING (true);

CREATE INDEX IF NOT EXISTS idx_token_sends_sender ON public.token_sends (sender_player_id);
CREATE INDEX IF NOT EXISTS idx_token_sends_created ON public.token_sends (created_at DESC);
