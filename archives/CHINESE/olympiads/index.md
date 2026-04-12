---
layout: chinese-default
---

<div class="page-header"><h2>竞赛</h2><a class="back-link" href="/archives/CHINESE/">科学</a></div>

<div class="tabs">
  <input type="radio" name="view" id="view-all" checked>
  <input type="radio" name="view" id="view-math">
  <input type="radio" name="view" id="view-comp">
  <input type="radio" name="view" id="view-phys">
  <input type="radio" name="view" id="view-chem">
  <input type="radio" name="view" id="view-bio">
  <input type="radio" name="view" id="view-astro">

  <div class="tab-labels">
    <label for="view-all">全部</label>
    <label for="view-math">数学</label>
    <label for="view-comp">计算</label>
    <label for="view-phys">物理</label>
    <label for="view-chem">化学</label>
    <label for="view-bio">生物</label>
    <label for="view-astro">天文</label>
  </div>
</div>

<div id="timeline"></div>

<style>
  .timeline { border-left: 2px solid #d1d9e0; margin-left: .8em; padding-left: 1.2em; }
  .timeline .year-marker {
    font-weight: 700; font-size: 1.1em;
    margin: 1.2em 0 .4em 0;
    background: #fff;
    display: inline-block;
    position: relative;
  }
  .timeline .entry {
    display: grid;
    grid-template-columns: 6.5em 1.8em auto 1fr;
    gap: 0 .5em;
    padding: .35em 0;
    position: relative;
    font-size: .95em;
    align-items: first baseline;
  }
  .timeline .entry .top-line {
    display: contents;
  }
  .timeline .entry .month { color: #656d76; font-variant-numeric: tabular-nums; }
  .timeline .entry .type-cell { text-align: center; }
  .timeline .entry .chips-cell { white-space: nowrap; display: flex; gap: 2px; align-items: center; }
  .timeline .entry .name-cell { }
  .invited-badge { display: inline-block; font-size: .65em; font-weight: 700; padding: 1px 6px; border-radius: 4px; vertical-align: baseline; margin-left: 4px; background: #ffd700; color: #5a4500; position: relative; top: -1px; }
  .timeline .entry.hl { position: relative; }
  .timeline .entry.hl::before { content: ''; position: absolute; inset: -.1em -.4em; background: #fff44f; border-radius: 6px; z-index: -1; }

  .chip {
    display: inline-block;
    padding: 1px 7px;
    border-radius: 999px;
    font-size: .72em;
    font-weight: 600;
    color: #1f2328;
    vertical-align: middle;
    text-align: center;
    white-space: nowrap;
    line-height: 1.6;
  }
  .chip.math  { background: #c5d9f7; }
  .chip.comp  { background: #d9ccee; }
  .chip.phys  { background: #f9c4a8; }
  .chip.chem  { background: #cdeaa6; }
  .chip.bio   { background: #b8e0c4; }
  .chip.astro { background: #f4c2cb; }

  .type-icon { font-size: .85em; }
  .rings-icon { vertical-align: middle; }

  .legend { font-size: .82em; color: #656d76; margin: .3em 0 1em; line-height: 2; }
  .legend .chip { margin-right: .3em; }

  @media (max-width: 600px) {
    .timeline .entry {
      display: flex;
      flex-direction: column;
      gap: .15em;
      padding: .5em 0;
    }
    .timeline .entry .top-line {
      display: flex;
      align-items: center;
      gap: .35em;
      flex-wrap: wrap;
    }
    .timeline .entry .month { display: inline; font-size: .82em; }
    .timeline .entry .type-cell { display: inline; text-align: left; margin: 0 .2em; }
    .timeline .entry .chips-cell { display: inline-flex; }
    .timeline .entry .name-cell { font-size: .95em; line-height: 1.4; }
  }
</style>

<script>
(function () {
  var SUBJECT_SLUGS = {
    Mathematics: 'math', Computing: 'comp', Physics: 'phys',
    Chemistry: 'chem', Biology: 'bio', Astronomy: 'astro'
  };
  var SUBJECT_ZH = {
    Mathematics: '数学', Computing: '计算', Physics: '物理',
    Chemistry: '化学', Biology: '生物', Astronomy: '天文'
  };
  var MONTH_ZH = {
    'January': '一月', 'February': '二月', 'March': '三月',
    'April': '四月', 'May': '五月', 'June': '六月',
    'July': '七月', 'August': '八月', 'September': '九月',
    'October': '十月', 'November': '十一月', 'December': '十二月'
  };
  function esc(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }

  function chip(subj) {
    var slug = SUBJECT_SLUGS[subj];
    var label = SUBJECT_ZH[subj] || subj;
    return '<span class="chip ' + slug + '">' + label + '</span>';
  }

  function chipsForEntry(e) {
    var subjects = e.subjects || [e.subject];
    return subjects.map(chip).join('');
  }

  function renderTimeline(items, filter) {
    var filtered = filter === 'all'
      ? items
      : items.filter(function (e) {
          var subjects = e.subjects || [e.subject];
          return subjects.some(function (s) { return SUBJECT_SLUGS[s] === filter; });
        });

    filtered.sort(function (a, b) { return b.sort_key.localeCompare(a.sort_key); });

    var years = {};
    var yearOrder = [];
    filtered.forEach(function (e) {
      var y = e.sort_key === '9999-12' ? '未来' : e.sort_key.slice(0, 4);
      if (!years[y]) { years[y] = []; yearOrder.push(y); }
      years[y].push(e);
    });

    var html = '<div class="timeline">';
    yearOrder.forEach(function (y) {
      html += '<div class="year-marker">' + y + '</div>';
      years[y].forEach(function (e) {
        var month = e.date === 'Future' ? '' : e.date.split(' ')[0];
        var monthZh = MONTH_ZH[month] || month;
        var icon = e.type === 'olympiad'
          ? '<svg class="rings-icon" viewBox="0 0 50 24" width="20" height="10"><circle cx="8" cy="8" r="6" fill="none" stroke="#0081C8" stroke-width="1.5"/><circle cx="18" cy="8" r="6" fill="none" stroke="#000" stroke-width="1.5"/><circle cx="28" cy="8" r="6" fill="none" stroke="#EE334E" stroke-width="1.5"/><circle cx="13" cy="14" r="6" fill="none" stroke="#FCB131" stroke-width="1.5"/><circle cx="23" cy="14" r="6" fill="none" stroke="#00A651" stroke-width="1.5"/></svg>'
          : '<span class="type-icon">📖</span>';
        var cls = e.highlighted ? ' hl' : '';
        html += '<div class="entry' + cls + '" data-subject="' + SUBJECT_SLUGS[e.subject] + '">'
          + '<div class="top-line">'
          + '<div class="month">' + monthZh + '</div>'
          + '<div class="type-cell">' + icon + '</div>'
          + '<div class="chips-cell">' + chipsForEntry(e) + '</div>'
          + '</div>'
          + '<div class="name-cell">' + esc(e.name) + (e.invited ? ' <span class="invited-badge">受邀</span>' : '') + '</div>'
          + '</div>';
      });
    });
    html += '</div>';

    document.getElementById('timeline').innerHTML = html;
  }

  fetch('/archives/CONTENT/olympiads.json', { cache: 'no-cache' })
    .then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); })
    .then(function (d) {
      var items = d.items;
      renderTimeline(items, 'all');

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

<div class="footer"><div class="footer-nav"><a href="/archives/CHINESE/curriculum/">课程</a><a href="/archives/CHINESE/olympiads/">竞赛</a><a href="/archives/CHINESE/research/">研究</a></div><a class="footer-github" href="/olympiads/">English</a></div>
