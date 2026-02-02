# Token Clicker — Research & Inspiration

## Clicker / Idle Game Trends (2024–2025)

### Core design
- **Hybrid engagement**: Games ask for short, periodic attention rather than pure idle or pure active play ([Gamigion](https://www.gamigion.com/idle/)).
- **Content gating**: Features unlock by currency/level; “known unknowns” (visible but locked) and “unknown unknowns” (hidden) keep discovery and progression satisfying ([Tuts+](https://gamedevelopment.tutsplus.com/articles/numbers-getting-bigger-the-design-and-math-of-incremental-games--cms-25023)).
- **One strong fantasy**: Top games do one core fantasy very well instead of many shallow ones ([Gamigion](https://www.gamigion.com/idle/)).

### Incremental mechanics
- **Primary currency**: One main number that drives progression.
- **Generators**: Things that produce currency at different rates.
- **Compounding progress**: Costs and outputs scale (often exponentially) so players always have a next goal ([Game Developer](https://www.gamedeveloper.com/design/the-math-of-idle-games-part-i)).

### Retention & monetization
- **When to show monetization**: Rewards and store appear at meaningful moments instead of constant popups ([Gamigion](https://www.gamigion.com/idle/)).
- **Production**: Browser idle/clicker games can ship in ~4–6 months with modest budgets; success depends on clear design and discipline ([The Mind Studios](https://games.themindstudios.com/post/idle-clicker-game-design-and-monetization/)).

---

## Daily rewards, progression & leaderboards

### Daily rewards
- **Role**: Give a reason to open the app every day; especially important in F2P ([Game Developer](https://www.gamedeveloper.com/business/the-science-craft-of-designing-daily-rewards----and-why-ftp-games-need-them)).
- **Progression in dailies**: Login calendars, growing streaks, “complete all dailies” bonuses, and bi-weekly milestones make rewards scale with engagement ([GameRefinery](https://medium.com/@GameRefinery/feature-spotlight-progression-elements-in-daily-rewards-a2e20a069b9e)).
- **Retention**: Daily bonuses fight churn and support microtransaction-driven revenue ([Game Developer](https://www.gamedeveloper.com/design/increasing-player-retention-with-daily-bonuses)).

### Clicker-specific
- Idle/clicker sits in top mobile genres; daily rewards and progression work well with short, frequent sessions ([The Mind Studios](https://games.themindstudios.com/post/idle-clicker-game-design-and-monetization/)).

---

## NFT integration in casual games (simplified for average users)

### Lowering friction
- **Custodial / email-first**: Enjin’s “Quick Wallet” lets users claim NFTs via email without installing a wallet first ([NFT News Today](https://nftnewstoday.com/2024/05/23/enjin-blockchain-unveils-quick-wallet-to-simplify-nft-claims)).
- **Abstracted infra**: Platforms like Mythical let studios add secondary economies and trading without building blockchain infra ([Mythical](https://docs.mythicalgames.com/)).

### Play-to-earn in casual
- Hyper-casual + web (e.g. Next.js) + smart contracts can deliver simple play-to-earn with tokens earned through easy-to-understand actions ([Case study](https://as-proceeding.com/index.php/icpis/article/view/857)).
- **Tooling**: Immutable and Solana provide game-oriented APIs for NFTs, gating, and staking so devs don’t need deep chain expertise ([Immutable](https://docs.immutable.com/build/unity/quickstart/build-a-game), [Solana](https://solana.com/pl/developers/guides/games/nfts-in-games)).

### Takeaways for Token Clicker
- Start with **off-chain or custodial** tokens/NFTs (e.g. Supabase) for speed and UX; add on-chain (ERC-20, ERC-721/1155) when needed.
- Use **simple copy and one-tap actions** (claim, swap) and avoid wallet jargon on first-time flows.
- **Progression and daily rewards** can be implemented entirely in the DB first; link to NFTs/tokens when design is stable.

---

## References

1. [How To Increase Engagement and Monetization in Idle Games in 2025](https://www.gamigion.com/idle/)
2. [Numbers Getting Bigger: The Design and Math of Incremental Games](https://gamedevelopment.tutsplus.com/articles/numbers-getting-bigger-the-design-and-math-of-incremental-games--cms-25023)
3. [The Math of Idle Games, Part I](https://www.gamedeveloper.com/design/the-math-of-idle-games-part-i)
4. [The Science & Craft of Designing Daily Rewards](https://www.gamedeveloper.com/business/the-science-craft-of-designing-daily-rewards----and-why-ftp-games-need-them)
5. [Progression Elements in Daily Rewards](https://medium.com/@GameRefinery/feature-spotlight-progression-elements-in-daily-rewards-a2e20a069b9e)
6. [Enjin Quick Wallet for NFT Claims](https://nftnewstoday.com/2024/05/23/enjin-blockchain-unveils-quick-wallet-to-simplify-nft-claims)
7. [Integrating Technologies for Play-to-Earn (Case Study)](https://as-proceeding.com/index.php/icpis/article/view/857)
8. [Solana – Using NFTs in Games](https://solana.com/pl/developers/guides/games/nfts-in-games)
