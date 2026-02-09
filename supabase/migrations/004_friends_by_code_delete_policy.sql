-- Allow delete so users can remove friends from their "added by code" list.
-- Run in Supabase SQL Editor.

CREATE POLICY "Anyone can delete friends_by_code"
  ON public.friends_by_code FOR DELETE TO anon USING (true);
