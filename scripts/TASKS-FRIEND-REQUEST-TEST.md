# Tasks: Test both sides of friend request (with code references)

Use two browsers or one normal + one incognito (different users). Run app via `npm run serve` then open http://localhost:3001 (and http://localhost:3001 in incognito for the second user).

---

## SENDER SIDE (Add friend by invite code)

### Task S1: Set display name and ensure ref code exists
- [ ] Open app, complete or skip onboarding.
- [ ] Set display name: welcome modal **Your name** input → **SAVE**, or go to **Wallet** → **Settings** → change name → **SAVE**.
- [ ] Go to **FRIENDS** tab. Verify **Your code:** shows a code (e.g. `REF9YB68M`).
- **Code refs:** `#referral-code` (your code text), `persistNameToLeaderboard()` syncs name + ref to leaderboard.

### Task S2: Enter invalid code – see error
- [ ] In **FRIENDS**, in **ADD FRIEND BY INVITE CODE**:
  - **Input:** `#friend-code-input`
  - **Button:** `#friend-code-add-btn`
- [ ] Enter `INVALID99`, click **ADD FRIEND**.
- [ ] **Pass:** `#friend-code-feedback` shows yellow message: "Unknown invite code. Your friend should open the app...".
- **Code:** `addFriendByCode()`, leaderboard `.ilike('ref_code', code).limit(1)` returns no row.

### Task S3: Enter own code – see error
- [ ] Copy **Your code** from the page (e.g. `REF9YB68M`). Put it in `#friend-code-input`, click **ADD FRIEND**.
- [ ] **Pass:** `#friend-code-feedback` shows "You can't add yourself.".
- **Code:** `myRef && code === myRef.toUpperCase()` in `addFriendByCode()`.

### Task S4: Send request to another user (receiver's code)
- [ ] **Receiver:** In second browser/incognito, open app, set a different name, go to FRIENDS, note **Your code** (e.g. `REF7T8R13`).
- [ ] **Sender:** In first browser, FRIENDS → `#friend-code-input` = receiver's code (e.g. `REF7T8R13`) → click **ADD FRIEND**.
- [ ] **Pass:** `#friend-code-feedback` shows green "Request sent to [ReceiverName]." and `#friend-code-input` is cleared.
- **Code:** `friend_requests` insert `{ from_wallet: me, to_wallet: toWallet, from_name, to_name, status: 'pending' }`.

### Task S5: Send again same code – see "Request already sent"
- [ ] Same sender, same receiver code, click **ADD FRIEND** again.
- [ ] **Pass:** `#friend-code-feedback` shows "Request already sent." (unique on `(from_wallet, to_wallet)` in DB).
- **Code:** `ins.error.code === '23505'` in `addFriendByCode()`.

---

## RECEIVER SIDE (See request, Accept, Reject)

### Task R1: Pending request is visible
- [ ] After S4, in **receiver** browser go to **FRIENDS**.
- [ ] **Pass:** Section **Pending requests** is visible (`#friend-requests-section` not hidden), `#friend-requests-list` contains one item with sender name and **ACCEPT** / **REJECT** buttons.
- **Code:** `loadFriendRequests()` queries `friend_requests` with `to_wallet = me`, `status = 'pending'`; renders `.friend-request-accept` and `.friend-request-reject` with `data-id`, `data-from-wallet`, `data-from-name`.

### Task R2: Accept request – success
- [ ] Receiver: click **ACCEPT** on the pending request.
- [ ] **Pass:** Notification "You are now friends with [SenderName]"; pending request disappears; **Added by code** list shows sender.
- **Code:** `acceptFriendRequest(reqId, fromWallet, fromName)` → leaderboard ref_code lookup (trimmed wallets, receiver fallback from `localStorage` `tokenClicker_refCode`) → `friends_by_code` insert both directions → `friend_requests` update `status: 'accepted'`.

### Task R3: Accept – clear error when sender ref missing
- [ ] (Optional) Use DB or a test where sender has no `ref_code` in leaderboard. Receiver clicks **ACCEPT**.
- [ ] **Pass:** Notification e.g. "Could not accept: [Sender]'s invite code not synced. Ask them to save their name in Wallet → Settings."
- **Code:** `showAcceptError()` when `!fromRef` after leaderboard lookup.

### Task R4: Reject request
- [ ] Send a new request (sender adds receiver again after receiver rejects or use another pair). Receiver clicks **REJECT**.
- [ ] **Pass:** Notification "Request rejected."; request disappears from **Pending requests**.
- **Code:** `rejectFriendRequest(reqId)` → `friend_requests` update `status: 'rejected'` → `loadFriendRequests()`.

---

## Console helpers (run in browser DevTools on app page)

```js
// Sender: get your ref code and friend-code input state
(function() {
  var ref = document.getElementById('referral-code');
  var input = document.getElementById('friend-code-input');
  var feedback = document.getElementById('friend-code-feedback');
  return {
    yourCode: ref ? ref.textContent : null,
    inputValue: input ? input.value : null,
    feedbackText: feedback ? feedback.textContent : null,
    feedbackVisible: feedback ? !feedback.classList.contains('hidden') : null
  };
})();

// Receiver: check if pending requests section and list are visible and count
(function() {
  var sect = document.getElementById('friend-requests-section');
  var list = document.getElementById('friend-requests-list');
  var items = list ? list.querySelectorAll('.friend-request-accept') : [];
  return {
    sectionHidden: sect ? sect.classList.contains('hidden') : null,
    acceptButtonCount: items.length,
    requestIds: Array.from(items).map(function(b) { return b.getAttribute('data-id'); })
  };
})();
```

---

## Checklist summary

| # | Side    | Action                    | Pass condition |
|---|---------|---------------------------|----------------|
| S1| Sender  | Set name, see ref code    | Your code visible on FRIENDS |
| S2| Sender  | Invalid code              | "Unknown invite code" |
| S3| Sender  | Own code                  | "You can't add yourself." |
| S4| Sender  | Valid receiver code       | "Request sent to [Name]." |
| S5| Sender  | Same code again           | "Request already sent." |
| R1| Receiver| Open FRIENDS              | Pending request with ACCEPT/REJECT |
| R2| Receiver| Click ACCEPT              | "You are now friends", in Added by code |
| R3| Receiver| Accept (no sender ref)    | Clear error notification |
| R4| Receiver| Click REJECT              | "Request rejected.", request gone |
