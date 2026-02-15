// @ts-check
/**
 * E2E: Pending friend requests between two brand-new guest accounts (no TON wallet).
 * Follows scripts/PRD-PENDING-REQUESTS-GUEST-TEST.txt.
 *
 * Uses two browser contexts so each user has isolated localStorage (different guest ids).
 * Requires Supabase with leaderboard, friend_requests, friends_by_code.
 *
 * Run against local server for reliable Supabase + same origin:
 *   npm run serve
 *   BASE_URL=http://localhost:3001 npm run test:e2e -- tests/pending-requests-two-guests.spec.js
 * Windows PowerShell: $env:BASE_URL='http://localhost:3001'; npm run test:e2e -- tests/pending-requests-two-guests.spec.js
 *
 * Supabase: requires migrations 010, 011, and 017 (leaderboard.player_id). If you see
 * "column leaderboard.player_id does not exist", run supabase/migrations/017_leaderboard_player_id_internal_wallet.sql in Supabase SQL Editor.
 */
import { test, expect } from '@playwright/test';

test.describe('Pending friend requests – two guest accounts (PRD flow)', () => {
  test.setTimeout(120000);

  test('Guest B sends request by code; Guest A sees pending and accepts', async ({ browser }) => {
    const initScript = () => {
      try {
        localStorage.setItem('tokenClicker_onboardingCompleted', '1');
      } catch (e) {}
    };

    // Context A = receiver (will get the request and accept)
    const contextA = await browser.newContext();
    const pageA = await contextA.newPage();
    await pageA.addInitScript(initScript);
    await pageA.goto(process.env.BASE_URL || '/', { waitUntil: 'load' });
    await pageA.evaluate(() => {
      window.location.hash = 'multiplayer';
      window.dispatchEvent(new Event('hashchange'));
    });

    // Context B = sender (will add Guest A by code)
    const contextB = await browser.newContext();
    const pageB = await contextB.newPage();
    await pageB.addInitScript(initScript);
    await pageB.goto(process.env.BASE_URL || '/', { waitUntil: 'load' });
    await pageB.evaluate(() => {
      window.location.hash = 'multiplayer';
      window.dispatchEvent(new Event('hashchange'));
    });

    // --- Guest A: set name and get invite code ---
    await pageA.locator('#header-settings-btn').waitFor({ state: 'visible', timeout: 15000 });
    await pageA.locator('#header-settings-btn').click();
    await pageA.locator('#wallet-settings-modal').waitFor({ state: 'visible', timeout: 5000 });
    await pageA.locator('#wallet-settings-btn').click();
    await pageA.locator('#profile-name-modal').waitFor({ state: 'visible', timeout: 5000 });
    await pageA.locator('#profile-name-input').fill('GuestAlice');
    await pageA.evaluate(() => document.getElementById('profile-name-save').click());
    await pageA.locator('#profile-name-modal').waitFor({ state: 'hidden', timeout: 5000 });
    await pageA.locator('#wallet-settings-modal-close').click();
    await pageA.locator('#wallet-settings-modal').waitFor({ state: 'hidden', timeout: 3000 });
    // Allow Supabase persistNameToLeaderboard to complete so add-by-code can resolve the code
    await pageA.waitForTimeout(5000);

    await pageA.locator('#header-friends-btn').click();
    await expect(pageA.getByText('FRIENDS — INVITE & REQUESTS')).toBeVisible({ timeout: 10000 });
    const codeEl = pageA.locator('#referral-code');
    await expect(codeEl).toBeVisible();
    let guestACode = (await codeEl.textContent()) || '';
    guestACode = (guestACode || '').trim().toUpperCase();
    if (!guestACode || guestACode === '------') {
      await contextA.close();
      await contextB.close();
      test.skip();
      return;
    }

    // --- Guest B: set name then send request to Guest A ---
    await pageB.locator('#header-settings-btn').waitFor({ state: 'visible', timeout: 15000 });
    await pageB.locator('#header-settings-btn').click();
    await pageB.locator('#wallet-settings-modal').waitFor({ state: 'visible', timeout: 5000 });
    await pageB.locator('#wallet-settings-btn').click();
    await pageB.locator('#profile-name-modal').waitFor({ state: 'visible', timeout: 5000 });
    await pageB.locator('#profile-name-input').fill('GuestBob');
    await pageB.evaluate(() => document.getElementById('profile-name-save').click());
    await pageB.locator('#profile-name-modal').waitFor({ state: 'hidden', timeout: 5000 });
    await pageB.locator('#wallet-settings-modal-close').click();
    await pageB.locator('#wallet-settings-modal').waitFor({ state: 'hidden', timeout: 3000 });
    await pageB.waitForTimeout(2500);

    await pageB.locator('#header-friends-btn').click();
    await expect(pageB.getByText('FRIENDS — INVITE & REQUESTS')).toBeVisible({ timeout: 10000 });
    await pageB.getByPlaceholder('E.G. REFABC12').fill(guestACode);
    await pageB.locator('#friend-code-add-btn').click();
    const feedback = pageB.locator('#friend-code-feedback');
    await expect(feedback).toBeVisible({ timeout: 8000 });
    const feedbackText = await feedback.textContent();
    if (feedbackText && /player_id|does not exist|schema/i.test(feedbackText)) {
      throw new Error(
        `Add-by-code failed (likely missing DB migration): "${feedbackText}". Run Supabase migration 017 (leaderboard.player_id). See scripts/PRD-PENDING-REQUESTS-GUEST-TEST.txt.`
      );
    }
    await expect(feedback).toContainText(/Request sent to/i, { timeout: 5000 });

    // --- Guest A: see pending request and accept ---
    await pageA.bringToFront();
    await pageA.locator('#header-friends-btn').click();
    await expect(pageA.getByText('FRIENDS — INVITE & REQUESTS')).toBeVisible({ timeout: 5000 });
    const section = pageA.locator('#friend-requests-section');
    await expect(section).toBeVisible({ timeout: 15000 });
    const acceptBtn = pageA.locator('.friend-request-accept').first();
    await expect(acceptBtn).toBeVisible({ timeout: 5000 });
    await acceptBtn.click();
    await expect(
      pageA.getByText(/You are now friends with GuestBob/i)
    ).toBeVisible({ timeout: 10000 });

    // --- Both: friend appears in list (optional sanity) ---
    await expect(pageA.getByText('GuestBob').first()).toBeVisible({ timeout: 5000 });
    await pageB.bringToFront();
    await pageB.locator('#header-friends-btn').click();
    await expect(pageB.getByText('GuestAlice').first()).toBeVisible({ timeout: 5000 });

    await contextA.close();
    await contextB.close();
  });
});
