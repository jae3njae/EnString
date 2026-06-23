-- ───────────────────────────────────────────────────────────────────────
--  Enstring — database setup
--  Run this once in Supabase:  SQL Editor → New query → paste → Run.
--  It creates one table that stores each user's whole board as JSON,
--  and locks it down so a person can only ever touch their own row.
-- ───────────────────────────────────────────────────────────────────────

-- One row per user. The board (notes, pages, images, frames, connections,
-- nested boards, and view position) is kept in the `data` column as JSON.
create table if not exists public.boards (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Turn on Row Level Security. With RLS on and the policies below, the public
-- anon key cannot read or write anyone's data without a matching logged-in user.
alter table public.boards enable row level security;

-- A user may read only their own board.
create policy "read own board"
  on public.boards for select
  using (auth.uid() = user_id);

-- A user may create only their own board row.
create policy "create own board"
  on public.boards for insert
  with check (auth.uid() = user_id);

-- A user may update only their own board.
create policy "update own board"
  on public.boards for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- A user may delete only their own board.
create policy "delete own board"
  on public.boards for delete
  using (auth.uid() = user_id);