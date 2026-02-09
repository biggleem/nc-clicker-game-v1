# PRD: PVP Countdown, Token Stakes & Wager Rooms

**Purpose:** Add a countdown before the duel starts, switch from $CARD to in-game tokens (default 5), support multiple stake levels (2, 5, 7, 10, custom), and allow players to agree on custom wagers before play.

---

## 1. Goals

1. **Countdown before game starts:** 3–2–1–GO so both players are ready; then the 30s click race starts.
2. **Token-based stakes:** Use in-game tokens instead of $CARD. Default stake 5 tokens; loser loses stake, winner receives it (transfer between players in-game).
3. **Different room types / wagers:** Preset stakes (2, 5, 7, 10 tokens) and Custom. Players see the wager before joining; for custom, creator sets amount and joiner agrees by joining.
4. **Agreement on wager:** For presets, the room shows the stake clearly; for custom, creator proposes an amount and joiner accepts by clicking Join (or can decline). No complex negotiation—just “join = accept this room’s stake.”

---

## 2. Requirements

### 2.1 Countdown (3–2–1–GO)

| # | Requirement | Notes |
|---|-------------|--------|
| R1 | When both players are in the duel view (room status in_progress, game_ends_at set), show a countdown: 3 … 2 … 1 … GO (each number visible for ~1 second). | Client-side animation; sync using server game_ends_at. |
| R2 | During countdown, the tap-to-score button is disabled. When GO appears (or 1 second after), enable the button and start the 30s race timer. | So no one gets a head start. |
| R3 | Server: set game_ends_at = (now + countdown_sec + 30) when player2 joins. E.g. countdown_sec = 4, so race ends 34s after join. Client: for first 4s show countdown; for remaining 30s show race timer and allow taps. | Keeps both clients in sync. |
| R4 | Play vs Computer: same countdown (3–2–1–GO) then 30s race. | Consistent UX. |

### 2.2 Tokens Instead of $CARD

| # | Requirement | Notes |
|---|-------------|--------|
| R5 | Stake is in **in-game tokens** (same as Boosts/Bounties balance). Default entry stake **5 tokens**. | No wallet/$CARD required for PVP stake. |
| R6 | To create or join a room, player must have in-game token balance ≥ room’s stake. | Check localStorage/state token balance. |
| R7 | **Loser:** deduct stake from their in-game tokens. **Winner:** add stake to their in-game tokens (winner receives loser’s stake). | Persist and update UI (save(), updateUI()). |
| R8 | Draw: no token transfer. | |
| R9 | Remove all PVP copy that says “1 $CARD” or “connect wallet for stake”; replace with “X tokens” and “in-game balance”. Wallet no longer required for PVP stake (optional for identity/leaderboard). | UX and copy only. |

### 2.3 Room Types / Wager Levels

| # | Requirement | Notes |
|---|-------------|--------|
| R10 | When creating a room, player chooses stake: **2**, **5**, **7**, **10** tokens, or **Custom**. | Preset buttons + Custom option. |
| R11 | **Custom:** Creator enters a number (min 1, max e.g. 999). Room is created with that stake. Joiner sees “Stake: X tokens” and joins only if they accept (and have balance ≥ X). | One-way proposal: creator sets, joiner accepts by joining. |
| R12 | Room list and room card show stake clearly: “2 tokens”, “5 tokens”, “7 tokens”, “10 tokens”, or “X tokens” (custom). | So players know what they’re agreeing to. |
| R13 | Backend: store `stake_tokens` (or keep `stake_amount` as tokens) on the room. No new tables; existing `rooms` already has stake_amount. | Use same column as token amount. |

### 2.4 Agreement on Wager

| # | Requirement | Notes |
|---|-------------|--------|
| R14 | **Preset rooms:** Joiner sees stake on the room card; clicking Join = accept that wager. No extra confirmation step if we show the stake clearly. | Optional: “Join (stake: 5 tokens)” on button. |
| R15 | **Custom rooms:** Creator sets custom amount; room displays “Stake: X tokens”. Joiner must have balance ≥ X; Join = accept. Optional: short line “You will wager X tokens. Join to accept.” | Agreement = join action. |
| R16 | No back-and-forth negotiation in v1 (e.g. joiner proposing a different amount). Single proposal (room’s stake) and accept (join). | Keeps scope small. |

---

## 3. Out of Scope

- On-chain or server-held escrow; tokens are in-game only and transferred client-side (loser deduct, winner add) with save().
- Changing game duration (30s) or click cooldown.
- Wallet requirement for PVP (wallet can remain optional for display name / leaderboard).

---

## 4. Acceptance Criteria

- [ ] Countdown 3–2–1–GO appears before the 30s race; tap button disabled during countdown.
- [ ] PVP stake is in-game tokens; default 5 tokens; loser loses stake, winner gains it; balance and UI update.
- [ ] Create room: choose stake 2 / 5 / 7 / 10 or Custom (number input). Room shows stake in list and on card.
- [ ] Join: only if balance ≥ room stake; Join = accept wager. Custom rooms show “Stake: X tokens”.
- [ ] Copy and UI no longer say “1 $CARD” for PVP; say “X tokens” and “in-game balance”.
- [ ] Play vs Computer unchanged (no stake); countdown still shown before vs computer race.

---

## 5. Test Plan (Summary)

- **Countdown:** Enter duel (or vs computer), verify 3–2–1–GO, then timer and taps.
- **Tokens:** Create room (5 tokens), join with enough balance, play; loser balance decreases by 5, winner increases by 5.
- **Preset stakes:** Create rooms with 2, 5, 7, 10; list shows correct stake; join with sufficient balance.
- **Custom:** Create room with custom amount; joiner sees stake and can join if balance ≥ amount.
- **Insufficient balance:** Cannot create/join if tokens < stake; clear message.

See `scripts/PRD-PVP-WAGER-TESTS.md` for detailed test cases.

---

## 6. References

- In-game tokens: `tokens` in state, `localStorage.getItem('tokenClicker_tokens')`, `save()`, `updateUI()`.
- Rooms: `rooms` table, `stake_amount` (repurposed as token stake).
- Duel start: `doJoinPvpRoom` sets `game_ends_at`; `enterDuel` and `startDuelTimer`; click handler and `endDuelGame` / `showDuelResult`.
