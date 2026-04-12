---
layout: default
---

<div class="page-header"><h2>Olympiads</h2><a class="back-link" href="/">Science</a></div>

<img src="../archives/IMAGES/olympiads.jpeg" alt="Olympiads" width="100%">

<div class="tabs">
  <input type="radio" name="view" id="view-all" checked>
  <input type="radio" name="view" id="view-math">
  <input type="radio" name="view" id="view-comp">
  <input type="radio" name="view" id="view-phys">
  <input type="radio" name="view" id="view-chem">
  <input type="radio" name="view" id="view-bio">
  <input type="radio" name="view" id="view-astro">

  <div class="tab-labels">
    <label for="view-all">All</label>
    <label for="view-math">Mathematics</label>
    <label for="view-comp">Computing</label>
    <label for="view-phys">Physics</label>
    <label for="view-chem">Chemistry</label>
    <label for="view-bio">Biology</label>
    <label for="view-astro">Astronomy</label>
  </div>
</div>

<div id="timeline"></div>

<style>
  .timeline { border-left: 2px solid #d1d9e0; margin-left: .8em; padding-left: 1.2em; }
  .timeline .year-marker {
    font-weight: 700; font-size: 1.1em;
    margin: 1.2em 0 .4em -1.9em;
    padding-left: .5em;
    background: #fff;
    display: inline-block;
    position: relative;
  }
  .timeline .year-marker::before {
    content: ""; position: absolute; left: -.5em; top: .35em;
    width: .8em; height: .8em; border-radius: 50%; background: #1f2328;
  }
  .timeline .entry {
    display: grid;
    grid-template-columns: 4.5em 1fr;
    gap: .8em;
    padding: .35em 0;
    position: relative;
    font-size: .95em;
  }
  .timeline .entry::before {
    content: ""; position: absolute; left: -1.5em; top: .9em;
    width: .5em; height: .5em; border-radius: 50%; background: #d1d9e0;
  }
  .timeline .entry.hl::before { background: #e5a800; width: .65em; height: .65em; left: -1.57em; top: .85em; }
  .timeline .entry.done { color: #656d76; }
  .timeline .entry.done .ename { text-decoration: line-through; }
  .timeline .entry .month { color: #656d76; font-variant-numeric: tabular-nums; }
  .timeline .entry.hl { background: #fffbe0; border-radius: 6px; padding-left: .4em; padding-right: .4em; margin-left: -.4em; margin-right: -.4em; }

  .chip {
    display: inline-block;
    padding: 1px 7px;
    border-radius: 999px;
    font-size: .72em;
    font-weight: 600;
    color: #1f2328;
    vertical-align: middle;
  }
  .chip.math  { background: #e2d9f3; }
  .chip.comp  { background: #cce5ff; }
  .chip.phys  { background: #fce4b8; }
  .chip.chem  { background: #d4edda; }
  .chip.bio   { background: #f8d7da; }
  .chip.astro { background: #fff3cd; }

  .type-icon { font-size: .85em; margin-right: .15em; }

  .legend { font-size: .82em; color: #656d76; margin: .3em 0 1em; line-height: 2; }
  .legend .chip { margin-right: .3em; }
</style>

<script>
// Timeline view — renders archives/CONTENT/olympiads.json as a vertical
// chronological timeline grouped by year. Built from archives/CONTENT/olympiads.yml
// by archives/LAYOUT/build_listings.py.
(function () {
  var SUBJECT_SLUGS = {
    Mathematics: 'math', Computing: 'comp', Physics: 'phys',
    Chemistry: 'chem', Biology: 'bio', Astronomy: 'astro'
  };
  var FLAGS = { 'Canada': '🇨🇦', 'United States': '🇺🇸' };

  function esc(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }

  function chip(subj) {
    var slug = SUBJECT_SLUGS[subj];
    return '<span class="chip ' + slug + '">' + subj + '</span>';
  }

  function renderTimeline(items, filter) {
    // Filter by subject if not "all"
    var filtered = filter === 'all'
      ? items
      : items.filter(function (e) { return SUBJECT_SLUGS[e.subject] === filter; });

    // Sort newest first
    filtered.sort(function (a, b) { return b.sort_key.localeCompare(a.sort_key); });

    // Group by year
    var years = {};
    var yearOrder = [];
    filtered.forEach(function (e) {
      var y = e.sort_key === '9999-12' ? 'Future' : e.sort_key.slice(0, 4);
      if (!years[y]) { years[y] = []; yearOrder.push(y); }
      years[y].push(e);
    });

    var html = '<div class="timeline">';
    yearOrder.forEach(function (y) {
      html += '<div class="year-marker">' + y + '</div>';
      years[y].forEach(function (e) {
        var month = e.date === 'Future' ? '' : e.date.split(' ')[0].slice(0, 3);
        var flag = e.country ? (FLAGS[e.country] || '') + ' ' : '';
        var icon = e.type === 'olympiad' ? '<span class="type-icon">🏅</span>' : '<span class="type-icon">📖</span>';
        var cls = (e.highlighted ? ' hl' : '') + (e.finished ? ' done' : '');
        html += '<div class="entry' + cls + '" data-subject="' + SUBJECT_SLUGS[e.subject] + '">'
          + '<div class="month">' + month + '</div>'
          + '<div>' + flag + icon + chip(e.subject) + ' <span class="ename">' + esc(e.name) + '</span></div>'
          + '</div>';
      });
    });
    html += '</div>';

    document.getElementById('timeline').innerHTML = html;
  }

  // Fetch data
  fetch('../archives/CONTENT/olympiads.json', { cache: 'no-cache' })
    .then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); })
    .then(function (d) {
      var items = d.items;

      // Initial render
      renderTimeline(items, 'all');

      // Wire up tab filtering
      var radios = document.querySelectorAll('input[name="view"]');
      radios.forEach(function (radio) {
        radio.addEventListener('change', function () {
          var filter = this.id.replace('view-', '');
          renderTimeline(items, filter);
        });
      });
    });
})();
</script>

---

<div class="footer"><div class="footer-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a href="/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/science/tree/main/content">View on GitHub</a></div>
