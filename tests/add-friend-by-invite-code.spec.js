// @ts-check
/**
 * E2E: Add friend by invite code (Friends modal).
 * Run against local server for reliable results:
 *   npm run serve   (in one terminal)
 *   BASE_URL=http://localhost:3001 npm run test:e2e
 * Or on Windows PowerShell: $env:BASE_URL='http://localhost:3001'; npm run test:e2e
 */
import { test, expect } from '@playwright/test';

test.describe('Add friend by invite code', () => {
  test.setTimeout(60000);

  test.beforeEach(async ({ page }) => {
    // Skip onboarding so multiplayer is usable
    await page.addInitScript(() => {
      try {
        localStorage.setItem('tokenClicker_onboardingCompleted', '1');
      } catch (e) {}
    });
    await page.goto('/#multiplayer', { waitUntil: 'load' });
    // Ensure multiplayer page is shown (hash may not apply before load)
    await page.evaluate(() => {
      window.location.hash = 'multiplayer';
      window.dispatchEvent(new Event('hashchange'));
    });
    const addFriendsBtn = page.locator('#header-friends-btn');
    await addFriendsBtn.waitFor({ state: 'visible', timeout: 20000 });
    await addFriendsBtn.click();
    await expect(page.getByText('FRIENDS — INVITE & REQUESTS')).toBeVisible({ timeout: 10000 });
  });

  test('shows "Enter an invite code" when code is empty', async ({ page }) => {
    const input = page.getByPlaceholder('E.G. REFABC12');
    await input.fill('');
    await page.locator('#friend-code-add-btn').click();
    await expect(page.getByText('Enter an invite code.')).toBeVisible();
  });

  test('shows "You can\'t add yourself" when entering own code', async ({ page }) => {
    const codeEl = page.locator('#referral-code');
    await expect(codeEl).toBeVisible();
    const ownCode = (await codeEl.textContent()) || '';
    if (!ownCode || ownCode === '------') {
      test.skip();
      return;
    }
    await page.getByPlaceholder('E.G. REFABC12').fill(ownCode);
    await page.locator('#friend-code-add-btn').click();
    await expect(page.getByText("You can't add yourself.")).toBeVisible();
  });

  test('shows unknown code message for non-existent code', async ({ page }) => {
    await page.getByPlaceholder('E.G. REFABC12').fill('REFUNKNOWN999');
    await page.locator('#friend-code-add-btn').click();
    await expect(
      page.getByText(/Unknown invite code|Your friend should open the app/)
    ).toBeVisible();
  });
});
