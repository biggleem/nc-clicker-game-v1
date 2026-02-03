/**
 * TON / Backend config.
 * - backendUrl: where your backend API runs. Set PRODUCTION_BACKEND_URL below after deploying the backend.
 * - Minter address is loaded from backend GET /api/config (set in backend .env).
 */
(function () {
  var PRODUCTION_BACKEND_URL = ''; // e.g. 'https://nc-clicker-game-v1-api.onrender.com' after you deploy backend
  var isProduction = typeof location !== 'undefined' && /^https:\/\/biggleem\.github\.io(\/|$)/.test(location.origin);
  // Canonical game URL for sharing – shared links open on mobile
  var GAME_BASE_URL = 'https://biggleem.github.io/nc-clicker-game-v1';
  window.TON_CONFIG = {
    backendUrl: isProduction && PRODUCTION_BACKEND_URL ? PRODUCTION_BACKEND_URL : 'http://localhost:3002',
    gameBaseUrl: GAME_BASE_URL,
  };
})();
