-- 022: Add message column to token_sends (Venmo-style notes on token transfers)
-- Run in Supabase SQL Editor.

ALTER TABLE public.token_sends ADD COLUMN IF NOT EXISTS message TEXT;

-- Also add message column to token_received_notifications if it exists
DO $$ BEGIN
  ALTER TABLE public.token_received_notifications ADD COLUMN IF NOT EXISTS message TEXT;
EXCEPTION WHEN undefined_table THEN NULL;
END $$;
