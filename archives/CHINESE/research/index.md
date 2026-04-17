---
layout: default
html_lang: zh
---

<div class="page-header"><h2>研究</h2><div class="header-nav"><a href="/archives/CHINESE/curriculum/">课程</a><a href="/archives/CHINESE/olympiads/">竞赛</a><a class="active" href="/archives/CHINESE/research/">研究</a></div></div>

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
    <label for="toys-all">全部</label>
    <label for="toys-math">数学</label>
    <label for="toys-comp">计算</label>
    <label for="toys-phys">物理</label>
    <label for="toys-chem">化学</label>
    <label for="toys-bio">生物</label>
    <label for="toys-astro">天文</label>
  </div>
</div>

<div id="toys-content"></div>

<script>
(function () {
  function esc(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }

  function renderToys(items, filter) {
    var filtered = filter === 'all'
      ? items
      : items.filter(function (t) { return t.science_slug === filter; });

    if (filtered.length === 0) {
      document.getElementById('toys-content').innerHTML =
        '<p style="color:#656d76;font-style:italic;margin:1em 0;">No toys in this discipline yet.</p>';
      return;
    }

    var groups = [], groupMap = {};
    filtered.forEach(function (t) {
      var key = t.science + '|' + t.technology;
      if (!groupMap[key]) {
        groupMap[key] = { science: t.science, slug: t.science_slug, technology: t.technology, items: [] };
        groups.push(groupMap[key]);
      }
      groupMap[key].items.push(t);
    });

    var html = '<table class="toys-table"><tbody>';

    groups.forEach(function (g) {
      html += '<tr class="toys-group-row"><td colspan="3">'
        + '<span class="chip ' + g.slug + '">' + g.science + '</span> '
        + esc(g.technology) + '</td></tr>';

      g.items.forEach(function (t) {
        var cls = t.highlighted ? ' class="toys-hl"' : '';
        var principle = esc(t.principle);
        if (t.project_url) {
          principle = '<a href="' + t.project_url + '">' + principle + '</a>';
        }
        var badges = '';
        if (t.available) badges += '<span class="toys-badge avail" title="Available">&#10003;</span>';
        if (t.completed) badges += '<a href="' + t.project_url + '" class="toys-badge done" title="' + esc(t.completed) + '">&#9733;</a>';

        html += '<tr' + cls + '>'
          + '<td class="toys-name">' + principle + '</td>'
          + '<td class="toys-desc">' + esc(t.description) + '</td>'
          + '<td class="toys-badges">' + badges + '</td>'
          + '</tr>';
      });
    });

    html += '</tbody></table>';
    document.getElementById('toys-content').innerHTML = html;
  }

  fetch('../../../archives/CONTENT/toys.json', { cache: 'no-cache' })
    .then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); })
    .then(function (d) {
      var items = d.items;
      var checked = document.querySelector('input[name="toys-view"]:checked');
      var filter = checked ? checked.id.replace('toys-', '') : 'all';
      renderToys(items, filter);

      document.querySelectorAll('input[name="toys-view"]').forEach(function (radio) {
        radio.addEventListener('change', function () {
          renderToys(items, this.id.replace('toys-', ''));
        });
      });
    });
})();
</script>

<style>
  .toys-table {
    width: 100%;
    border-collapse: collapse;
    font-size: .88em;
    margin: .5em 0 1em;
  }
  .toys-table td {
    padding: .45em .6em;
    border-bottom: 1px solid #f0f0f0;
    vertical-align: top;
  }
  .toys-table tr:last-child td { border-bottom: none; }
  .toys-group-row td {
    font-weight: 700;
    font-size: .93em;
    padding: .8em .6em .35em;
    border-bottom: 1px solid #d1d9e0;
    background: none;
  }
  .toys-name {
    font-weight: 600;
    white-space: nowrap;
    width: 1%;
  }
  .toys-name a { color: #0969da; text-decoration: none; }
  .toys-name a:hover { text-decoration: underline; }
  .toys-desc { color: #484f58; }
  .toys-badges {
    white-space: nowrap;
    width: 1%;
    text-align: right;
  }
  .toys-hl td { background: #fffde7; }
  .toys-badge {
    display: inline-block;
    font-size: .8em;
    margin-left: 2px;
    vertical-align: middle;
    line-height: 1;
  }
  .toys-badge.avail { color: #1a7f37; }
  .toys-badge.done { color: #d4a017; text-decoration: none; }
  .toys-badge.done:hover { text-decoration: underline; }
  .chip {
    display: inline-block; padding: 1px 7px; border-radius: 999px;
    font-size: .76em; font-weight: 600; color: #1f2328;
    text-align: center; white-space: nowrap; line-height: 1.6;
    vertical-align: middle; margin-right: .3em;
  }
  .chip.math  { background: var(--subj-math); }
  .chip.comp  { background: var(--subj-comp); }
  .chip.phys  { background: var(--subj-phys); }
  .chip.chem  { background: var(--subj-chem); }
  .chip.bio   { background: var(--subj-bio); }
  .chip.astro { background: var(--subj-astro); }
  @media (max-width: 600px) {
    .toys-table { font-size: .82em; }
    .toys-name { white-space: normal; }
  }
  #toys-all:checked ~ .tab-labels label[for="toys-all"] { color: #656d76; border-bottom-color: #656d76; background: #e8e8e8; }
  #toys-math:checked ~ .tab-labels label[for="toys-math"] { color: #2563eb; border-bottom-color: #2563eb; background: var(--subj-math); }
  #toys-comp:checked ~ .tab-labels label[for="toys-comp"] { color: #7c3aed; border-bottom-color: #7c3aed; background: var(--subj-comp); }
  #toys-phys:checked ~ .tab-labels label[for="toys-phys"] { color: #ea580c; border-bottom-color: #ea580c; background: var(--subj-phys); }
  #toys-chem:checked ~ .tab-labels label[for="toys-chem"] { color: #5c7a10; border-bottom-color: #5c7a10; background: var(--subj-chem); }
  #toys-bio:checked ~ .tab-labels label[for="toys-bio"] { color: #0e8577; border-bottom-color: #0e8577; background: var(--subj-bio); }
  #toys-astro:checked ~ .tab-labels label[for="toys-astro"] { color: #e11d48; border-bottom-color: #e11d48; background: var(--subj-astro); }
</style>

---

<div class="footer"><a class="footer-github" href="/research/">English</a><div class="footer-nav"><a href="/archives/CHINESE/curriculum/">课程</a><a href="/archives/CHINESE/olympiads/">竞赛</a><a class="active" href="/archives/CHINESE/research/">研究</a></div></div>
