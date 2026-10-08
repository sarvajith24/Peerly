-- Run once in Supabase: SQL Editor -> New query -> paste -> Run
create table if not exists messages (
  id bigint generated always as identity primary key,
  k text unique, room text not null, uid text not null,
  name text, text text not null, created_at timestamptz default now());
create index if not exists messages_room_idx on messages(room, created_at);

create table if not exists listings (
  id bigint generated always as identity primary key,
  k text unique, kind text, name text, price text, cat text,
  descr text, meta text, owner text, created_at timestamptz default now());

alter table messages enable row level security;
alter table listings enable row level security;
create policy "read messages"  on messages for select using (true);
create policy "write messages" on messages for insert with check (true);
create policy "read listings"  on listings for select using (true);
create policy "write listings" on listings for insert with check (true);

-- turn on realtime for both tables
alter publication supabase_realtime add table messages, listings;
-- NOTE: policies are open for the hackathon demo. For production add Supabase Auth
-- and restrict inserts to auth.uid() and DM reads to room members.
