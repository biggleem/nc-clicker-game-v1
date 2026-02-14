/**
 * Friend request – console test helpers.
 * Open the app (e.g. http://localhost:3001), go to FRIENDS, then paste this file
 * into DevTools Console and call runFriendRequestChecks().
 */
(function() {
  function el(id) { return document.getElementById(id); }
  function hasClass(el, c) { return el && el.classList && el.classList.contains(c); }

  window.runFriendRequestChecks = function() {
    var out = [];
    // Sender elements
    var input = el('friend-code-input');
    var addBtn = el('friend-code-add-btn');
    var feedback = el('friend-code-feedback');
    var refCode = el('referral-code');
    out.push('[Sender] friend-code-input: ' + (input ? 'ok' : 'MISSING'));
    out.push('[Sender] friend-code-add-btn: ' + (addBtn ? 'ok' : 'MISSING'));
    out.push('[Sender] friend-code-feedback: ' + (feedback ? 'ok' : 'MISSING'));
    out.push('[Sender] referral-code (your code): ' + (refCode ? refCode.textContent : 'MISSING'));

    // Receiver elements
    var sect = el('friend-requests-section');
    var list = el('friend-requests-list');
    var acceptBtns = list ? list.querySelectorAll('.friend-request-accept') : [];
    out.push('[Receiver] friend-requests-section: ' + (sect ? 'ok' : 'MISSING'));
    out.push('[Receiver] friend-requests-list: ' + (list ? 'ok' : 'MISSING'));
    out.push('[Receiver] section visible: ' + (sect ? !hasClass(sect, 'hidden') : 'n/a'));
    out.push('[Receiver] pending count (ACCEPT buttons): ' + acceptBtns.length);

    if (acceptBtns.length > 0) {
      acceptBtns.forEach(function(btn, i) {
        out.push('  request ' + (i + 1) + ' id=' + btn.getAttribute('data-id') + ' from=' + btn.getAttribute('data-from-name'));
      });
    }

    // Global functions (must be in app scope)
    var hasAdd = typeof window.addFriendByCode === 'function';
    var hasAccept = typeof window.acceptFriendRequest === 'function';
    var hasReject = typeof window.rejectFriendRequest === 'function';
    var hasLoad = typeof window.loadFriendRequests === 'function';
    out.push('[Code] addFriendByCode: ' + (hasAdd ? 'ok' : 'MISSING'));
    out.push('[Code] acceptFriendRequest: ' + (hasAccept ? 'ok' : 'MISSING'));
    out.push('[Code] rejectFriendRequest: ' + (hasReject ? 'ok' : 'MISSING'));
    out.push('[Code] loadFriendRequests: ' + (hasLoad ? 'ok' : 'MISSING'));

    var report = out.join('\n');
    console.log(report);
    return report;
  };

  console.log('Friend request checks loaded. Run: runFriendRequestChecks()');
})();
