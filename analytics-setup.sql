-- Tour analytics event store — run this once in your Supabase project
-- (Dashboard → SQL Editor → New query → paste → Run).
--
-- Design notes:
--  * Append-only through the public anon key: inserts are allowed, updates and
--    deletes have no policy and are therefore denied. Reads are allowed so the
--    analytics.html dashboard can aggregate; events are anonymous (random
--    session ids, no PII), so read exposure is harmless.
--  * created_at is stamped server-side, so date reporting doesn't trust
--    visitors' clocks.
--  * Length/value checks keep junk submissions bounded.

create table if not exists public.tour_events (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  event       text not null check (event in ('tour_started','step_reached','tour_completed','tour_cancelled')),
  session_id  text not null check (char_length(session_id) between 1 and 64),
  tour_id     text check (tour_id is null or char_length(tour_id) <= 40),
  step        int  check (step is null or (step >= 0 and step <= 99)),
  duration_s  int  check (duration_s is null or (duration_s >= 0 and duration_s <= 604800))
);

alter table public.tour_events enable row level security;

create policy "anon can insert events"
  on public.tour_events for insert to anon
  with check (true);

create policy "anon can read events"
  on public.tour_events for select to anon
  using (true);

-- No update/delete policies on purpose: the public key cannot modify history.

create index if not exists tour_events_created_at_idx on public.tour_events (created_at);
create index if not exists tour_events_tour_idx on public.tour_events (tour_id, event);
