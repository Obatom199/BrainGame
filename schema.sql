-- Run this once in Supabase: SQL Editor > New query > paste > Run.

create table if not exists st_rooms (
  code       text primary key,
  seed       int  not null,
  status     text not null default 'lobby',   -- lobby | playing | finished
  start_at   bigint,                          -- epoch ms, server clock
  duration   int  not null default 25,
  created_at timestamptz default now()
);

create table if not exists st_players (
  id          uuid primary key,
  room_code   text not null references st_rooms(code) on delete cascade,
  name        text not null,
  found       int  not null default 0,
  mistakes    int  not null default 0,
  finished_ms int,
  joined_at   timestamptz default now()
);

alter table st_rooms   enable row level security;
alter table st_players enable row level security;
drop policy if exists "open st_rooms"   on st_rooms;
drop policy if exists "open st_players" on st_players;
create policy "open st_rooms"   on st_rooms   for all using (true) with check (true);
create policy "open st_players" on st_players for all using (true) with check (true);

-- Shared clock so every phone starts the round at the same moment.
create or replace function st_server_time() returns bigint
language sql stable as $$ select (extract(epoch from clock_timestamp()) * 1000)::bigint $$;

alter table st_players replica identity full;
alter publication supabase_realtime add table st_rooms, st_players;
