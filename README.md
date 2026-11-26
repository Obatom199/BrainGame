# BrainGame

Live multiplayer brain games for a room of people. The host picks a game, everyone plays on their phones at the same time, and the projector shows a live leaderboard and a podium for the winners.

## Games

Schulte Table, Reverse Schulte, Memory Grid, Stroop Test, Math Sprint, Odd One Out, Number Sequence, Word Unscramble (Everyday words, Bible characters, Nigerian leaders) and Reaction Time.

## How to run a session

- Host: open the site with `?host=1` on the projector laptop and click Create game room.
- Players: scan the QR code, pick an avatar, enter a name and tap "I'm ready".
- Host: pick a game (and a word category if needed) and press Start.
- After the podium, choose Play again or Back to games.

## Notes

- Backend is Supabase (tables prefixed `st_`, see `schema.sql`).
- `schulte-classic.html` is the original single-game version.
- Add `?demo=1` to test without Supabase (works across tabs of one browser only).
- Add `&dur=10` to the host link to shorten rounds while testing.
