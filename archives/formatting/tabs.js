// Generic tab activation: finds all .tabs containers on the page,
// picks a random tab in each, and syncs groups that share subject names.
(function() {
  document.querySelectorAll('.tabs').forEach(function(container) {
    var radios = container.querySelectorAll('input[type="radio"]');
    if (radios.length === 0) return;
    var pick = radios[Math.floor(Math.random() * radios.length)];
    pick.checked = true;
  });
})();
