# PRD: Game Cleanup, Gameplay & Feature Parity

**Purpose:** Single product spec to resolve bugs, improve fun and clarity, align economy (tokens for PVP, $CARD → tokens), and add friend-request flow, rematch window, UI (bottom nav left), and PVP/feather animations.

**Audience:** Product + Engineering. Implementation order can follow sections 1 → 2 → 3 → 4.

---

## 1. Bug Fixes & Cleanup

### 1.1 Resolved / to fix
- **Bounty claim persistence:** Ensure `save()` runs after every successful bounty claim (already in place; verify on all claim paths).
- **Notifications:** Bell opens notification center; ensure bounty claims and PVP results push entries. Add “Friend request received” when applicable (see §4).
- **Supabase fallback:** When `window.supabaseClient` is null, show a short “Leaderboard / Friends unavailable” instead of endless “Loading…” on PVP wins and Friends lists.
- **Invite / add-by-code:** Invite link and “add by code” flows already persist ref and register referral; keep behavior, add friend-request accept on top (§4).
- **Room list:** Only show open + in_progress + recent finished (e.g. 30 min). Stale open rooms auto-closed (e.g. 5 min). In-progress rooms past `game_ends_at` marked finished. No delete of rows; only status + filtering.

### 1.2 Technical debt
- Remove or repurpose dead code (e.g. `loadPvpFullList`, unused `click-count-label` references) to avoid confusion.
- Ensure all PVP and Friends actions that mutate state call the appropriate reload (e.g. `loadPvpRooms`, `loadFriendsInvited`, `loadFriendsAddedByCode`).

### 1.3 Testing
- Use existing PRD-BUGS-AND-PLAYABILITY.md testing checklist; add: PVP full flow (create → share → join → play → result → rematch or close), Friends (invite + add by code + token count), Settings toggles (feather, future sound/haptics).

---

## 2. Economy & Clarity

### 2.1 PVP costs tokens (not $CARD)
- **Rule:** Joining or creating a PVP room **costs in-game tokens** (the wager/stake). No $CARD is spent to play PVP.
- **Current behavior:** Stake is in “in-game tokens”; ensure all copy and validation use “tokens” (e.g. “You need at least X tokens to create/join”).
- **Clarity:** In Multiplayer / CREATE ROOM and room cards, show: “Wager: X tokens” and “You have Y tokens.” No mention of $CARD for playing the duel.

### 2.2 $CARD → tokens exchange
- **Rate:** 1 $CARD = 10 in-game tokens (already in Wallet swap area).
- **Copy:** Keep “Rate: 1 $CARD = 10 in-game tokens” and “Exchange on-chain $CARD for in-game tokens to play.” Optional: add “Use tokens for Boosts and PVP wagers.”

### 2.3 Boosts & badges
- **Boosts:** Tap Power, Autoclicker, Cooldown remain token-purchased. Balance and “Your balance: X tokens” on Boosts page must stay in sync with Home/Wallet.
- **Badges:**  
  - **Implemented:** First Click (1), 1K Clicks, 10K Clicks.  
  - **To implement or clarify:** 7-Day Streak, 30-Day Streak (logic + persistence).  
  - **UX:** Unlocked badges full opacity; locked badges 50% opacity. Optional: “Next: 7-day streak” or “Next: 1K clicks” on Home or Boosts.
- **Persistence:** All boost and badge state in localStorage; `save()` on purchase and on relevant claim/streak updates.

---

## 3. UI & Layout

### 3.1 Bottom navigation: left-aligned
- **Change:** Bottom menu items (HOME, BOOSTS, BOUNTIES, FRIENDS, WALLET) are **left-aligned** instead of centered.
- **Implementation:** Replace `justify-content: center` with `justify-content: flex-start` (or equivalent) on `.bottom-nav-inner`. Keep horizontal scroll and spacing so all items remain visible on small screens.
- **Note:** Comment in HTML says “centered”; update to “left-aligned” after change.

### 3.2 Settings = gameplay features
- **Location:** All gameplay and preference options live under **Wallet → SETTINGS** (single place).
- **Current:** Display name, Feather effects (On/Off).
- **Add (optional in this PRD):** Sound On/Off, Haptics On/Off (mobile), Reduced motion (shorten or disable feather animation). Each stored in localStorage and read on load.

---

## 4. Friends: Request & Accept

### 4.1 Friend request flow
- **Sender:** User A can “Send friend request” to User B (e.g. by entering B’s invite code or from a “Add friend” action that resolves B’s identity).
- **Storage:** New table or use existing: e.g. `friend_requests(from_wallet, to_ref_code_or_wallet, status: pending|accepted|rejected, created_at)`. Or `friend_requests(from_wallet, to_wallet, status, created_at)` if we resolve code → wallet when sending.
- **Receiver:** User B gets a **notification**: “Friend request from [name].” Shown in notification center (bell) and optionally as in-app toast/banner.

### 4.2 Accept / reject
- **Receiver:** In Friends or Notifications, “Accept” or “Reject” the request.
- **On Accept:**  
  - Insert into “friends” list (e.g. `friends_by_code` or a unified “friends” table: both A and B see each other).  
  - Optional: notify A “[B name] accepted your friend request.”
- **On Reject:** Mark request rejected; no friend row. Optional: do not notify sender to reduce noise.

### 4.3 Backward compatibility
- **Invite link:** Keep existing behavior: open link with `?ref=CODE` stores ref; on name save, referral is registered; inviter sees invited in “FRIENDS (INVITED).”  
- **Add by code:** Keep “Add by invite code” as one way to *send* a friend request (if we move to request/accept) or keep as “add and show in my list” with optional “they see me only after accept” depending on product choice. PRD recommends: “Add by code” = send friend request; receiver sees request and can Accept/Reject; only after Accept do both see each other in a unified friends list.

### 4.4 Notifications
- **Friend request received:** Push to notification center: “Friend request from [name].” Link or button to Friends where they can Accept/Reject.
- **Friend request accepted (optional):** “[Name] accepted your friend request.”

---

## 5. PVP: Rematch Window & Room Lifecycle

### 5.1 60-second rematch window
- **When:** After a duel ends (status = `finished`), the room stays **joinable for rematch** for **60 seconds**.
- **UI:** On duel result screen, show: “REMATCH (60s)” or “Rematch available for 60s” and countdown (e.g. “45s left”). Both players can click REMATCH within that window.
- **Behavior:**  
  - If **both** players (or same two wallets) “Rematch” within 60s: reuse same room id; reset clicks, set status back to `in_progress`, set new `game_started_at` / `game_ends_at`, and start the duel again (no new wager; or optionally same wager deducted again—clarify in copy).  
  - If **no rematch** within 60s: mark room as closed (e.g. status stays `finished` and room is excluded from “open” list and hidden from lobby after window).

### 5.2 Room disappears when no rematch
- **Lobby list:** Rooms that are `finished` and past the 60s rematch window are **not** shown in the lobby (already filtered by “recent finished” e.g. 30 min; can tighten to “finished and older than 60s” for rematch rooms).
- **Copy:** “If no rematch in 60s, this room will close.” So players understand the room will disappear from the list.

### 5.3 Stakes for rematch
- **Option A:** Rematch uses the **same stake**; no extra token deduction (already paid).  
- **Option B:** Rematch requires **agreeing to same stake again** (each “pays” again).  
- **Recommendation:** Option A for simplicity; document in PRD and in-app: “Rematch: same stake, no extra cost.”

---

## 6. Animations & Feel

### 6.1 Feathers in main game
- **Current:** Feathers fall on tap when “Feather effects” is On in Settings. Animation and cleanup (remove node after ~1.5s) already in place.
- **Ensure:** Feathers only show when setting is On; no leaks (nodes removed); performance acceptable on low-end devices (cap concurrent feathers if needed).

### 6.2 PVP duel animations
- **During duel:**  
  - **Tap feedback:** When the local player taps, show a small visual feedback (e.g. brief scale/pulse on the clicker button, or a “+1” float near their score).  
  - **Feathers in PVP (optional):** If “Feather effects” is On, allow falling feathers during PVP taps in the duel view (reuse same feather asset and animation, scoped to the duel panel).  
- **Countdown:** “3, 2, 1, GO!” already present; optional: subtle scale or glow on “GO!” for emphasis.  
- **Result screen:** Optional: short “win” or “lose” animation (e.g. confetti for winner, or a simple scale-in on the result card).

### 6.3 Accessibility
- **Reduced motion:** If “Reduced motion” is added in Settings, disable or shorten feather animation and any non-essential PVP animations; keep countdown and result text.

---

## 7. Gameplay Fun & Clarity (Summary)

- **Goals:** Clear progression (taps → tokens → boosts → bounties → PVP). Bounties give short- and long-term targets; badges and streaks give identity and bragging rights.
- **Feedback:** Tokens and TAP/SEC update immediately; feathers (if on) and “+1” on tap; notifications for claims and friend requests; PVP result and rematch countdown clear.
- **Economy:** One currency for “playing”: in-game tokens (earned by taps + bounties + swap from $CARD). $CARD used only for swap → tokens. PVP wagers are tokens only.
- **Social:** Invite link + add by code; friend request + accept/reject; notifications when someone sends a request; after accept, both see each other in friends list with token count and Duel/Remove.

---

## 8. Implementation Checklist (High Level)

| # | Item | Notes |
|---|------|--------|
| 1 | Bottom nav left-aligned | CSS: `.bottom-nav-inner` justify-content |
| 2 | Supabase fallback message | When client null, show “Unavailable” on Friends/PVP lists |
| 3 | PVP copy: tokens only | All “need X to play” = tokens; no $CARD for playing |
| 4 | 1 $CARD = 10 tokens | Already in Wallet; reinforce in copy |
| 5 | Badges: 7-day / 30-day streak | Logic + persistence + badge unlock |
| 6 | Settings: Sound, Haptics, Reduced motion | Optional; localStorage + read on load |
| 7 | Friend request table + send/accept/reject | New flow; notifications “Friend request from X” |
| 8 | Notifications: friend request received | Push to notification center + optional toast |
| 9 | Rematch: 60s window, same room | Timer; both rematch → reset room and start again |
| 10 | Room hide after 60s if no rematch | Filter lobby so finished rooms past 60s not shown |
| 11 | PVP tap feedback + optional feathers in duel | Small animation on tap; feathers in duel if setting On |
| 12 | Rematch stake: same stake, no extra cost | Document and implement (no second deduction) |

---

## 9. References

- **PRD-BUGS-AND-PLAYABILITY.md** – Bugs, playability, testing checklist.  
- **PRD-INVITE-FUNCTIONALITY.md** – Invite link and add-by-code.  
- **PRD-PVP-COUNTDOWN-TOKEN-WAGERS.md** – PVP stakes and countdown.  
- **PRD-INVITE-PLAYER-LOOP-AND-FRIENDS-PAGE.md** – Friends page and duel from list.  
- **Economy:** In-game tokens from taps (10 clicks = 1 token), bounties, and swap ($CARD → 10 tokens). PVP wager = tokens only.
