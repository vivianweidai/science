/* Shared photo-preview hover popup.
 *
 * Listens via event delegation for mouseover/mouseout and shows a
 * floating preview when the cursor enters a trigger element. Triggers:
 *   - any [data-photo="<url>"] element (research toy cards expose
 *     their hero photo this way so the title stays plain text)
 *   - any <a href="...jpg|.jpeg|.png|.gif|.webp"> link in markdown
 *
 * Positioning: placed below the trigger by default; flipped above or
 * clamped to viewport edges so the popup never falls off-screen.
 */
(function () {
  var preview;
  var lastTrigger = null;

  function ensurePreview() {
    if (preview) return preview;
    preview = document.createElement('div');
    preview.id = 'photo-preview';
    preview.innerHTML = '<img alt="" />';
    document.body.appendChild(preview);
    return preview;
  }

  function photoUrlFor(el) {
    if (!el) return null;
    if (el.dataset && el.dataset.photo) return el.dataset.photo;
    if (el.tagName === 'A') {
      var href = el.getAttribute('href') || '';
      if (/\.(jpe?g|png|gif|webp)(\?|$)/i.test(href)) return el.href;
    }
    return null;
  }

  function findTrigger(node) {
    var el = node;
    while (el && el !== document.body) {
      if (photoUrlFor(el)) return el;
      el = el.parentElement;
    }
    return null;
  }

  function position(p, trigger) {
    var rect = trigger.getBoundingClientRect();
    var vw = window.innerWidth, vh = window.innerHeight;
    var pW = p.offsetWidth  || 330;
    var pH = p.offsetHeight || 250;
    var top  = rect.bottom + 6;
    var left = rect.left;
    if (top + pH > vh - 8) top = rect.top - pH - 6;        /* flip above */
    if (top < 8) top = 8;                                   /* clamp top */
    if (top + pH > vh - 8) top = vh - pH - 8;               /* clamp bottom */
    if (left + pW > vw - 8) left = vw - pW - 8;             /* clamp right */
    if (left < 8) left = 8;                                 /* clamp left */
    p.style.top  = (top  + window.scrollY) + 'px';
    p.style.left = (left + window.scrollX) + 'px';
  }

  function show(trigger) {
    var p = ensurePreview();
    var img = p.querySelector('img');
    var url = photoUrlFor(trigger);
    if (!url) return;
    if (img.src !== url) {
      img.onerror = function () { hide(); };
      img.onload = function () {
        if (lastTrigger === trigger) position(p, trigger);
      };
      img.src = url;
    }
    position(p, trigger);
    p.classList.add('visible');
  }

  function hide() {
    if (preview) preview.classList.remove('visible');
  }

  document.addEventListener('mouseover', function (e) {
    var t = findTrigger(e.target);
    if (!t) {
      if (lastTrigger) { hide(); lastTrigger = null; }
      return;
    }
    if (t === lastTrigger) return;
    lastTrigger = t;
    show(t);
  });

  document.addEventListener('mouseout', function (e) {
    var t = findTrigger(e.target);
    if (!t) return;
    var to = e.relatedTarget;
    if (to && t.contains(to)) return;
    hide();
    lastTrigger = null;
  });

  /* Project pages and other markdown content render image-href links as
     <a href="x.jpg">Title 📷</a> or <a>Title</a> 📷. Rewrite them once on
     load so the title is plain text (with a data-photo attribute for the
     hover preview) and only the 📷 stays clickable. */
  function transformPhotoLinks() {
    var links = document.querySelectorAll('a[href]');
    for (var i = 0; i < links.length; i++) {
      var a = links[i];
      if (a.classList.contains('photo-icon') || a.classList.contains('toys-wip')) continue;
      var href = a.getAttribute('href') || '';
      if (!/\.(jpe?g|png|gif|webp)(\?|$)/i.test(href)) continue;

      var iconInLink = /📷\s*$/.test(a.textContent);
      var iconAfter = null;
      if (!iconInLink) {
        var n = a.nextSibling;
        while (n && n.nodeType === 3 && /^\s*$/.test(n.nodeValue)) n = n.nextSibling;
        if (n && n.nodeType === 3 && /📷/.test(n.nodeValue)) iconAfter = n;
      }
      if (!iconInLink && !iconAfter) continue;

      var span = document.createElement('span');
      if (iconInLink) {
        span.innerHTML = a.innerHTML.replace(/\s*📷\s*$/, '');
      } else {
        span.innerHTML = a.innerHTML;
      }
      if (!span.textContent.trim()) continue; /* nothing left if it was a pure icon link */

      var icon = document.createElement('a');
      icon.setAttribute('href', href);
      icon.setAttribute('class', 'photo-icon');
      icon.setAttribute('title', 'View photo');
      icon.textContent = '📷';

      if (iconInLink) {
        a.replaceWith(span, document.createTextNode(' '), icon);
      } else {
        var parent = iconAfter.parentNode;
        var nodeText = iconAfter.nodeValue;
        var idx = nodeText.indexOf('📷');
        var before = nodeText.slice(0, idx);
        var after = nodeText.slice(idx + 2); /* 📷 is a surrogate pair (length 2) */
        a.replaceWith(span);
        if (before) parent.insertBefore(document.createTextNode(before), iconAfter);
        parent.insertBefore(icon, iconAfter);
        if (after) parent.insertBefore(document.createTextNode(after), iconAfter);
        parent.removeChild(iconAfter);
      }
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', transformPhotoLinks);
  } else {
    transformPhotoLinks();
  }
})();
