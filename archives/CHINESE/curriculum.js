/* Chinese Curriculum widget.
 *
 * Identical to archives/LAYOUT/curriculum.js but with Chinese UI labels.
 * Loads the same archives/CONTENT/curriculum.json data and renders a
 * 6-column grid with Chinese subject names and navigation text.
 * Scientific/mathematical content remains in its original language.
 */
(function () {
  var widget = document.getElementById('curriculum-widget');
  if (!widget) return;

  var RAW_BASE = 'https://raw.githubusercontent.com/vivianweidai/science/main/curriculum/';
  var MANIFEST_URL = '/archives/CONTENT/curriculum.json';

  var SUBJECT_NAMES_ZH = {
    'Mathematics': '数学',
    'Computing': '计算',
    'Physics': '物理',
    'Chemistry': '化学',
    'Biology': '生物',
    'Astronomy': '天文'
  };

  var manifest = null;
  var state = { view: 'grid' };

  widget.classList.add('curr-widget');
  widget.innerHTML = '<div class="curr-loading">正在加载课程……</div>';

  fetch(MANIFEST_URL)
    .then(function (r) { return r.json(); })
    .then(function (m) { manifest = m; render(); })
    .catch(function (e) {
      widget.innerHTML = '<div class="curr-loading">加载课程失败：' + e + '</div>';
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
      var zhName = SUBJECT_NAMES_ZH[subj.name] || subj.name;
      html += '<div class="curr-col">';
      html += '<div class="curr-col-head">' + escapeHtml(zhName) + '</div>';
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
        var y = window.scrollY;
        render();
        requestAnimationFrame(function () { window.scrollTo(0, y); });
      });
    });
  }

  function renderTopic() {
    var subj = manifest[state.subject];
    var sec = subj.sections[state.sectionIdx];
    var topic = sec.topics[state.topicIdx];
    var zhSubjName = SUBJECT_NAMES_ZH[subj.name] || subj.name;

    var html = '<div class="curr-topic">';
    html += '<div class="curr-breadcrumb">'
         + '<a href="#" data-action="grid">所有学科</a>'
         + '<span class="sep">/</span>' + escapeHtml(zhSubjName)
         + '<span class="sep">/</span>' + escapeHtml(sec.name)
         + '<span class="sep">/</span><strong>' + escapeHtml(topic.name) + '</strong>'
         + '</div>';
    html += '<div class="curr-topic-body"><div class="curr-loading">正在加载……</div></div>';
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
      body.innerHTML = '';
      bodies.forEach(function (md, i) {
        var wrap = document.createElement('div');
        wrap.className = 'curr-table-wrap';
        wrap.innerHTML = marked.parse(md);
        applyHighlights(wrap, topic.tables[i].highlighted_rows || []);
        body.appendChild(wrap);
      });
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
        '<div class="curr-loading">加载主题失败：' + e + '</div>';
    });

    // Breadcrumb click
    widget.querySelector('[data-action="grid"]').addEventListener('click', function (e) {
      e.preventDefault();
      state = { view: 'grid' };
      render();
      scrollToWidget();
    });

    // Prev/next within the section
    var nav = widget.querySelector('.curr-prevnext');
    var prevTopic = state.topicIdx > 0 ? sec.topics[state.topicIdx - 1] : null;
    var nextTopic = state.topicIdx < sec.topics.length - 1 ? sec.topics[state.topicIdx + 1] : null;
    nav.innerHTML =
      (prevTopic
        ? '<a href="#" data-action="prev">\u2190 ' + escapeHtml(prevTopic.name) + '</a>'
        : '<span class="spacer">\u00b7</span>')
      + (nextTopic
        ? '<a href="#" data-action="next">' + escapeHtml(nextTopic.name) + ' \u2192</a>'
        : '<span class="spacer">\u00b7</span>');
    nav.querySelectorAll('a').forEach(function (a) {
      a.addEventListener('click', function (e) {
        e.preventDefault();
        if (a.dataset.action === 'prev') state.topicIdx -= 1;
        else if (a.dataset.action === 'next') state.topicIdx += 1;
        var y = window.scrollY;
        render();
        requestAnimationFrame(function () { window.scrollTo(0, y); });
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

  function applyHighlights(container, rowIndices) {
    if (!rowIndices || !rowIndices.length) return;
    var set = {};
    rowIndices.forEach(function (i) { set[i] = true; });
    var tables = container.querySelectorAll('table');
    tables.forEach(function (table) {
      var rows = table.querySelectorAll('tr');
      var dataIdx = 0;
      rows.forEach(function (tr) {
        if (tr.querySelector('td')) {
          if (set[dataIdx]) tr.classList.add('highlight');
          dataIdx += 1;
        }
      });
    });
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
    widget.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

})();
