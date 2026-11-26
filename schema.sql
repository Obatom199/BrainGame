-- Reference only: this has already been applied to the "quiz game" Supabase project.
-- BrainGame tables are prefixed st_ to stay separate from the quiz tables.

create table if not exists st_rooms (
  code       text primary key,
  seed       int  not null,
  status     text not null default 'lobby',   -- lobby | playing | finished
  start_at   bigint,                          -- epoch ms, server clock
  duration   int  not null default 25,
  game       text not null default 'schulte',
  category   text,
  created_at timestamptz default now()
);

create table if not exists st_players (
  id          uuid primary key,
  room_code   text not null references st_rooms(code) on delete cascade,
  name        text not null,
  avatar      text not null default '🧠',
  ready       boolean not null default false,
  found       int  not null default 0,        -- score for the current game
  mistakes    int  not null default 0,
  finished_ms int,
  joined_at   timestamptz default now()
);

alter table st_rooms   enable row level security;
alter table st_players enable row level security;
create policy "st open rooms"   on st_rooms   for all using (true) with check (true);
create policy "st open players" on st_players for all using (true) with check (true);

create or replace function st_server_time() returns bigint
language sql stable set search_path = '' as $$ select (extract(epoch from clock_timestamp()) * 1000)::bigint $$;

alter table st_players replica identity full;
alter publication supabase_realtime add table st_rooms, st_players;
