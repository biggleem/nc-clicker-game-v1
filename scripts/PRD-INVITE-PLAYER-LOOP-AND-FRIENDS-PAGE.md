# PRD: Invite Player Loop, Accept Notification & Duel from Friends

**Purpose:** Define and test the full invite flow so users can invite players, the inviter is notified when an invite is accepted, and both can duel directly from the friend list. Reorder the Friends page so Top Clickers (list) appears above PVP Duel Wins. Optimize for in-browser experience.

---

## 1. Current State

### Invite flow
- **Inviter:** Friends page → COPY INVITE LINK (URL includes `?ref=REFCODE`). User shares the link (messaging, etc.).
- **Invited player:** Opens link → game loads with `tokenClicker_invitedBy` = ref code. When they set a display name (welcome or Wallet → Settings), `registerReferralIfNeeded()` runs → row inserted into `referrals` (inviter_ref_code, invited_name, invited_wallet). No explicit “accept” step; opening the link and setting a name counts as accepting.
- **Inviter:** Sees the new friend in FRIENDS (INVITED) only after they refresh or revisit the Friends page (no real-time “X accepted your invite” notification).

### Friends page order (current)
1. PVP DUEL WINS (TOP 5) — list  
2. FRIENDS (INVITED) — list (no Duel button today in implementation)  
3. TOP CLICKERS (by tokens) — list  
4. COPY INVITE LINK + Your code  

### Gaps
- No **Duel** button next to each friend in FRIENDS (INVITED).  
- Inviter does **not** get a clear notification when someone accepts the invite (friend just appears in the list on next load).  
- Invited player does not see a clear “You were invited by [Name]” state when opening via link (ref is stored but UX can be clearer).  
- Top Clickers is below PVP Duel Wins; product ask is **Top Clickers first**, then Duel Wins.

---

## 2. Goals

1. **Invite loop testable:** User can invite others; invited player “accepts” by opening the link and setting a name; inviter can see accepted friends and duel them from the list.  
2. **Accept notification:** When an invited player accepts (registers as referral), the **inviter** gets a notification that “[Name] accepted your invite” — best effort in the browser (in-app and/or Browser Notifications API).  
3. **Duel from friend list:** Each row in FRIENDS (INVITED) has a **Duel** button; clicking it creates a room and lets the inviter send the room link to that friend; when the friend joins, both duel.  
4. **Friends page order:** **TOP CLICKERS** (list form) **above** PVP DUEL WINS (list form), then FRIENDS (INVITED) with Duel, then invite CTA.

---

## 3. Best Approach from the Browser

### 3.1 Constraints (browser-only, no native app)
- **No push when tab is closed** unless we add Web Push (service worker + backend). So “notification” is best effort: when the user has the app open (or returns to it).  
- **Real-time options:** (a) Poll Friends/referrals when Friends page is visible; (b) Supabase Realtime on `referrals` so new rows trigger “X accepted your invite” in the open tab; (c) On next navigation to Friends, show a one-time banner/toast “X accepted your invite” if we detect new referrals since last visit.  
- **Browser Notifications API:** If the user grants permission, we can show a system notification (“X accepted your invite”) when the app is in the background and we learn of a new referral (e.g. via Realtime or poll).  
- **Invited player:** When they land with `?ref=`, show a clear in-app line: “You were invited by [InviterName]” (we may not have inviter name until we store it; optional: store inviter_name in referral when they accept, or show “You were invited! Enter your name to join.”).

### 3.2 Recommended approach (phased)

| Phase | What | How (browser) |
|-------|------|----------------|
| **A** | Inviter sees new friends | Already works: load FRIENDS (INVITED) from `referrals` when Friends page is shown. Optional: poll or Supabase Realtime on `referrals` when on Friends tab so list updates without refresh. |
| **B** | “X accepted your invite” notification | **In-app:** When we load/reload Friends and detect new referrals (e.g. since last seen count or last fetch), show a toast/banner: “[Name] accepted your invite.” **Optional:** Supabase Realtime on `referrals` for inviter’s ref_code → when new row, show toast + optionally Browser Notifications if permitted. |
| **C** | Duel from list | Each friend row: add **Duel** button. On click: create PVP room (with chosen stake), copy room link, show “Challenge sent to [Name]. Share the room link with them.” Optionally open PVP tab and show the room. Friend opens link → JOIN → both in duel. |
| **D** | Invited player experience | On load with `ref` in URL: show short line “You were invited! Enter your name below to join.” (or “You were invited by a friend.” if we don’t have inviter name). Keeps current flow (name → registerReferralIfNeeded). |
| **E** | Friends page order | Move **TOP CLICKERS** block above **PVP DUEL WINS**. Both in list form (numbered list). Then FRIENDS (INVITED) with Duel buttons, then COPY INVITE LINK. |

---

## 4. Requirements

### 4.1 Invite flow (testable)

| ID | Requirement | Notes |
|----|-------------|--------|
| I1 | User can generate an invite link that includes their referral code (e.g. `?ref=REFCODE` or path). | Already: COPY INVITE LINK. |
| I2 | When another player opens that link, the game loads and stores the ref (e.g. `tokenClicker_invitedBy`). | Already. |
| I3 | When the invited player sets a display name (first time or in Settings), the game registers the referral (insert into `referrals`: inviter_ref_code, invited_name, invited_wallet). | Already: `registerReferralIfNeeded()`. |
| I4 | After registration, the invited player is considered to have “accepted” the invite; they appear in the inviter’s FRIENDS (INVITED) list. | Already on next load of Friends. |
| I5 | Inviter can open the Friends page and see the list of friends (who used their link). | Already: `loadFriendsInvited()`. |

### 4.2 Accept notification (inviter)

| ID | Requirement | Notes |
|----|-------------|--------|
| N1 | When an invited player accepts (new row in `referrals` for inviter’s code), the **inviter** sees a notification that “[Name] accepted your invite.” | In-app: toast or banner when Friends page loads and we detect new referrals. |
| N2 | Optional: If the inviter has granted browser notification permission, show a system notification when a new referral is detected and the tab is in the background. | Requires Supabase Realtime or poll + `new Notification(...)`. |
| N3 | “Detect new referrals” can be: (a) compare current referrals count to last stored count when we last left Friends; (b) Supabase Realtime on `referrals` filtered by inviter_ref_code. | Prefer (a) for v1; (b) for live updates. |

### 4.3 Duel from friend list

| ID | Requirement | Notes |
|----|-------------|--------|
| D1 | Each entry in FRIENDS (INVITED) shows: friend name, optional wallet/identifier, and a **Duel** button. | Same data as now; add button per row. |
| D2 | Clicking **Duel** creates a PVP room (with current stake selection or default), copies the room link, and shows a message: “Challenge sent to [FriendName]. Share the room link with them to start.” | Room created as player1; share link is the existing room URL. |
| D3 | Inviter can paste the link to the friend (any channel). When the friend opens the link, they see the option to JOIN; when they join, both enter the duel (countdown + race). | Existing join flow. |
| D4 | No separate “friend connection” or accept-duel step required: creating a room and sharing the link is the challenge; joining is the acceptance of that duel. | Keeps implementation simple. |

### 4.4 Friends page layout and order

| ID | Requirement | Notes |
|----|-------------|--------|
| F1 | **TOP CLICKERS (by tokens)** is the **first** block on the Friends page, in **list form** (e.g. numbered list: 1. Name — X tokens). | Move this block above PVP Duel Wins. |
| F2 | **PVP DUEL WINS (TOP 5)** is the **second** block, in **list form** (e.g. 1. Name — N wins). | Same content as now; order after Top Clickers. |
| F3 | **FRIENDS (INVITED)** is the third block, with a **Duel** button next to each friend. | Same data; add Duel and optional “Challenge sent” feedback. |
| F4 | **COPY INVITE LINK** and **Your code** remain at the bottom. | No change. |

### 4.5 Invited player experience (clarity)

| ID | Requirement | Notes |
|----|-------------|--------|
| P1 | When the app loads with a ref in the URL (or stored `tokenClicker_invitedBy`), show a short line: “You were invited! Enter your name to join.” (or similar) so the invited player understands the context. | Can appear near the welcome/name input or at top of Friends. |
| P2 | After they set their name and referral is registered, they can use the app normally and appear on the inviter’s friend list. | Already. |

---

## 5. Test Plan: Invite Player Loop & Duel from Friends

### 5.1 Invite and accept

| ID | Step | Expected |
|----|------|----------|
| T1 | As **Inviter:** Open Friends → COPY INVITE LINK. Paste link into a note (or second device). | Link contains ref code (e.g. `?ref=REFXXXX`). |
| T2 | As **Invited:** Open that link in a new incognito window (or second device). | Game loads; ref is stored; optional “You were invited!” message shown. |
| T3 | As **Invited:** Set display name (welcome modal or Wallet → Settings). | Referral is registered (row in `referrals`). |
| T4 | As **Inviter:** Refresh or re-open Friends page. | New friend appears in FRIENDS (INVITED) list. |
| T5 | Optional: As **Inviter:** Have Friends page open; as **Invited** completes T3. | Inviter sees in-app notification “[Name] accepted your invite” (if N1 implemented). |

### 5.2 Duel from friend list

| ID | Step | Expected |
|----|------|----------|
| T6 | As **Inviter:** On Friends page, see a friend in FRIENDS (INVITED). Click **Duel** next to that friend. | Room is created; room link is copied (or copy button shown); message “Challenge sent to [Name]. Share the room link with them.” |
| T7 | As **Inviter:** Paste the room link and send to the friend (or open in second device). | Link opens to game with room context (e.g. MULTIPLAYER with invited card or room in list). |
| T8 | As **Friend:** Open the room link. Click JOIN (or JOIN & PLAY). Have enough tokens for stake. | Join succeeds; both players enter duel view (countdown then race). |
| T9 | Complete the duel (timer or END GAME). | Winner/loser result; token transfer; winner on PVP leaderboard. |

### 5.3 Friends page order and list form

| ID | Step | Expected |
|----|------|----------|
| T10 | Open Friends page. | First section: **TOP CLICKERS (by tokens)** as a numbered list. |
| T11 | Scroll or look below Top Clickers. | Second section: **PVP DUEL WINS (TOP 5)** as a numbered list. |
| T12 | Below that. | Third section: **FRIENDS (INVITED)** with Duel button per row. |
| T13 | Bottom. | COPY INVITE LINK and Your code. |

### 5.4 Edge cases

| ID | Step | Expected |
|----|------|----------|
| T14 | Invited player opens link but never sets a name (or clears ref). | No referral row; they do not appear in inviter’s list. |
| T15 | Inviter clicks Duel for a friend; friend never opens the room link. | Room stays open until closed or timeout; inviter can close room or share link again. |

---

## 6. Acceptance Criteria (Summary)

- [ ] User can invite others via COPY INVITE LINK; invited player opens link and sets name → referral registered → friend appears in inviter’s FRIENDS (INVITED). (T1–T4)  
- [ ] When a new referral is detected, inviter sees an in-app notification “[Name] accepted your invite” (e.g. on next Friends load or via Realtime). (N1, T5)  
- [ ] Each friend in FRIENDS (INVITED) has a **Duel** button; clicking it creates a room and shows “Challenge sent to [Name]. Share the room link.” (D1–D2, T6–T7)  
- [ ] Friend can open room link and JOIN; both enter duel and can play to completion. (D3–D4, T8–T9)  
- [ ] Friends page order: **TOP CLICKERS** (list) → **PVP DUEL WINS** (list) → **FRIENDS (INVITED)** (with Duel) → COPY INVITE LINK. (F1–F4, T10–T13)  
- [ ] Invited player sees clear “You were invited!” (or similar) when landing with ref. (P1)

---

## 7. Implementation Notes

### 7.1 Friends page reorder (HTML)
- In `index.html`, move the **TOP CLICKERS** block (and `leaderboard-list`) **above** the **PVP DUEL WINS** block (and `leaderboard-pvp-list`). Keep both as `<ol>` list form.

### 7.2 Duel button in FRIENDS (INVITED)
- In `loadFriendsInvited()`, render each referral as a row that includes a **Duel** button (e.g. `<button class="... duel-friend-btn" data-name="..." data-wallet="...">Duel</button>`).  
- On Duel click: call the same flow as “Create room” (with default or selected stake), then copy room link to clipboard and show status: “Challenge sent to [Name]. Share the room link with them.” Optionally switch to MULTIPLAYER tab and show the created room.

### 7.3 Accept notification (inviter)
- **Simple v1:** On Friends page load, fetch current referrals count (or list). Compare to `sessionStorage`/`localStorage` last-known count. If count increased, show toast “X accepted your invite” for each new name (from new rows). Store current count for next time.  
- **Optional:** Supabase Realtime subscription on `referrals` where `inviter_ref_code = myRefCode`; on INSERT, show toast and optionally request Browser Notifications and show system notification.

### 7.4 Invited player copy
- When `localStorage.getItem('tokenClicker_invitedBy')` is set (or URL has `ref`), show a short line near the name input or at top of Friends: “You were invited! Enter your name to join.” (or “You were invited by a friend.”).

---

## 8. Out of Scope (for this PRD)

- Web Push for when the app tab is fully closed (would require service worker + backend).  
- Two-way friend graph (e.g. “friends list” as mutual; current model is one-way: inviter sees who used their link).  
- In-app chat or presence (e.g. “friend is online”).

---

## 9. References

- Current: `loadFriendsInvited()`, `registerReferralIfNeeded()`, invite btn and `referrals` table; `createPvpRoom()`, room link copy, MULTIPLAYER flow.  
- PRD-PVP-FRIENDS-AND-GAMEPLAY.md (Duel from Friends, Play vs Computer).  
- Supabase: `referrals` (inviter_ref_code, invited_name, invited_wallet), `rooms`, `leaderboard`.
