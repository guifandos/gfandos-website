(function () {
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var io = 'IntersectionObserver' in window;

  // 1. Navbar: transparent over the hero, solid once scrolled
  document.documentElement.classList.add('home');
  function nav() {
    document.documentElement.classList.toggle('scrolled', window.scrollY > 40);
  }
  nav(); window.addEventListener('scroll', nav, { passive: true });

  // 2. Hero parallax (illustration drifts slower than the page)
  var heroImg = document.querySelector('.hero picture');
  if (heroImg && !reduce) {
    var ticking = false;
    window.addEventListener('scroll', function () {
      if (ticking) return; ticking = true;
      requestAnimationFrame(function () {
        var y = Math.min(window.scrollY, 900);
        heroImg.style.transform = 'translate3d(0,' + (y * 0.25) + 'px,0) scale(1.06)';
        ticking = false;
      });
    }, { passive: true });
  }

  // 3. Reveal on scroll: sections and cards ease in the first time they enter the viewport
  var targets = document.querySelectorAll('.section-head, .card-x, .outcomes li, .news-item, .feature > *, .team-strip .member, .callout-join, .lead-text');
  if (io && !reduce) {
    var i = 0;
    targets.forEach(function (el) {
      var r = el.getBoundingClientRect();
      if (r.top < window.innerHeight) return;           // already visible: never hide it
      el.classList.add('reveal');
      el.style.transitionDelay = ((i++ % 4) * 70) + 'ms';
    });
    var ro = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) { if (e.isIntersecting) { e.target.classList.add('in'); ro.unobserve(e.target); } });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.05 });
    document.querySelectorAll('.reveal').forEach(function (el) { ro.observe(el); });
  }

  // 4. Story section: the sticky map changes as the reader scrolls through the three steps
  var story = document.querySelector('.story');
  if (story && io) {
    var steps = story.querySelectorAll('.story-step');
    var so = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) {
          story.setAttribute('data-step', e.target.getAttribute('data-step'));
          steps.forEach(function (s) { s.classList.toggle('active', s === e.target); });
        }
      });
    }, { rootMargin: '-45% 0px -45% 0px', threshold: 0 });
    steps.forEach(function (s) { so.observe(s); });
  }

  // 5. Movement tracks on the sticky map
  var cv = document.getElementById('tracks'); if (!cv) return;
  var ctx = cv.getContext('2d'), dpr = Math.min(window.devicePixelRatio || 1, 2);
  var C = [[0.22, 0.62], [0.47, 0.36], [0.70, 0.58], [0.86, 0.28], [0.38, 0.80]];
  var W, H, walkers = [], t = 0;
  function seed(s) { return function () { s = (s * 1664525 + 1013904223) % 4294967296; return s / 4294967296; }; }
  var rnd = seed(7);
  function gauss() { var u = rnd() || 1e-6, v = rnd(); return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * v); }
  function resize() {
    var r = cv.parentElement.getBoundingClientRect(); W = r.width; H = r.height;
    cv.width = W * dpr; cv.height = H * dpr; cv.style.width = W + 'px'; cv.style.height = H + 'px';
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    walkers = []; rnd = seed(7);
    for (var i = 0; i < 9; i++) { var c = C[Math.floor(rnd() * C.length)];
      walkers.push({ x: c[0] * W + (rnd() - 0.5) * 60, y: c[1] * H + (rnd() - 0.5) * 60, a: rnd() * 6.28, tgt: C[Math.floor(rnd() * C.length)], trail: [] }); }
    t = 0; for (var k = 0; k < 160; k++) { t++; walkers.forEach(step); } draw();
  }
  function step(w) {
    if (t % 75 === 0) w.tgt = C[Math.floor(rnd() * C.length)];
    var want = Math.atan2(w.tgt[1] * H - w.y, w.tgt[0] * W - w.x);
    var diff = ((want - w.a + Math.PI) % (2 * Math.PI) + 2 * Math.PI) % (2 * Math.PI) - Math.PI;
    w.a += 0.12 * diff + gauss() * 0.3;
    var sp = Math.max(2, W / 300);
    w.x += Math.cos(w.a) * sp; w.y += Math.sin(w.a) * sp;
    if (w.x < 20 || w.x > W - 20) { w.a = Math.PI - w.a; w.x = Math.min(Math.max(w.x, 20), W - 20); }
    if (w.y < 20 || w.y > H - 20) { w.a = -w.a; w.y = Math.min(Math.max(w.y, 20), H - 20); }
    w.trail.push([w.x, w.y]); if (w.trail.length > 220) w.trail.shift();
  }
  function draw() {
    ctx.clearRect(0, 0, W, H);
    walkers.forEach(function (w) {
      for (var i = 1; i < w.trail.length; i++) {
        var k = i / w.trail.length;
        ctx.strokeStyle = 'rgba(194,145,58,' + (0.15 + 0.8 * k) + ')'; ctx.lineWidth = 1.8;
        ctx.beginPath(); ctx.moveTo(w.trail[i - 1][0], w.trail[i - 1][1]); ctx.lineTo(w.trail[i][0], w.trail[i][1]); ctx.stroke();
      }
      ctx.fillStyle = '#c2913a'; ctx.strokeStyle = '#f7f3ea'; ctx.lineWidth = 1.5;
      ctx.beginPath(); ctx.arc(w.x, w.y, 4, 0, 6.28); ctx.fill(); ctx.stroke();
    });
  }
  var running = false;
  function loop() { if (!running) return; t++; walkers.forEach(step); draw(); requestAnimationFrame(loop); }
  resize(); window.addEventListener('resize', resize);
  if (reduce) return;
  if (io) {
    new IntersectionObserver(function (e) {
      var vis = e[0].isIntersecting;
      if (vis && !running) { running = true; loop(); }
      if (!vis) running = false;
    }).observe(cv);
  } else { running = true; loop(); }
})();
