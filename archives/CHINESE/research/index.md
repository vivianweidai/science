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
      var saved = sessionStorage.getItem('res-tab-zh');
      var pick = saved && document.getElementById('toys-' + saved) ? 'toys-' + saved
        : picks[Math.floor(Math.random() * picks.length)];
      document.getElementById(pick).checked = true;
      sessionStorage.setItem('res-tab-zh', pick.replace('toys-', ''));
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
  var SCIENCE_ZH = {
    'Mathematics': '数学',
    'Computing': '计算',
    'Physics': '物理',
    'Chemistry': '化学',
    'Biology': '生物',
    'Astronomy': '天文'
  };

  function esc(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }

  function renderToys(topics, filter) {
    var filtered = filter === 'all'
      ? topics
      : topics.filter(function (t) { return t.science_slug === filter; });

    if (!filtered.length) {
      document.getElementById('toys-content').innerHTML =
        '<p style="color:#656d76;font-style:italic;margin:1em 0;">暂无内容。</p>';
      return;
    }

    var html = '';
    filtered.forEach(function (topic) {
      var sci = SCIENCE_ZH[topic.science] || topic.science;
      html += '<div class="toys-card toys-accent-' + topic.science_slug + '">';
      html += '<div class="toys-card-header">'
        + '<span class="toys-topic-title">' + esc(topic.topic)
        + ' <span class="chip ' + topic.science_slug + '">' + sci + '</span></span>'
        + '<span class="toys-topic-desc">' + esc(topic.description || '') + '</span>'
        + '</div>';
      html += '<table class="toys-table"><colgroup><col style="width:28%"><col><col style="width:2em"></colgroup><tbody>';

      topic.technologies.forEach(function (tech) {
        html += '<tr class="toys-tech-row">'
          + '<td style="padding-left:1.4em;font-weight:700">' + esc(tech.technology) + '</td>'
          + '<td class="toys-tech-desc" colspan="2">' + esc(tech.description) + '</td>'
          + '</tr>';

        tech.toys.forEach(function (toy) {
          var name = esc(toy.toy);
          var link = toy.project_url || toy.url;
          if (link) name = '<a href="' + link + '">' + name + '</a>';
          if (toy.url) {
            var icon = '';
            var iconTitle = '';
            if (/\.(jpg|jpeg|png|gif)$/i.test(toy.url)) {
              icon = '\uD83D\uDCF7';
              iconTitle = '照片';
            } else if (/wolframcloud\.com|\.nb($|\?)/i.test(toy.url)) {
              icon = '\uD83D\uDCD3';
              iconTitle = 'Wolfram 笔记本';
            } else if (/colab\.research|\.ipynb($|\?)/i.test(toy.url)) {
              icon = '\uD83D\uDCD3';
              iconTitle = 'Colab 笔记本';
            } else if (/github\.com/i.test(toy.url)) {
              icon = '\uD83D\uDC19';
              iconTitle = 'GitHub';
            }
            if (icon) name += ' <span class="toys-wip" title="' + iconTitle + '">' + icon + '</span>';
          }
          var access = toy.available ? '<span class="toys-avail">&#10003;</span>' : '';

          html += '<tr class="toys-toy-row">'
            + '<td style="padding-left:2.8em">' + name + '</td>'
            + '<td class="toys-toy-specs">' + esc(toy.specs) + '</td>'
            + '<td class="toys-toy-access">' + access + '</td>'
            + '</tr>';
        });
      });

      html += '</tbody></table></div>';
    });

    document.getElementById('toys-content').innerHTML = html;
  }

  fetch('/archives/CONTENT/toys.json', { cache: 'no-cache' })
    .then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); })
    .then(function (d) {
      var topics = d.topics;
      var checked = document.querySelector('input[name="toys-view"]:checked');
      renderToys(topics, checked ? checked.id.replace('toys-', '') : 'all');
      document.querySelectorAll('input[name="toys-view"]').forEach(function (r) {
        r.addEventListener('change', function () {
          var filter = this.id.replace('toys-', '');
          sessionStorage.setItem('res-tab-zh', filter);
          renderToys(topics, filter);
        });
      });
    });
})();
</script>

<style>
  .toys-card {
    border: 1px solid #d1d9e0;
    border-left: 4px solid #d1d9e0;
    border-radius: 8px;
    margin: 1em 0;
    overflow: hidden;
    background: #fff;
  }
  .toys-accent-math  { border-left-color: #6ba3e8; }
  .toys-accent-comp  { border-left-color: #9b7ed8; }
  .toys-accent-phys  { border-left-color: #e8915a; }
  .toys-accent-chem  { border-left-color: #8db849; }
  .toys-accent-bio   { border-left-color: #5bbfb0; }
  .toys-accent-astro { border-left-color: #e86088; }

  .toys-card-header {
    font-weight: 700;
    font-size: 1em;
    padding: .6em .8em;
    border-bottom: 1px solid #eaecef;
    color: #1f2328;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 1em;
  }
  .toys-card-header .chip { vertical-align: middle; margin-left: .3em; position: relative; top: -.1em; }
  .toys-topic-title { white-space: nowrap; flex-shrink: 0; }
  .toys-topic-desc {
    font-weight: 400;
    font-size: .9em;
    color: #fff;
    -webkit-text-fill-color: #fff;
    transition: color .2s ease, -webkit-text-fill-color .2s ease;
    text-align: right;
    min-width: 0;
  }
  .toys-card-header:hover .toys-topic-desc {
    color: #1f2328;
    -webkit-text-fill-color: #1f2328;
  }

  .toys-table {
    width: 100%;
    border-collapse: collapse;
    font-size: .95em;
    table-layout: fixed;
  }
  .toys-table td {
    padding: .4em .7em;
    vertical-align: middle;
    border: none;
    color: #1f2328;
  }

  .toys-tech-row td {
    background: #f6f8fa;
    border-bottom: 1px solid #eaecef;
    padding-top: .4em;
    padding-bottom: .4em;
  }
  .toys-tech-desc {
    font-weight: 400;
    color: #f6f8fa;
    -webkit-text-fill-color: #f6f8fa;
    transition: color .2s ease, -webkit-text-fill-color .2s ease;
    text-align: right;
  }
  .toys-tech-row:hover .toys-tech-desc {
    color: #1f2328;
    -webkit-text-fill-color: #1f2328;
  }

  .toys-toy-row td:first-child a { color: #0969da; text-decoration: none; font-weight: 600; }
  .toys-toy-row td:first-child a:hover { text-decoration: underline; }
  .toys-toy-specs { color: #1f2328; }
  .toys-toy-access { width: 2em; text-align: center; }

  .toys-avail { color: #1a7f37; font-size: .85em; }

  .toys-wip {
    font-size: .8em;
    margin-left: .3em;
    display: inline-block;
    position: relative;
    top: -0.1em;
  }

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
    .tabs .tab-labels label { padding: 0.45em 0.7em; font-size: 0.8em; }
    .toys-card-header { padding-left: .7em; }
    .toys-topic-desc { display: none; }
    .toys-table { table-layout: auto; }
    .toys-table colgroup { display: none; }
    .toys-table td { display: block; padding: .2em .7em; }
    .toys-tech-row td { display: block; padding: .7em !important; font-size: 1em; }
    .toys-tech-desc { display: none !important; }
    .toys-toy-row td:first-child {
      padding: .4em .7em 0 .7em !important;
    }
    .toys-toy-specs {
      padding: 0 .7em .4em .7em;
      font-size: .88em;
      color: #656d76;
    }
    .toys-toy-access { display: none !important; height: 0; padding: 0 !important; margin: 0; overflow: hidden; }
    tr.toys-toy-row { border-bottom: 1px solid #f0f0f0; }
    tr.toys-toy-row:last-child { border-bottom: none; }
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

<div class="footer"><a class="footer-github" href="/archives/CHINESE/">科学</a><div class="footer-nav"><a href="/archives/CHINESE/curriculum/">课程</a><a href="/archives/CHINESE/olympiads/">竞赛</a><a class="active" href="/archives/CHINESE/research/">研究</a></div></div>
