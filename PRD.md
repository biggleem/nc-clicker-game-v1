# Token Clicker — Product Requirements (Summary)

## Core concept

- **Token Clicker**: Click an NFT on the home page to accumulate “clicks.” Every **10 clicks = 1 in-game token**.
- **Anti-cheat**: Cooldown / detection so players can’t hold Enter or use scripts to spam clicks.

## Art & UI

- **Look**: Black, modern UI; 8-bit cartoon style; neon highlights on dark background; pixel-inspired icons/fonts.
- **NFT art**: Simple colored squares for main clicker and multiplayer duels (replace with real art later).

## Navigation

- **Top bar**: Token balance (left); Multiplayer + notification bell (right).
- **Bottom nav**: Home, Boosts, Bounties, Friends, Wallet, Multiplayer.

## Pages

| Page | Content |
|------|--------|
| **Home** | Centered NFT clicker; 3 metric windows (clicks/s, total clicks, token rate); click total bottom-right; 10 clicks → 1 token. |
| **Boosts** | Spend tokens on buffs (tokens per click, autoclicker, shorter cooldown). |
| **Bounties** | Daily rewards, weekly challenges, click milestones; claimable rewards. |
| **Friends** | Leaderboard (top clickers / token holders); invite / referral. |
| **Wallet** | Total balance; owned NFTs; **Exchange** tab to swap in-game token for supported token. |
| **Multiplayer** | Lobby of 2-person rooms; duel for staked NFTs; flow: Lobby → Room → Game → Results → Rematch/exit. |

## Backend (Supabase)

- **Users**: Profiles (username, email, wallet), auth (wallet or email/password).
- **Game data**: Clicks, tokens, bounties, daily rewards; NFT metadata / contract + token IDs.
- **Leaderboards**: High scores, updated in real time or on interval.
- **Multiplayer**: Room state (open / in-progress / finished); participants; match results (winner, NFT exchange).

## Frontend

- **Tailwind CSS**: Dark theme, neon accents, pixel-style elements; responsive; sticky top bar; bottom menu.

## NFT & token

- **On-chain**: ERC-20 for currency; ERC-721/1155 for NFTs.
- **Off-chain**: Supabase balances for speed; minted NFTs tracked on-chain.
- **Marketplace**: Basic NFT trading / token purchases (in Wallet or separate page).
- **Anti-fraud**: Rate-limit clicks; cooldown or stamina; server validation.

## Multiplayer duel

- **Lobby**: Active rooms, 2 slots each.
- **Room**: See staked NFT squares; confirm ready; start.
- **Game**: Short click race / mini-game; winner by valid clicks (anti-cheat).
- **Results**: Winner claims staked NFT; Supabase + on-chain transfer.
- **Rematch**: Optional same/new stakes.

## Roadmap

1. **Phase 1**: Basic clicker MVP (Home, NFT square, token accumulation). ✅
2. **Phase 2**: Boosts, Bounties, Friends (leaderboard, invites).
3. **Phase 3**: Wallet, Exchange, Supabase (users, game data).
4. **Phase 4**: Multiplayer (lobby, rooms, duels, results).
5. **Phase 5**: Marketplace, better NFT art, extended social.

## Testing & security

- Test click-to-token logic; prevent macros/autoclickers.
- Captcha or stealth checks if needed.
- Smart contract testing if on-chain (tokens, NFT transfers, marketplace).
