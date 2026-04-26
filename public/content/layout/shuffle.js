var allPhotos = window._pagePhotos || [];
function shufflePhotos() {
  var a = allPhotos.slice();
  for (var i = a.length - 1; i > 0; i--) {
    var j = Math.floor(Math.random() * (i + 1));
    var t = a[i]; a[i] = a[j]; a[j] = t;
  }
  for (var i = 0; i < 4; i++) {
    document.getElementById('photo-' + i).src = a[i];
  }
}
shufflePhotos();
