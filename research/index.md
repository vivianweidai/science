---
layout: default
---

<div class="page-header"><h2>Research</h2><div class="header-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a class="active" href="/research/">Research</a></div></div>

<div class="tabs" id="toys-tabs">
  <input type="radio" name="toys-view" id="toys-all">
  <input type="radio" name="toys-view" id="toys-math">
  <input type="radio" name="toys-view" id="toys-comp">
  <input type="radio" name="toys-view" id="toys-phys">
  <input type="radio" name="toys-view" id="toys-chem">
  <input type="radio" name="toys-view" id="toys-bio">
  <input type="radio" name="toys-view" id="toys-astro">
  <script>
    (function(){
      var picks = ['toys-chem','toys-bio','toys-phys','toys-comp'];
      document.getElementById(picks[Math.floor(Math.random() * picks.length)]).checked = true;
    })();
  </script>

  <div class="tab-labels">
    <label for="toys-all">All</label>
    <label for="toys-math">Mathematics</label>
    <label for="toys-comp">Computing</label>
    <label for="toys-phys">Physics</label>
    <label for="toys-chem">Chemistry</label>
    <label for="toys-bio">Biology</label>
    <label for="toys-astro">Astronomy</label>
  </div>
</div>

<div class="toys-section" id="toys-content"></div>

<script>
(function () {
  var SLUG_MAP = {
    Biology: 'bio', Chemistry: 'chem', Physics: 'phys',
    Computing: 'comp', Mathematics: 'math', Astronomy: 'astro'
  };

  function esc(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }

  function renderToys(items, filter) {
    var filtered = filter === 'all'
      ? items
      : items.filter(function (t) { return t.science_slug === filter; });

    // Group by technology, preserving source order
    var groups = [];
    var groupMap = {};
    filtered.forEach(function (t) {
      var key = t.science + '|' + t.technology;
      if (!groupMap[key]) {
        groupMap[key] = { science: t.science, slug: t.science_slug, technology: t.technology, items: [] };
        groups.push(groupMap[key]);
      }
      groupMap[key].items.push(t);
    });

    var html = '';
    groups.forEach(function (g) {
      html += '<div class="toys-block">';
      html += '<h4 class="toys-group">' + esc(g.technology) + '</h4>';
      html += '<table class="toys-table"><thead><tr>'
        + '<th></th><th>Principle</th><th>Question</th><th>Answer</th><th>State</th>'
        + '</tr></thead><tbody>';
      g.items.forEach(function (t) {
        var cls = t.highlighted ? ' class="toys-hl"' : '';
        var principle = esc(t.principle);
        // If completed, wrap principle in a link to the project page
        if (t.project_url) {
          principle = '<a href="' + t.project_url + '">' + principle + '</a>';
        }
        // Status indicators
        var badges = '';
        if (t.available) badges += ' <span class="toys-badge avail" title="Available">&#10003;</span>';
        if (t.completed) badges += ' <span class="toys-badge done" title="Completed">&#9733;</span>';
        html += '<tr' + cls + '>'
          + '<td><span class="chip ' + t.science_slug + '">' + t.science + '</span></td>'
          + '<td>' + principle + badges + '</td>'
          + '<td>' + esc(t.question) + '</td>'
          + '<td>' + esc(t.answer) + '</td>'
          + '<td>' + esc(t.state) + '</td>'
          + '</tr>';
      });
      html += '</tbody></table></div>';
    });

    if (groups.length === 0) {
      html = '<p style="color:#656d76;font-style:italic;margin:1em 0;">No toys in this discipline yet.</p>';
    }

    document.getElementById('toys-content').innerHTML = html;
  }

  fetch('../archives/CONTENT/toys.json', { cache: 'no-cache' })
    .then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); })
    .then(function (d) {
      var items = d.items;

      // Initial render — respect the randomly preselected tab
      var checked = document.querySelector('input[name="toys-view"]:checked');
      var filter = checked ? checked.id.replace('toys-', '') : 'all';
      renderToys(items, filter);

      // Wire up tab filtering
      document.querySelectorAll('input[name="toys-view"]').forEach(function (radio) {
        radio.addEventListener('change', function () {
          renderToys(items, this.id.replace('toys-', ''));
        });
      });
    });
})();
</script>

<style>
  .toys-section { margin: 1em 0; }
  .toys-group {
    margin: 1.2em 0 .3em 0;
    font-size: .95em;
    font-weight: 700;
    color: #1f2328;
    border-bottom: 1px solid #d1d9e0;
    padding-bottom: .2em;
  }
  .toys-table {
    width: 100%;
    border-collapse: collapse;
    font-size: .85em;
    margin-bottom: .5em;
  }
  .toys-table thead th {
    text-align: left;
    font-weight: 600;
    color: #656d76;
    font-size: .8em;
    text-transform: uppercase;
    letter-spacing: .04em;
    padding: .3em .5em;
    border-bottom: 1px solid #d1d9e0;
  }
  .toys-table thead th:first-child { width: 6.5em; }
  .toys-table tbody td {
    padding: .35em .5em;
    border-bottom: 1px solid #f0f0f0;
    vertical-align: top;
    color: #1f2328;
  }
  .toys-table tbody td a { color: #0969da; text-decoration: none; font-weight: 600; }
  .toys-table tbody td a:hover { text-decoration: underline; }
  .toys-table tbody tr:last-child td { border-bottom: none; }
  .toys-table tbody tr.toys-hl td { background: #fffde7; }
  .toys-badge {
    display: inline-block; font-size: .7em; vertical-align: middle;
    margin-left: 3px; line-height: 1;
  }
  .toys-badge.avail { color: #1a7f37; }
  .toys-badge.done { color: #d4a017; }

  .chip {
    display: inline-block; padding: 1px 7px; border-radius: 999px;
    font-size: .72em; font-weight: 600; color: #1f2328;
    text-align: center; white-space: nowrap; line-height: 1.6;
  }
  .chip.math  { background: var(--subj-math); }
  .chip.comp  { background: var(--subj-comp); }
  .chip.phys  { background: var(--subj-phys); }
  .chip.chem  { background: var(--subj-chem); }
  .chip.bio   { background: var(--subj-bio); }
  .chip.astro { background: var(--subj-astro); }

  @media (max-width: 600px) {
    .toys-table { font-size: .78em; }
    .toys-table thead th:first-child { width: 5em; }
  }

  /* Toys tab styling — match olympiads colour scheme */
  #toys-all:checked ~ .tab-labels label[for="toys-all"] {
    color: #656d76; border-bottom-color: #656d76; background: #e8e8e8;
  }
  #toys-math:checked ~ .tab-labels label[for="toys-math"] {
    color: #2563eb; border-bottom-color: #2563eb; background: var(--subj-math);
  }
  #toys-comp:checked ~ .tab-labels label[for="toys-comp"] {
    color: #7c3aed; border-bottom-color: #7c3aed; background: var(--subj-comp);
  }
  #toys-phys:checked ~ .tab-labels label[for="toys-phys"] {
    color: #ea580c; border-bottom-color: #ea580c; background: var(--subj-phys);
  }
  #toys-chem:checked ~ .tab-labels label[for="toys-chem"] {
    color: #5c7a10; border-bottom-color: #5c7a10; background: var(--subj-chem);
  }
  #toys-bio:checked ~ .tab-labels label[for="toys-bio"] {
    color: #0e8577; border-bottom-color: #0e8577; background: var(--subj-bio);
  }
  #toys-astro:checked ~ .tab-labels label[for="toys-astro"] {
    color: #e11d48; border-bottom-color: #e11d48; background: var(--subj-astro);
  }
</style>

---

<div class="footer"><a class="footer-github" href="/">Science</a><div class="footer-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a class="active" href="/research/">Research</a></div></div>
