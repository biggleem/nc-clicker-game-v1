# PVP Countdown & Token Wager – Test Plan

**Purpose:** Test countdown before duel, token stakes (2/5/7/10/custom), and token transfer (loser pays winner).

---

## 1. Countdown

| ID | Step | Expected |
|----|------|----------|
| C1 | Start Play vs Computer (or join a PVP room). | Duel view shows; timer area shows "3" then "2" then "1" then "GO!". |
| C2 | During countdown, tap the click button. | Button is disabled; taps do not register. |
| C3 | After "GO!" (or 1s after "1"), tap the click button. | Button is enabled; taps register and your score increases. |
| C4 | Race timer runs 30s after countdown. | Display shows 0:30 down to 0:00; game ends at 0. |

---

## 2. Token stake – create room

| ID | Step | Expected |
|----|------|----------|
| T1 | Have &lt; 5 in-game tokens. Click CREATE ROOM (default 5). | Error: "You need at least 5 in-game tokens to create this room." |
| T2 | Have ≥ 5 tokens. Select stake 5, click CREATE ROOM. | Room created; room appears in list with "5 tokens". |
| T3 | Select stake 2, create room. | Room shows "2 tokens". |
| T4 | Select stake 10, create room (need ≥10 tokens). | Room shows "10 tokens". |
| T5 | Enter custom stake (e.g. 20), clear preset selection if needed, create room (need ≥20 tokens). | Room created with "20 tokens" in list. |

---

## 3. Token stake – join room

| ID | Step | Expected |
|----|------|----------|
| J1 | As second player, open room link. Room stake 5. Your balance 3. Click Join. | Error: "You need at least 5 in-game tokens to join... Your balance: 3." |
| J2 | Your balance ≥ 5. Join room (stake 5). | Join succeeds; both enter duel (after countdown). |
| J3 | Room card shows "Room xxx · 5 tokens" and JOIN. | Joiner sees wager before joining; Join = accept. |

---

## 4. Token transfer – winner / loser

| ID | Step | Expected |
|----|------|----------|
| W1 | Note your token balance. Win the duel (stake 5). | Balance increases by 5; result text: "You won 5 tokens." |
| W2 | Note your token balance. Lose the duel (stake 5). | Balance decreases by 5; result text: "You lost 5 tokens." |
| W3 | Draw (same clicks). | Result: "Tie! No token transfer."; balance unchanged. |

---

## 5. Stake selector UI

| ID | Step | Expected |
|----|------|----------|
| S1 | Click preset 2, 7, 10. | Selected button highlights (green); custom input cleared when preset clicked. |
| S2 | Enter number in custom, create room. | Room uses custom amount (if valid 1–999). |
| S3 | Create room with custom 0 or negative. | getPvpCreateStake falls back to preset or 5; or show validation. |

---

## 6. Play vs Computer

| ID | Step | Expected |
|----|------|----------|
| B1 | Play vs Computer. | Countdown 3–2–1–GO, then 30s race; no token stake; bot starts tapping after countdown. |
| B2 | Win vs computer. | "YOU WIN!"; no token change (practice). |

---

## 7. Checklist (manual)

- [ ] Countdown shows and tap disabled until GO (C1–C4).
- [ ] Create room: insufficient tokens blocked (T1); presets and custom (T2–T5).
- [ ] Join: insufficient tokens blocked (J1); join with enough tokens (J2–J3).
- [ ] Winner gets stake, loser loses stake (W1–W3).
- [ ] Stake selector and custom input (S1–S3).
- [ ] Play vs Computer unchanged, with countdown (B1–B2).

---

## 8. DB note

Rooms table must have `stake_amount` (integer) for token wager. If missing, add:

```sql
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS stake_amount INTEGER DEFAULT 5;
```
