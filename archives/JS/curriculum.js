/* Curriculum widget.
 *
 * Loads archives/curriculum_manifest.json (built by
 * scripts/build_curriculum_manifest.py) and renders a 6-column grid of
 * subjects -> sections -> topics. Clicking a topic drills into a single
 * view that fetches the raw markdown files for that topic's tables from
 * GitHub raw, renders them with marked + KaTeX, and provides breadcrumb
 * and prev/next navigation within the same section.
 */
(function () {
  var widget = document.getElementById('curriculum-widget');
  if (!widget) return;

  var RAW_BASE = 'https://raw.githubusercontent.com/vivianweidai/science/main/curriculum/';
  var MANIFEST_URL = '/archives/curriculum_manifest.json';

  var manifest = null;
  var state = { view: 'grid' };

  widget.classList.add('curr-widget');
  widget.innerHTML = '<div class="curr-loading">Loading curriculum…</div>';

  fetch(MANIFEST_URL)
    .then(function (r) { return r.json(); })
    .then(function (m) { manifest = m; render(); })
    .catch(function (e) {
      widget.innerHTML = '<div class="curr-loading">Failed to load curriculum: ' + e + '</div>';
    });

  function render() {
    if (state.view === 'topic') renderTopic();
    else renderGrid();
  }

  function renderGrid() {
    var subjects = ['mathematics', 'computing', 'physics', 'chemistry', 'biology', 'astronomy'];
    var html = '<div class="curr-grid">';
    subjects.forEach(function (subjSlug) {
      var subj = manifest[subjSlug];
      if (!subj) return;
      html += '<div class="curr-col">';
      html += '<div class="curr-col-head">' + escapeHtml(subj.name) + '</div>';
      subj.sections.forEach(function (sec, secIdx) {
        html += '<div class="curr-section">';
        html += '<div class="curr-section-name">' + escapeHtml(sec.name) + '</div>';
        html += '<ul>';
        sec.topics.forEach(function (topic, topicIdx) {
          html += '<li><a href="#" data-subj="' + subjSlug
               + '" data-sec="' + secIdx
               + '" data-topic="' + topicIdx + '">'
               + escapeHtml(topic.name.toLowerCase()) + '</a></li>';
        });
        html += '</ul></div>';
      });
      html += '</div>';
    });
    html += '</div>';
    widget.innerHTML = html;

    widget.querySelectorAll('.curr-section a').forEach(function (a) {
      a.addEventListener('click', function (e) {
        e.preventDefault();
        state = {
          view: 'topic',
          subject: a.dataset.subj,
          sectionIdx: parseInt(a.dataset.sec, 10),
          topicIdx: parseInt(a.dataset.topic, 10),
        };
        render();
        scrollToWidget();
      });
    });
  }

  function renderTopic() {
    var subj = manifest[state.subject];
    var sec = subj.sections[state.sectionIdx];
    var topic = sec.topics[state.topicIdx];

    var html = '<div class="curr-topic">';
    html += '<div class="curr-breadcrumb">'
         + '<a href="#" data-action="grid">All Subjects</a>'
         + '<span class="sep">/</span>' + escapeHtml(subj.name)
         + '<span class="sep">/</span>' + escapeHtml(sec.name)
         + '<span class="sep">/</span><strong>' + escapeHtml(topic.name) + '</strong>'
         + '</div>';
    html += '<div class="curr-topic-body"><div class="curr-loading">Loading…</div></div>';
    html += '<div class="curr-prevnext"></div>';
    html += '</div>';
    widget.innerHTML = html;

    // Fetch all tables for this topic in parallel, then render in order.
    var fetches = topic.tables.map(function (t) {
      return fetch(RAW_BASE + t.path)
        .then(function (r) { return r.text(); })
        .then(function (raw) { return stripFrontMatter(raw); });
    });

    Promise.all(fetches).then(function (bodies) {
      var body = widget.querySelector('.curr-topic-body');
      body.innerHTML = bodies.map(function (md) { return marked.parse(md); }).join('\n');
      whenKatexReady(function () {
        window.renderMathInElement(body, {
          delimiters: [
            { left: '$$', right: '$$', display: true },
            { left: '$',  right: '$',  display: false }
          ],
          throwOnError: false
        });
      });
    }).catch(function (e) {
      widget.querySelector('.curr-topic-body').innerHTML =
        '<div class="curr-loading">Failed to load topic: ' + e + '</div>';
    });

    // Breadcrumb click
    widget.querySelector('[data-action="grid"]').addEventListener('click', function (e) {
      e.preventDefault();
      state = { view: 'grid' };
      render();
      scrollToWidget();
    });

    // Prev/next within the section (flat topic list).
    var nav = widget.querySelector('.curr-prevnext');
    var prevTopic = state.topicIdx > 0 ? sec.topics[state.topicIdx - 1] : null;
    var nextTopic = state.topicIdx < sec.topics.length - 1 ? sec.topics[state.topicIdx + 1] : null;
    nav.innerHTML =
      (prevTopic
        ? '<a href="#" data-action="prev">← ' + escapeHtml(prevTopic.name) + '</a>'
        : '<span class="spacer">·</span>')
      + (nextTopic
        ? '<a href="#" data-action="next">' + escapeHtml(nextTopic.name) + ' →</a>'
        : '<span class="spacer">·</span>');
    nav.querySelectorAll('a').forEach(function (a) {
      a.addEventListener('click', function (e) {
        e.preventDefault();
        if (a.dataset.action === 'prev') state.topicIdx -= 1;
        else if (a.dataset.action === 'next') state.topicIdx += 1;
        render();
        scrollToWidget();
      });
    });
  }

  function whenKatexReady(cb) {
    if (window.renderMathInElement) return cb();
    var tries = 0;
    var id = setInterval(function () {
      tries += 1;
      if (window.renderMathInElement || tries > 100) {
        clearInterval(id);
        if (window.renderMathInElement) cb();
      }
    }, 50);
  }

  function stripFrontMatter(text) {
    return text.replace(/^---\n[\s\S]*?\n---\n?/, '');
  }

  function escapeHtml(s) {
    return String(s)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function scrollToWidget() {
    var top = widget.getBoundingClientRect().top + window.scrollY - 20;
    window.scrollTo({ top: top, behavior: 'instant' in Element.prototype ? 'instant' : 'auto' });
  }
})();
