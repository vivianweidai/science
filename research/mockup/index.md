---
layout: default
---

<div class="page-header"><h2>Table Designs</h2><a class="back-link" href="/research/">Research</a></div>

<p style="color:#656d76;font-size:.9em;margin:1em 0;">All five use the same Mathematics data. Scroll to compare.</p>

<div id="mockups"></div>

<script>
(function () {
  function esc(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }

  function badge(toy) {
    var link = toy.project_url || toy.url;
    var name = esc(toy.toy);
    if (link) name = '<a href="' + link + '">' + name + '</a>';
    var icon = toy.available ? ' <span class="mk-avail">&#10003;</span>' : '';
    return { name: name, icon: icon };
  }

  // ── V1: Rounded card, colored left border accent ──
  function renderV1(topics) {
    var html = '<h3 class="mk-label">V1 — Left accent border</h3>';
    topics.forEach(function (topic) {
      html += '<div class="v1-card v1-' + topic.science_slug + '">';
      html += '<div class="v1-header">' + esc(topic.topic) + ' <span class="chip ' + topic.science_slug + '">' + topic.science + '</span></div>';
      html += '<table class="v1-table"><tbody>';
      topic.technologies.forEach(function (tech) {
        html += '<tr class="v1-tech"><td>' + esc(tech.technology) + '</td><td>' + esc(tech.description) + '</td><td></td></tr>';
        tech.toys.forEach(function (toy) {
          var b = badge(toy);
          var cls = toy.highlighted ? ' v1-hl' : '';
          html += '<tr class="v1-toy' + cls + '"><td>' + b.name + '</td><td>' + esc(toy.specs) + '</td><td>' + b.icon + '</td></tr>';
        });
      });
      html += '</tbody></table></div>';
    });
    return html;
  }

  // ── V2: Full rounded border, header bar with science color ──
  function renderV2(topics) {
    var html = '<h3 class="mk-label">V2 — Colored header bar</h3>';
    topics.forEach(function (topic) {
      html += '<div class="v2-card">';
      html += '<div class="v2-header v2-' + topic.science_slug + '">' + esc(topic.topic) + ' <span class="chip ' + topic.science_slug + '" style="background:rgba(255,255,255,.5)">' + topic.science + '</span></div>';
      html += '<table class="v2-table"><tbody>';
      topic.technologies.forEach(function (tech) {
        html += '<tr class="v2-tech"><td>' + esc(tech.technology) + '</td><td>' + esc(tech.description) + '</td><td></td></tr>';
        tech.toys.forEach(function (toy) {
          var b = badge(toy);
          var cls = toy.highlighted ? ' v2-hl' : '';
          html += '<tr class="v2-toy' + cls + '"><td>' + b.name + '</td><td>' + esc(toy.specs) + '</td><td>' + b.icon + '</td></tr>';
        });
      });
      html += '</tbody></table></div>';
    });
    return html;
  }

  // ── V3: Subtle shadow card, no visible border ──
  function renderV3(topics) {
    var html = '<h3 class="mk-label">V3 — Shadow card, no border</h3>';
    topics.forEach(function (topic) {
      html += '<div class="v3-card">';
      html += '<div class="v3-header">' + esc(topic.topic) + ' <span class="chip ' + topic.science_slug + '">' + topic.science + '</span></div>';
      html += '<table class="v3-table"><tbody>';
      topic.technologies.forEach(function (tech) {
        html += '<tr class="v3-tech v3-' + topic.science_slug + '"><td>' + esc(tech.technology) + '</td><td>' + esc(tech.description) + '</td><td></td></tr>';
        tech.toys.forEach(function (toy) {
          var b = badge(toy);
          var cls = toy.highlighted ? ' v3-hl' : '';
          html += '<tr class="v3-toy' + cls + '"><td>' + b.name + '</td><td>' + esc(toy.specs) + '</td><td>' + b.icon + '</td></tr>';
        });
      });
      html += '</tbody></table></div>';
    });
    return html;
  }

  // ── V4: Tight rounded border matching curriculum widget style ──
  function renderV4(topics) {
    var html = '<h3 class="mk-label">V4 — Curriculum-style bordered card</h3>';
    topics.forEach(function (topic) {
      html += '<div class="v4-card">';
      html += '<div class="v4-header v4-' + topic.science_slug + '">' + esc(topic.topic) + '</div>';
      html += '<table class="v4-table"><tbody>';
      topic.technologies.forEach(function (tech) {
        html += '<tr class="v4-tech"><td class="v4-tech-name">' + esc(tech.technology) + '</td><td>' + esc(tech.description) + '</td><td></td></tr>';
        tech.toys.forEach(function (toy) {
          var b = badge(toy);
          var cls = toy.highlighted ? ' v4-hl' : '';
          html += '<tr class="v4-toy' + cls + '"><td>' + b.name + '</td><td>' + esc(toy.specs) + '</td><td>' + b.icon + '</td></tr>';
        });
      });
      html += '</tbody></table></div>';
    });
    return html;
  }

  // ── V5: Minimal — just grouped rows with subtle separator lines ──
  function renderV5(topics) {
    var html = '<h3 class="mk-label">V5 — Minimal grouped rows</h3>';
    topics.forEach(function (topic) {
      html += '<div class="v5-section">';
      html += '<div class="v5-header">' + esc(topic.topic) + ' <span class="chip ' + topic.science_slug + '">' + topic.science + '</span></div>';
      html += '<div class="v5-body">';
      topic.technologies.forEach(function (tech) {
        html += '<div class="v5-group">';
        html += '<div class="v5-tech v5-' + topic.science_slug + '"><span class="v5-tech-name">' + esc(tech.technology) + '</span><span class="v5-tech-desc">' + esc(tech.description) + '</span></div>';
        tech.toys.forEach(function (toy) {
          var b = badge(toy);
          var cls = toy.highlighted ? ' v5-hl' : '';
          html += '<div class="v5-toy' + cls + '"><span class="v5-toy-name">' + b.name + b.icon + '</span><span class="v5-toy-specs">' + esc(toy.specs) + '</span></div>';
        });
        html += '</div>';
      });
      html += '</div></div>';
    });
    return html;
  }

  fetch('../../archives/CONTENT/toys.json', { cache: 'no-cache' })
    .then(function (r) { return r.json(); })
    .then(function (d) {
      var math = d.topics.filter(function(t){ return t.science_slug === 'math'; });
      document.getElementById('mockups').innerHTML =
        renderV1(math) + '<hr>' +
        renderV2(math) + '<hr>' +
        renderV3(math) + '<hr>' +
        renderV4(math) + '<hr>' +
        renderV5(math);
    });
})();
</script>

<style>
.mk-label { margin: 1.5em 0 .5em; color: #656d76; font-size: 1.05em; }
.mk-avail { color: #1a7f37; font-size: .85em; }
.chip { display: inline-block; padding: 1px 7px; border-radius: 999px; font-size: .72em; font-weight: 600; color: #1f2328; white-space: nowrap; line-height: 1.6; vertical-align: middle; margin-left: .3em; }
.chip.math { background: var(--subj-math); }
.chip.comp { background: var(--subj-comp); }
.chip.phys { background: var(--subj-phys); }
.chip.chem { background: var(--subj-chem); }
.chip.bio  { background: var(--subj-bio); }
.chip.astro { background: var(--subj-astro); }

/* Shared table resets */
.v1-table, .v2-table, .v3-table, .v4-table { width: 100%; border-collapse: collapse; font-size: .95em; }
.v1-table td, .v2-table td, .v3-table td, .v4-table td { padding: .45em .7em; vertical-align: middle; border: none; color: #1f2328; }
.v1-table a, .v2-table a, .v3-table a, .v4-table a, .v5-toy-name a { color: #0969da; text-decoration: none; font-weight: 600; }
.v1-table a:hover, .v2-table a:hover, .v3-table a:hover, .v4-table a:hover, .v5-toy-name a:hover { text-decoration: underline; }

/* First col width */
.v1-table td:first-child, .v2-table td:first-child, .v3-table td:first-child, .v4-table td:first-child { width: 25%; }
/* Access col */
.v1-table td:last-child, .v2-table td:last-child, .v3-table td:last-child, .v4-table td:last-child { width: 2em; text-align: center; }

/* ── V1: Left accent ── */
.v1-card {
  border: 1px solid #d1d9e0;
  border-left: 4px solid #d1d9e0;
  border-radius: 8px;
  margin: 1em 0;
  overflow: hidden;
  background: #fff;
}
.v1-math { border-left-color: #6ba3e8; }
.v1-header { font-weight: 700; font-size: 1em; padding: .6em .8em; border-bottom: 1px solid #eaecef; }
.v1-tech td { font-weight: 700; font-size: .95em; background: #f6f8fa; border-bottom: 1px solid #eaecef; }
.v1-toy td:first-child { padding-left: 1.6em; }
.v1-hl td { background: #fffde7; }

/* ── V2: Colored header bar ── */
.v2-card {
  border: 1px solid #d1d9e0;
  border-radius: 8px;
  margin: 1em 0;
  overflow: hidden;
  background: #fff;
}
.v2-header {
  font-weight: 700; font-size: 1em;
  padding: .55em .8em;
  border-bottom: 1px solid #d1d9e0;
}
.v2-math { background: var(--subj-math); }
.v2-tech td { font-weight: 700; background: var(--subj-math); opacity: .7; border-bottom: 1px solid #d1d9e0; }
.v2-toy td:first-child { padding-left: 1.6em; }
.v2-hl td { background: #fffde7; }

/* ── V3: Shadow card ── */
.v3-card {
  border-radius: 10px;
  margin: 1em 0;
  overflow: hidden;
  background: #fff;
  box-shadow: 0 1px 4px rgba(0,0,0,.08), 0 0 1px rgba(0,0,0,.1);
}
.v3-header { font-weight: 700; font-size: 1em; padding: .6em .8em; border-bottom: 1px solid #f0f0f0; }
.v3-tech td { font-weight: 700; }
.v3-math td { background: var(--subj-math); }
.v3-toy td:first-child { padding-left: 1.6em; }
.v3-hl td { background: #fffde7; }

/* ── V4: Curriculum-style bordered ── */
.v4-card {
  border: 1px solid #d1d9e0;
  border-radius: 8px;
  margin: 1em 0;
  overflow: hidden;
  background: #fff;
}
.v4-header {
  font-weight: 700; font-size: .95em; text-align: center;
  padding: .55em .7em;
  border-bottom: 1px solid #d1d9e0;
}
.v4-math { background: var(--subj-math); }
.v4-tech td {
  border-bottom: 1px solid #d1d9e0;
  background: #f0f2f4;
  font-weight: 700;
}
.v4-tech-name { font-size: .95em; }
.v4-toy td { border-bottom: 1px solid #eaecef; }
.v4-toy:last-child td { border-bottom: none; }
.v4-toy td:first-child { padding-left: 1.6em; }
.v4-hl td { background: #fffde7 !important; }

/* ── V5: Minimal grouped rows ── */
.v5-section { margin: 1.2em 0; }
.v5-header {
  font-weight: 700; font-size: 1em;
  padding-bottom: .25em;
  border-bottom: 2px solid #d1d9e0;
  margin-bottom: .3em;
}
.v5-group { margin-bottom: .1em; }
.v5-tech {
  display: flex; gap: .8em; align-items: baseline;
  padding: .4em .5em;
  font-size: .95em;
  border-radius: 4px;
}
.v5-math { background: var(--subj-math); }
.v5-tech-name { font-weight: 700; white-space: nowrap; }
.v5-tech-desc { color: #1f2328; }
.v5-toy {
  display: flex; gap: .8em; align-items: baseline;
  padding: .35em .5em .35em 1.6em;
  font-size: .95em;
}
.v5-hl { background: #fffde7; border-radius: 4px; }
.v5-toy-name { white-space: nowrap; min-width: 22%; }
.v5-toy-specs { color: #1f2328; }
</style>

---

<div class="footer"><a class="footer-github" href="/research/">Research</a><div class="footer-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a class="active" href="/research/">Research</a></div></div>
