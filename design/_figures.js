/* Schematic figures for the research section.
 *
 * Each figure is drawn from a fixed seed, so the page is identical on every
 * load, and each is labelled in the page as schematic. None is fitted to
 * data: they show the shape of a result, not a result. To use a real figure
 * from a paper instead, replace the <canvas> with an <img> — the surrounding
 * markup does not change.
 */
(function () {
  "use strict";

  /* ---------- deterministic noise ---------- */
  function hash2(x, y, seed) {
    var h = Math.imul(x | 0, 374761393) ^ Math.imul(y | 0, 668265263) ^ Math.imul(seed, 1274126177);
    h = Math.imul(h ^ (h >>> 13), 1274126177);
    return ((h ^ (h >>> 16)) >>> 0) / 4294967296;
  }
  function smooth(t) { return t * t * (3 - 2 * t); }
  function noise(x, y, seed) {
    var x0 = Math.floor(x), y0 = Math.floor(y);
    var fx = smooth(x - x0), fy = smooth(y - y0);
    var a = hash2(x0, y0, seed), b = hash2(x0 + 1, y0, seed);
    var c = hash2(x0, y0 + 1, seed), d = hash2(x0 + 1, y0 + 1, seed);
    return (a + (b - a) * fx) * (1 - fy) + (c + (d - c) * fx) * fy;
  }
  function fbm(x, y, seed) {
    var v = 0, amp = 0.5, f = 1;
    for (var i = 0; i < 4; i++) {
      v += amp * noise(x * f, y * f, seed + i * 17);
      f *= 2; amp *= 0.5;
    }
    return (v - 0.32) / 0.42;          // stretched to roughly span 0..1
  }
  function prng(seed) {
    return function () {
      seed = (seed * 1664525 + 1013904223) % 4294967296;
      return seed / 4294967296;
    };
  }
  function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

  /* ---------- ramp: slate -> teal -> olive -> ochre -> pale ---------- */
  var STOPS = [
    [0.00, [16, 29, 36]], [0.28, [18, 63, 71]], [0.52, [15, 95, 88]],
    [0.70, [79, 122, 60]], [0.86, [192, 138, 46]], [1.00, [242, 227, 192]]
  ];
  function ramp(v) {
    v = clamp01(v);
    for (var i = 1; i < STOPS.length; i++) {
      if (v <= STOPS[i][0]) {
        var a = STOPS[i - 1], b = STOPS[i], t = (v - a[0]) / (b[0] - a[0]);
        return [
          a[1][0] + (b[1][0] - a[1][0]) * t,
          a[1][1] + (b[1][1] - a[1][1]) * t,
          a[1][2] + (b[1][2] - a[1][2]) * t
        ];
      }
    }
    return STOPS[STOPS.length - 1][1];
  }

  var AXIS = "#7d979d", FRAME = "#2b4048";
  function mono(px) { return px + 'px "DM Mono", ui-monospace, Menlo, monospace'; }
  /* Label size scales with the canvas: the figures are exported at 640 CSS px
     and shown at about 300 px, so a label has to be ~3.7% of the width to
     read at 11-12 px on the page. Paddings are multiples of it. No numeric
     ticks anywhere: an axis number could be read as a result (brief, s.4). */
  function labelSize(w) { return Math.max(9, Math.round(w * 0.037)); }

  /* Paint a scalar field across the whole canvas at device resolution.
     value(u, v) takes normalised coordinates and returns an RGB triple. */
  function paint(ctx, w, h, dpr, value) {
    var W = Math.round(w * dpr), H = Math.round(h * dpr);
    var img = ctx.createImageData(W, H), d = img.data;
    for (var y = 0; y < H; y++) {
      for (var x = 0; x < W; x++) {
        var c = value((x + 0.5) / W, (y + 0.5) / H);
        var o = (y * W + x) * 4;
        d[o] = c[0]; d[o + 1] = c[1]; d[o + 2] = c[2]; d[o + 3] = 255;
      }
    }
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.putImageData(img, 0, 0);
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);   // annotations back in CSS pixels
  }

  function colourbar(ctx, w, h, label) {
    var fs = labelSize(w);
    var bw = Math.min(fs * 9, w * 0.36), bh = Math.max(4, Math.round(fs * 0.45));
    var pad = Math.round(fs * 0.7), x0 = w - bw - pad, y0 = h - pad - bh - fs - 3;
    for (var i = 0; i < bw; i++) {
      var c = ramp(i / bw);
      ctx.fillStyle = "rgb(" + (c[0] | 0) + "," + (c[1] | 0) + "," + (c[2] | 0) + ")";
      ctx.fillRect(x0 + i, y0, 1.2, bh);
    }
    ctx.strokeStyle = FRAME; ctx.lineWidth = 1;
    ctx.strokeRect(x0 + 0.5, y0 + 0.5, bw - 1, bh - 1);
    ctx.fillStyle = AXIS; ctx.font = mono(fs); ctx.textBaseline = "top";
    ctx.textAlign = "left"; ctx.fillText(label, pad, y0 + bh + 3);
    ctx.fillText("low", x0, y0 + bh + 3);
    ctx.textAlign = "right"; ctx.fillText("high", x0 + bw, y0 + bh + 3);
    ctx.textAlign = "left";
  }

  /* ---------- figures ---------- */
  var FIGS = {

    /* Habitat suitability surface with occurrence records. */
    sdm: function (ctx, w, h, dpr) {
      var ar = h / w;
      function suit(u, v) {
        return clamp01(fbm(u * 3.4, v * 3.4 * ar, 41)
          + 0.30 * (1 - v) - 0.18 * Math.abs(u - 0.42));
      }
      paint(ctx, w, h, dpr, function (u, v) { return ramp(0.02 + 0.97 * suit(u, v)); });

      var r = prng(907), placed = 0, tries = 0;
      ctx.lineWidth = 1.1;
      while (placed < 24 && tries < 4000) {
        tries++;
        var u = 0.04 + r() * 0.92, v = 0.05 + r() * 0.72;
        if (suit(u, v) < 0.62 || r() > 0.5) continue;
        var x = u * w, y = v * h;
        ctx.strokeStyle = "rgba(8,16,20,.9)";
        ctx.beginPath(); ctx.arc(x, y, 2.9, 0, 6.2832); ctx.stroke();
        ctx.strokeStyle = "rgba(255,255,255,.92)";
        ctx.beginPath(); ctx.arc(x, y, 2.1, 0, 6.2832); ctx.stroke();
        placed++;
      }
      colourbar(ctx, w, h, "suitability");
    },

    /* Dispersal kernel: log-normal distances, drawn on a linear distance
       axis so the right skew and the long tail are actually visible. On a
       log axis a log-normal is symmetric, which hides the point. */
    kernel: function (ctx, w, h, dpr) {
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      ctx.fillStyle = "#101d24"; ctx.fillRect(0, 0, w, h);
      var fs = labelSize(w);
      var padL = Math.round(fs * 1.5), padR = Math.round(fs * 0.6),
          padB = Math.round(fs * 1.7), padT = Math.round(fs * 1.6);
      var pw = Math.max(10, w - padL - padR), ph = Math.max(10, h - padT - padB);
      var XMAX = 300, TAIL = 100;                    // unitless: shape only
      var mu = Math.log(30), sg = 0.95;
      function dens(km) {
        if (km <= 0.05) return 0;
        var l = Math.log(km);
        return Math.exp(-((l - mu) * (l - mu)) / (2 * sg * sg)) / (km * sg * 2.5066);
      }
      var n = Math.round(pw), pts = [], maxp = 0, i, p;
      for (i = 0; i <= n; i++) {
        p = dens((i / n) * XMAX);
        pts.push(p); if (p > maxp) maxp = p;
      }
      function X(i) { return padL + (i / n) * pw; }
      function Y(v) { return padT + ph - (v / maxp) * ph; }
      var cut = Math.round(n * TAIL / XMAX);
      function band(i0, i1, fill) {
        ctx.beginPath(); ctx.moveTo(X(i0), padT + ph);
        for (var j = i0; j <= i1; j++) ctx.lineTo(X(j), Y(pts[j]));
        ctx.lineTo(X(i1), padT + ph); ctx.closePath();
        ctx.fillStyle = fill; ctx.fill();
      }
      band(0, cut, "rgba(15,95,88,.9)");
      band(cut, n, "rgba(192,138,46,.95)");
      ctx.beginPath();
      for (i = 0; i <= n; i++) { i ? ctx.lineTo(X(i), Y(pts[i])) : ctx.moveTo(X(i), Y(pts[i])); }
      ctx.strokeStyle = "#f2e3c0"; ctx.lineWidth = 1.4; ctx.stroke();

      ctx.strokeStyle = "#d9b45a"; ctx.lineWidth = 1;
      ctx.setLineDash([3, 3]);
      ctx.beginPath(); ctx.moveTo(X(cut), padT - fs * 0.3); ctx.lineTo(X(cut), padT + ph); ctx.stroke();
      ctx.setLineDash([]);

      ctx.strokeStyle = FRAME; ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.moveTo(padL, padT + ph + 0.5); ctx.lineTo(padL + pw, padT + ph + 0.5);
      ctx.moveTo(padL - 0.5, padT); ctx.lineTo(padL - 0.5, padT + ph);
      ctx.stroke();

      ctx.fillStyle = AXIS; ctx.font = mono(fs);
      ctx.textAlign = "left"; ctx.textBaseline = "top";
      ctx.fillText("dispersal distance \u2192", padL, padT + ph + Math.round(fs * 0.45));
      ctx.save();
      ctx.translate(Math.round(fs * 0.25), padT + ph); ctx.rotate(-Math.PI / 2);
      ctx.fillText("density \u2192", 0, 0);
      ctx.restore();
      ctx.fillStyle = "#d9b45a"; ctx.textBaseline = "bottom";
      ctx.fillText("long-distance tail", X(cut) + Math.round(fs * 0.4), padT - Math.round(fs * 0.15));
      ctx.textBaseline = "top";
    },

    /* Range shift: occupied area now, against a projected contour. */
    range: function (ctx, w, h, dpr) {
      var ar = h / w, THR = 0.56;
      function occ(u, v) {
        return clamp01(fbm(u * 3.0, v * 3.0 * ar, 73)
          + 0.26 * (1 - v) - 0.22 * Math.abs(u - 0.5));
      }
      paint(ctx, w, h, dpr, function (u, v) {
        var a = occ(u, v), b = occ(u - 0.085, v + 0.07);
        if (Math.abs(b - THR) < 0.012) return [217, 180, 90];
        if (a > THR) return ramp(0.30 + 0.45 * (a - THR) / (1 - THR));
        return ramp(0.04 + 0.10 * a);
      });
      var fs = labelSize(w), u = fs / 9;   // legend laid out in label units
      ctx.font = mono(fs); ctx.textBaseline = "top";
      ctx.fillStyle = "rgba(10,18,23,.82)";
      ctx.fillRect(7 * u, h - 21 * u, 172 * u, 17 * u);
      ctx.fillStyle = "rgb(21,120,110)"; ctx.fillRect(13 * u, h - 16 * u, 9 * u, 9 * u);
      ctx.fillStyle = "#c2d4d6"; ctx.fillText("occupied", 27 * u, h - 16 * u);
      ctx.fillStyle = "#d9b45a"; ctx.fillRect(93 * u, h - 12 * u, 11 * u, Math.max(2, 2 * u));
      ctx.fillStyle = "#c2d4d6"; ctx.fillText("projected", 110 * u, h - 16 * u);
    },

    /* Bioacoustic spectrogram: frequency against time. */
    acoustic: function (ctx, w, h, dpr) {
      var fs = labelSize(w);
      var padL = Math.round(fs * 1.3), padB = Math.round(fs * 1.7);
      var r = prng(5150), songs = [], s;
      for (s = 0; s < 11; s++) {
        songs.push({
          t0: r(), dur: 0.05 + r() * 0.12, f0: 0.15 + r() * 0.58,
          sweep: (r() - 0.5) * 0.3, band: 0.016 + r() * 0.03,
          amp: 0.5 + r() * 0.5, wob: 6 + r() * 14
        });
      }
      var uL = padL / w, vB = 1 - padB / h;
      paint(ctx, w, h, dpr, function (u, v) {
        if (u < uL || v > vB) return [12, 22, 27];
        var t = (u - uL) / (1 - uL), f = 1 - v / vB;
        /* No per-pixel noise term here: it read as sensor grain but cost
           ~1 MB in the exported image (see design/BRIEF.md, section 4). */
        var val = 0.04 + 0.14 * Math.pow(1 - f, 2.2);
        for (var k = 0; k < songs.length; k++) {
          var sg = songs[k];
          if (t < sg.t0 || t > sg.t0 + sg.dur) continue;
          var p = (t - sg.t0) / sg.dur;
          var centre = sg.f0 + sg.sweep * p + 0.012 * Math.sin(p * sg.wob);
          var dd = Math.abs(f - centre) / sg.band;
          if (dd < 3.2) val += sg.amp * Math.sin(Math.PI * p) * Math.exp(-dd * dd * 0.6);
        }
        return ramp(val);
      });
      var ph = h - padB;
      ctx.fillStyle = AXIS; ctx.font = mono(fs);
      ctx.textAlign = "left"; ctx.textBaseline = "top";
      ctx.save();
      ctx.translate(Math.round(fs * 0.25), ph); ctx.rotate(-Math.PI / 2);
      ctx.fillText("frequency \u2192", 0, 0);
      ctx.restore();
      ctx.fillText("time \u2192", padL, ph + Math.round(fs * 0.45));
    },

    /* Wide divider: a landscape permeability surface. */
    strip: function (ctx, w, h, dpr) {
      var ar = h / w;
      paint(ctx, w, h, dpr, function (u, v) {
        var f = clamp01(fbm(u * 14.0, v * 14.0 * ar, 311)
          + 0.08 * Math.sin(u * 7.1) - 0.06 * v);
        return ramp(clamp01(0.04 + 0.78 * (f - 0.5) * 1.35 + 0.34));
      });
    }
  };

  /* ---------- mount ---------- */
  function render(cv) {
    var fn = FIGS[cv.getAttribute("data-fig")];
    if (!fn) return;
    var w = cv.clientWidth, h = cv.clientHeight;
    if (!w || !h) return;
    var dpr = Math.min(window.devicePixelRatio || 1, 2);
    cv.width = Math.round(w * dpr);
    cv.height = Math.round(h * dpr);
    var ctx = cv.getContext("2d");
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    fn(ctx, w, h, dpr);
  }

  function all() {
    var list = document.querySelectorAll("canvas[data-fig]");
    for (var i = 0; i < list.length; i++) render(list[i]);
  }

  all();
  var to;
  window.addEventListener("resize", function () {
    clearTimeout(to);
    to = setTimeout(all, 200);
  });
})();
