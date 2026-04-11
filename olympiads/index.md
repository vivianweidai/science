---
layout: default
---

## Olympiads

<div class="tabs">
  <input type="radio" name="oly" id="oly-math" checked>
  <input type="radio" name="oly" id="oly-comp">
  <input type="radio" name="oly" id="oly-phys">
  <input type="radio" name="oly" id="oly-chem">
  <input type="radio" name="oly" id="oly-bio">
  <input type="radio" name="oly" id="oly-astro">

  <div class="tab-labels">
    <label for="oly-math">Mathematics</label>
    <label for="oly-comp">Computing</label>
    <label for="oly-phys">Physics</label>
    <label for="oly-chem">Chemistry</label>
    <label for="oly-bio">Biology</label>
    <label for="oly-astro">Astronomy</label>
  </div>

  <div class="tab-content" id="oly-content-math"></div>
  <div class="tab-content" id="oly-content-comp"></div>
  <div class="tab-content" id="oly-content-phys"></div>
  <div class="tab-content" id="oly-content-chem"></div>
  <div class="tab-content" id="oly-content-bio"></div>
  <div class="tab-content" id="oly-content-astro"></div>
</div>

<img src="../archives/IMAGES/olympiads.jpeg" alt="Olympiads" width="100%">

### Textbooks

<div class="tabs">
  <input type="radio" name="tab" id="tab-math" checked>
  <input type="radio" name="tab" id="tab-comp">
  <input type="radio" name="tab" id="tab-phys">
  <input type="radio" name="tab" id="tab-chem">
  <input type="radio" name="tab" id="tab-bio">
  <input type="radio" name="tab" id="tab-astro">

  <div class="tab-labels">
    <label for="tab-math">Mathematics</label>
    <label for="tab-comp">Computing</label>
    <label for="tab-phys">Physics</label>
    <label for="tab-chem">Chemistry</label>
    <label for="tab-bio">Biology</label>
    <label for="tab-astro">Astronomy</label>
  </div>

  <div class="tab-content" id="content-math"></div>
  <div class="tab-content" id="content-comp"></div>
  <div class="tab-content" id="content-phys"></div>
  <div class="tab-content" id="content-chem"></div>
  <div class="tab-content" id="content-bio"></div>
  <div class="tab-content" id="content-astro"></div>
</div>

<script>
// Olympiads and textbooks are rendered from archives/CONTENT/{olympiads,textbooks}.json,
// built from archives/CONTENT/{olympiads,textbooks}.yml by
// archives/LAYOUT/build_listings.py. Edit the YAML, rerun the script, commit
// both. No DB, no API.
(function () {
  var SUBJECT_SLUGS = {
    Mathematics: 'math', Computing: 'comp', Physics: 'phys',
    Chemistry: 'chem', Biology: 'bio', Astronomy: 'astro'
  };

  function escapeHTML(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }

  function titleHTML(entry) {
    var title = escapeHTML(entry.title);
    if (!entry.url) return title;
    var linkText = entry.link_text ? escapeHTML(entry.link_text) : title;
    var href = escapeHTML(entry.url);
    var anchor = '<a href="' + href + '" target="_blank">' + linkText + '</a>';
    if (!entry.link_text) return anchor;
    return title.replace(linkText, anchor);
  }

  function cell(html, finished) {
    return finished ? '<td><s>' + html + '</s></td>' : '<td>' + html + '</td>';
  }

  function renderOlympiads(items) {
    var bySubject = {};
    items.forEach(function (o) {
      (bySubject[o.subject] = bySubject[o.subject] || []).push(o);
    });
    Object.keys(SUBJECT_SLUGS).forEach(function (subj) {
      var slug = SUBJECT_SLUGS[subj];
      var target = document.getElementById('oly-content-' + slug);
      if (!target) return;
      var rows = (bySubject[subj] || []).map(function (o) {
        var cls = o.highlighted ? ' class="highlight"' : '';
        return '<tr' + cls + '>'
          + cell(escapeHTML(o.date), o.finished)
          + cell(escapeHTML(o.country), o.finished)
          + cell(escapeHTML(o.name), o.finished)
          + '</tr>';
      }).join('');
      target.innerHTML = '<table>'
        + '<tr><th>Date</th><th>Country</th><th>Olympiad</th></tr>'
        + rows + '</table>';
    });
  }

  function renderTextbooks(items) {
    var bySubject = {};
    items.forEach(function (t) {
      (bySubject[t.subject] = bySubject[t.subject] || []).push(t);
    });
    Object.keys(SUBJECT_SLUGS).forEach(function (subj) {
      var slug = SUBJECT_SLUGS[subj];
      var target = document.getElementById('content-' + slug);
      if (!target) return;
      var rows = (bySubject[subj] || []).map(function (t) {
        var cls = t.highlighted ? ' class="highlight"' : '';
        return '<tr' + cls + '>'
          + cell(escapeHTML(t.date), t.finished)
          + cell(titleHTML(t), t.finished)
          + '</tr>';
      }).join('');
      target.innerHTML = '<table>'
        + '<tr><th>Date</th><th>Textbook</th></tr>'
        + rows + '</table>';
    });
  }

  function fetchJSON(path) {
    return fetch(path, { cache: 'no-cache' }).then(function (r) {
      if (!r.ok) throw new Error(path + ' ' + r.status);
      return r.json();
    });
  }

  fetchJSON('../archives/CONTENT/olympiads.json').then(function (d) { renderOlympiads(d.items); });
  fetchJSON('../archives/CONTENT/textbooks.json').then(function (d) { renderTextbooks(d.items); });
})();
</script>

---

<div class="footer"><div class="footer-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a href="/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/science/tree/main/content">View on GitHub</a></div>
