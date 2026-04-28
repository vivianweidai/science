/* Curriculum widget.
 *
 * Loads archives/truth/curriculum.json (built by
 * archives/layout/build_curriculum.py) and renders a 6-column grid of
 * subjects -> sections -> topics. Clicking a topic drills into a single
 * view that fetches the raw markdown files for that topic's tables from
 * GitHub raw, renders them with marked + KaTeX, and provides breadcrumb
 * and prev/next navigation within the same section.
 *
 * Row highlighting is applied at runtime from each table entry's
 * `highlighted_rows` array (data-row indices, skipping the header row)
 * rather than being baked into the curriculum markdown.
 */
(function () {
  var widget = document.getElementById('curriculum-widget');
  if (!widget) return;

  var RAW_BASE = 'https://vivianweidai.com/curriculum/source/';
  var MANIFEST_URL = '/curriculum/curriculum.json';

  var manifest = null;
  var pendingHash = parseHash();
  var state = { view: 'grid' };

  widget.classList.add('curr-widget');
  widget.innerHTML = '<div class="curr-loading">Loading curriculum…</div>';

  fetch(MANIFEST_URL)
    .then(function (r) { return r.json(); })
    .then(function (m) {
      manifest = m;
      if (pendingHash) state = resolveState(pendingHash);
      pendingHash = null;
      render();
    })
    .catch(function (e) {
      widget.innerHTML = '<div class="curr-loading">Failed to load curriculum: ' + e + '</div>';
    });

  window.addEventListener('popstate', function () {
    var raw = parseHash();
    state = raw && manifest ? resolveState(raw) : (raw || { view: 'grid' });
    if (manifest) render();
  });

  function pushState() {
    var hash = '#';
    if (state.view === 'subject') {
      hash += state.subject;
      if (state.highlightSectionIdx != null) {
        var hsec = manifest[state.subject].sections[state.highlightSectionIdx];
        hash += '/' + slugify(hsec.name);
      }
    } else if (state.view === 'topic') {
      var sec2 = manifest[state.subject].sections[state.sectionIdx];
      var topic = sec2.topics[state.topicIdx];
      hash += state.subject + '/' + slugify(sec2.name) + '/' + slugify(topic.name);
    } else hash = '#';
    if (location.hash !== hash) history.pushState(null, '', hash);
  }

  /* parseHash returns RAW slug-or-number tokens. Numeric → index lookup;
     slug → name match. Resolved into actual indices by resolveState once
     the manifest has loaded.
     - 1 part:  subject view (no highlight)
     - 2 parts: subject view with that section highlighted (clicked section
                names land here so users see the broader subject context
                instead of a cramped section-only view).
     - 3 parts: topic table view (clicked leaf topics land here). */
  function parseHash() {
    var h = location.hash.replace(/^#/, '');
    if (!h) return null;
    var parts = h.split('/').map(decodeURIComponent);
    if (parts.length === 1) return { view: 'subject', subject: parts[0] };
    if (parts.length === 2) return { view: 'subject', subject: parts[0], highlightSection: parts[1] };
    if (parts.length === 3) return { view: 'topic', subject: parts[0], section: parts[1], topic: parts[2] };
    return null;
  }

  function resolveState(raw) {
    if (raw.view === 'subject') {
      var subj0 = manifest[raw.subject];
      if (!subj0) return { view: 'grid' };
      if (!raw.highlightSection) return { view: 'subject', subject: raw.subject };
      var hIdx = lookupIdx(subj0.sections, raw.highlightSection);
      if (hIdx < 0) return { view: 'subject', subject: raw.subject };
      return { view: 'subject', subject: raw.subject, highlightSectionIdx: hIdx };
    }
    var subj = manifest[raw.subject];
    if (!subj) return { view: 'grid' };
    var sectionIdx = lookupIdx(subj.sections, raw.section);
    if (sectionIdx < 0) return { view: 'grid' };
    var topicIdx = lookupIdx(subj.sections[sectionIdx].topics, raw.topic);
    if (topicIdx < 0) return { view: 'grid' };
    return { view: 'topic', subject: raw.subject, sectionIdx: sectionIdx, topicIdx: topicIdx };
  }

  /* Resolve a raw URL token to an index in the given list of {name} objects.
     Pure digits → numeric index (legacy URLs); otherwise slug match. */
  function lookupIdx(list, key) {
    if (/^\d+$/.test(key)) {
      var n = parseInt(key, 10);
      return n >= 0 && n < list.length ? n : -1;
    }
    for (var i = 0; i < list.length; i++) {
      if (slugify(list[i].name) === key) return i;
    }
    return -1;
  }

  function slugify(s) {
    return String(s).toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }

  function render() {
    pushState();
    if (state.view === 'topic') renderTopic();
    else if (state.view === 'subject') renderSubject();
    else renderGrid();
  }

  function renderGrid() {
    var subjects = ['mathematics', 'computing', 'physics', 'chemistry', 'biology', 'astronomy'];
    var html = '<div class="curr-grid">';
    subjects.forEach(function (subjSlug, i) {
      var subj = manifest[subjSlug];
      if (!subj) return;
      html += '<div class="curr-col fade-in" style="animation-delay:' + (i * 0.06).toFixed(2) + 's">';
      html += '<div class="curr-col-head" data-subj="' + subjSlug + '">' + escapeHtml(subj.name) + '</div>';
      subj.sections.forEach(function (sec, secIdx) {
        html += '<div class="curr-section">';
        html += '<div class="curr-section-name" data-subj="' + subjSlug + '" data-sec="' + secIdx + '">' + escapeHtml(sec.name) + '</div>';
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
      });
    });

    widget.querySelectorAll('.curr-col-head').forEach(function (h) {
      h.addEventListener('click', function () {
        state = { view: 'subject', subject: h.dataset.subj };
        render();
      });
    });

    widget.querySelectorAll('.curr-section-name').forEach(function (s) {
      s.addEventListener('click', function () {
        state = {
          view: 'subject',
          subject: s.dataset.subj,
          highlightSectionIdx: parseInt(s.dataset.sec, 10),
        };
        render();
      });
    });
  }


  function renderSubject() {
    var subj = manifest[state.subject];
    var hasHighlight = state.highlightSectionIdx != null;
    var html = '<div class="curr-subject">';
    html += '<div class="curr-breadcrumb" data-subj="' + state.subject + '">'
         + '<a href="#" data-action="grid">Science</a>'
         + '<span class="sep">/</span>'
         + (hasHighlight
           ? '<a href="#" data-action="subject">' + escapeHtml(subj.name) + '</a>'
             + '<span class="sep">/</span><strong>'
             + escapeHtml(subj.sections[state.highlightSectionIdx].name) + '</strong>'
           : '<strong>' + escapeHtml(subj.name) + '</strong>')
         + '</div>';
    html += '<div class="curr-subject-sections">';
    subj.sections.forEach(function (sec, secIdx) {
      var hl = state.highlightSectionIdx === secIdx ? ' curr-section-highlighted' : '';
      html += '<div class="curr-section fade-in' + hl + '" data-secidx="' + secIdx + '" style="animation-delay:' + (secIdx * 0.05).toFixed(2) + 's">';
      html += '<div class="curr-section-name" data-subj="' + state.subject + '" data-sec="' + secIdx + '">' + escapeHtml(sec.name) + '</div>';
      html += '<ul>';
      sec.topics.forEach(function (topic, topicIdx) {
        html += '<li><a href="#" data-subj="' + state.subject
             + '" data-sec="' + secIdx
             + '" data-topic="' + topicIdx + '">'
             + escapeHtml(topic.name.toLowerCase()) + '</a></li>';
      });
      html += '</ul></div>';
    });
    html += '</div></div>';
    widget.innerHTML = html;

    widget.querySelector('[data-action="grid"]').addEventListener('click', function (e) {
      e.preventDefault();
      state = { view: 'grid' };
      render();
    });

    var subjectLink = widget.querySelector('[data-action="subject"]');
    if (subjectLink) {
      subjectLink.addEventListener('click', function (e) {
        e.preventDefault();
        state = { view: 'subject', subject: state.subject };
        render();
      });
    }

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
      });
    });

    widget.querySelectorAll('.curr-section-name').forEach(function (s) {
      s.addEventListener('click', function () {
        state = {
          view: 'subject',
          subject: s.dataset.subj,
          highlightSectionIdx: parseInt(s.dataset.sec, 10),
        };
        render();
      });
    });

    if (state.highlightSectionIdx != null) {
      var target = widget.querySelector('.curr-section-highlighted');
      if (target) {
        requestAnimationFrame(function () {
          target.scrollIntoView({ behavior: 'smooth', block: 'center' });
        });
      }
    }
  }

  function renderTopic() {
    var subj = manifest[state.subject];
    var sec = subj.sections[state.sectionIdx];
    var topic = sec.topics[state.topicIdx];

    var html = '<div class="curr-topic fade-in">';
    html += '<div class="curr-breadcrumb" data-subj="' + state.subject + '">'
         + '<a href="#" data-action="grid">Science</a>'
         + '<span class="sep">/</span><a href="#" data-action="subject">' + escapeHtml(subj.name) + '</a>'
         + '<span class="sep">/</span><a href="#" data-action="section-view">' + escapeHtml(sec.name) + '</a>'
         + '<span class="sep">/</span><strong>' + escapeHtml(topic.name) + '</strong>'
         + '</div>';
    html += '<div class="curr-prevnext curr-prevnext-top"></div>';
    html += '<div class="curr-topic-body"><div class="curr-loading">Loading…</div></div>';
    html += '<div class="curr-prevnext curr-prevnext-bottom"></div>';
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
      // Render each table's markdown separately into its own container so
      // we can apply per-table highlight rows before concatenating into
      // the topic body.
      body.innerHTML = '';
      bodies.forEach(function (md, i) {
        var wrap = document.createElement('div');
        wrap.className = 'curr-table-wrap';
        wrap.innerHTML = marked.parse(md);
        applyHighlights(wrap, topic.tables[i].highlighted_rows || []);
        mergeHeaders(wrap);
        mergeFirstColumn(wrap);
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
        '<div class="curr-loading">Failed to load topic: ' + e + '</div>';
    });

    // Breadcrumb clicks
    widget.querySelector('[data-action="grid"]').addEventListener('click', function (e) {
      e.preventDefault();
      state = { view: 'grid' };
      render();
    });
    widget.querySelector('[data-action="subject"]').addEventListener('click', function (e) {
      e.preventDefault();
      state = { view: 'subject', subject: state.subject };
      render();
      scrollToWidget();
    });
    widget.querySelector('[data-action="section-view"]').addEventListener('click', function (e) {
      e.preventDefault();
      state = {
        view: 'subject',
        subject: state.subject,
        highlightSectionIdx: state.sectionIdx,
      };
      render();
    });

    // Prev/next within the section (flat topic list).
    var prevTopic = state.topicIdx > 0 ? sec.topics[state.topicIdx - 1] : null;
    var nextTopic = state.topicIdx < sec.topics.length - 1 ? sec.topics[state.topicIdx + 1] : null;
    var navHtml =
      (prevTopic
        ? '<a href="#" data-action="prev">← ' + escapeHtml(prevTopic.name) + '</a>'
        : '<span class="spacer">·</span>')
      + (nextTopic
        ? '<a href="#" data-action="next">' + escapeHtml(nextTopic.name) + ' →</a>'
        : '<span class="spacer">·</span>');
    widget.querySelectorAll('.curr-prevnext').forEach(function (nav) {
      nav.innerHTML = navHtml;
      nav.querySelectorAll('a').forEach(function (a) {
        a.addEventListener('click', function (e) {
          e.preventDefault();
          if (a.dataset.action === 'prev') state.topicIdx -= 1;
          else if (a.dataset.action === 'next') state.topicIdx += 1;
          render();
          scrollToWidget();
        });
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
    // The curriculum markdown uses a single <table> per file. Walk its
    // data rows (rows with <td>, i.e. skipping <th> header rows) and
    // add `highlight` to the ones whose data index is in the set.
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

  function mergeHeaders(container) {
    // Replace the 3-column header row with a single merged cell
    // using the table name from the h1 above the table.
    var h1 = container.querySelector('h1');
    var table = container.querySelector('table');
    if (!h1 || !table) return;
    var name = h1.textContent.trim();
    var headerRow = table.querySelector('tr');
    if (headerRow && headerRow.querySelector('th')) {
      headerRow.innerHTML = '<th colspan="3">' + escapeHtml(name) + '</th>';
    }
  }

  function mergeFirstColumn(container) {
    var tables = container.querySelectorAll('table');
    tables.forEach(function (table) {
      var rows = table.querySelectorAll('tr');
      var dataRows = [];
      rows.forEach(function (tr) {
        if (tr.querySelector('td')) dataRows.push(tr);
      });
      var i = 0;
      while (i < dataRows.length) {
        var cell = dataRows[i].querySelector('td');
        var label = cell.textContent.trim();
        var span = 1;
        for (var j = i + 1; j < dataRows.length; j++) {
          var next = dataRows[j].querySelector('td');
          if (next.textContent.trim() === label) span++;
          else break;
        }
        if (span > 1) {
          cell.rowSpan = span;
          cell.style.verticalAlign = 'middle';
          if (i + span < dataRows.length) {
            cell.classList.add('curr-group-cell');
          }
          for (var k = i; k < i + span; k++) {
            var row = dataRows[k];
            if (k > i) row.querySelector('td').style.display = 'none';
            (function (groupCell) {
              row.addEventListener('mouseenter', function () { groupCell.classList.add('curr-group-hover'); });
              row.addEventListener('mouseleave', function () { groupCell.classList.remove('curr-group-hover'); });
            })(cell);
          }
        }
        i += span;
      }
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

})();
