---
layout: default.liquid
title: "pi-agent-space — surrogate model"
description: "Interactive walkthrough of the heteroscedastic Gaussian-process surrogate behind pi-agent-space's Bayesian-optimisation loop."
data:
  section: projects
---
<p style="margin:0 0 1.25rem;font-size:0.78rem;letter-spacing:0.04em">
  <a href="/projects/" class="naked" style="color:var(--fg-2)">&larr; work</a>
  <span style="color:var(--rule-strong);margin:0 0.5rem">/</span>
  <span style="color:var(--fg-3)">pi-agent-space</span>
</p>
<h1 class="page-title">surrogate model<span class="dot">.</span></h1>
<p class="page-sub">pi-agent-space &middot; interactive visualization</p>

<style>
  /* Bridge: the viz was authored against a different design system's tokens.
     Map them onto constans.dev's palette so it renders natively. */
  #gp-viz {
    --color-background-primary: var(--bg);
    --color-background-secondary: var(--bg-2);
    --color-background-info: color-mix(in oklab, var(--accent) 14%, var(--bg));
    --color-text-primary: var(--fg);
    --color-text-secondary: var(--fg-2);
    --color-text-info: var(--accent);
    --color-border-tertiary: var(--rule);
    --border-radius-lg: 4px;
    --border-radius-md: 3px;
    /* --font-mono is already defined by site.css (JetBrains Mono) */
    display: block;
    max-width: 900px;
  }
  #gp-viz .tab.active { font-weight: 600; }
  .panel { background: var(--color-background-primary); border: 0.5px solid var(--color-border-tertiary); border-radius: var(--border-radius-lg); padding: 1.25rem; margin-bottom: 1rem; }
  .section-label { font-size: 12px; color: var(--color-text-secondary); font-weight: 500; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.5rem; }
  .eq { font-family: var(--font-mono); font-size: 13px; color: var(--color-text-primary); background: var(--color-background-secondary); border-radius: var(--border-radius-md); padding: 0.5rem 0.75rem; margin: 0.5rem 0; border: 0.5px solid var(--color-border-tertiary); }
  .badge { display: inline-block; font-size: 11px; padding: 2px 8px; border-radius: 99px; font-weight: 500; margin-left: 6px; }
  .badge-purple { background: #EEEDFE; color: #3C3489; }
  .badge-teal   { background: #E1F5EE; color: #085041; }
  .badge-amber  { background: #FAEEDA; color: #633806; }
  @media (prefers-color-scheme: dark) {
    .badge-purple { background: #3C3489; color: #CECBF6; }
    .badge-teal   { background: #085041; color: #9FE1CB; }
    .badge-amber  { background: #633806; color: #FAC775; }
  }
  canvas { width: 100% !important; }
  .ctrl-row { display: flex; align-items: center; gap: 12px; margin: 0.5rem 0; font-size: 13px; color: var(--color-text-secondary); }
  .ctrl-row label { min-width: 110px; }
  .ctrl-row span  { min-width: 40px; text-align: right; font-family: var(--font-mono); color: var(--color-text-primary); }
  .tab-bar { display: flex; gap: 4px; margin-bottom: 1rem; }
  .tab { padding: 6px 14px; border-radius: var(--border-radius-md); border: 0.5px solid var(--color-border-tertiary); font-size: 13px; cursor: pointer; background: var(--color-background-primary); color: var(--color-text-secondary); }
  .tab.active { background: var(--color-background-info); color: var(--color-text-info); border-color: transparent; font-weight: 500; }
  .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
  @media (max-width: 500px) { .two-col { grid-template-columns: 1fr; } }
</style>

<div id="gp-viz">

<h2 class="sr-only" style="position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0,0,0,0)">Interactive visualization of the Heteroscedastic GP Surrogate model</h2>

<div class="tab-bar">
  <button class="tab active" onclick="showTab('overview')">Overview</button>
  <button class="tab" onclick="showTab('kernel')">Kernel & noise</button>
  <button class="tab" onclick="showTab('posterior')">Posterior</button>
  <button class="tab" onclick="showTab('regime')">Bootstrap regime</button>
</div>

<!-- OVERVIEW TAB -->
<div id="tab-overview">
  <div class="panel">
    <div class="section-label">What this model does</div>
    <p style="font-size:14px;color:var(--color-text-primary);margin:0 0 0.75rem;line-height:1.6">
      A <strong style="font-weight:500">Gaussian Process (GP)</strong> is a prior over functions. Given a few observations, it infers a <em>distribution</em> over all possible functions consistent with those observations — giving both a mean prediction and uncertainty.
    </p>
    <p style="font-size:14px;color:var(--color-text-primary);margin:0 0 0.75rem;line-height:1.6">
      This model is <strong style="font-weight:500">heteroscedastic</strong>: the noise level varies across inputs rather than being a fixed constant. A second GP models the log-noise variance.
    </p>
    <p style="font-size:14px;color:var(--color-text-primary);margin:0;line-height:1.6">
      Five independent GPs run in parallel, one per Pareto objective: <span class="badge badge-purple">tokens τ</span> <span class="badge badge-teal">cost c</span> <span class="badge badge-amber">quality q</span> and two more.
    </p>
  </div>

  <div class="two-col">
    <div class="panel">
      <div class="section-label">Feature space</div>
      <p style="font-size:13px;color:var(--color-text-secondary);margin:0 0 0.5rem">A package p is encoded as:</p>
      <div class="eq">x = φ(p) ∈ ℝᵈ</div>
      <p style="font-size:13px;color:var(--color-text-secondary);margin:0.5rem 0 0;line-height:1.5">φ concatenates one-hot model slot, binary skill presence, and one-hot prompt/template variants.</p>
    </div>
    <div class="panel">
      <div class="section-label">Observation structure</div>
      <div class="eq">yᵢ = (τ̄ᵢ, c̄ᵢ, sᵢ, q̄ᵢ, rᵢ)</div>
      <p style="font-size:13px;color:var(--color-text-secondary);margin:0.5rem 0 0;line-height:1.5">Trials without a subjective score rᵢ contribute only the first 4 components to the GP.</p>
    </div>
  </div>
</div>

<!-- KERNEL TAB -->
<div id="tab-kernel" style="display:none">
  <div class="panel">
    <div class="section-label">RBF-ARD kernel</div>
    <div class="eq">k(x,x') = σ²_f · exp(−½ (x−x')ᵀ Λ⁻¹ (x−x'))</div>
    <p style="font-size:13px;color:var(--color-text-secondary);margin:0.5rem 0;line-height:1.5">
      Λ = diag(ℓ₁², …, ℓ_d²) gives each input dimension its own length-scale — <em>automatic relevance determination</em>. A short ℓ means that dimension strongly influences the output.
    </p>
    <div class="ctrl-row">
      <label>Length-scale ℓ</label>
      <input type="range" min="0.1" max="3" step="0.05" value="1" id="ls-slider" style="flex:1" oninput="drawKernel()">
      <span id="ls-val">1.00</span>
    </div>
    <div class="ctrl-row">
      <label>Signal var σ²_f</label>
      <input type="range" min="0.1" max="3" step="0.1" value="1" id="sf-slider" style="flex:1" oninput="drawKernel()">
      <span id="sf-val">1.00</span>
    </div>
    <div style="position:relative;height:200px;margin-top:0.75rem">
      <canvas id="kernel-canvas" role="img" aria-label="RBF kernel value as a function of distance"></canvas>
    </div>
    <p style="font-size:12px;color:var(--color-text-secondary);margin:0.5rem 0 0">Kernel value k(0, x') as a function of distance x'. Wider ℓ → smoother functions.</p>
  </div>

  <div class="panel">
    <div class="section-label">Input-dependent noise (heteroscedastic)</div>
    <div class="eq">g(x) ~ GP(0, k_ε(x,x'))</div>
    <div class="eq">σ²(x) = exp(g(x))</div>
    <p style="font-size:13px;color:var(--color-text-secondary);margin:0.5rem 0;line-height:1.5">
      Instead of a fixed noise floor, a <em>second GP</em> models log-variance. This lets the model be confident in low-noise regions and uncertain where observations are noisy.
    </p>
    <div style="position:relative;height:160px;margin-top:0.75rem">
      <canvas id="noise-canvas" role="img" aria-label="Illustrative heteroscedastic noise level across input space"></canvas>
    </div>
    <p style="font-size:12px;color:var(--color-text-secondary);margin:0.5rem 0 0">Illustrative heteroscedastic noise: σ²(x) varies continuously across x.</p>
  </div>
</div>

<!-- POSTERIOR TAB -->
<div id="tab-posterior" style="display:none">
  <div class="panel">
    <div class="section-label">Posterior mean & variance</div>
    <div class="eq">μ_N(x*) = k*ᵀ [K + Σ]⁻¹ y</div>
    <div class="eq">σ²_N(x*) = k(x*,x*) − k*ᵀ [K + Σ]⁻¹ k*</div>
    <p style="font-size:13px;color:var(--color-text-secondary);margin:0.5rem 0 1rem;line-height:1.5">
      K is the N×N kernel matrix of training points. Σ = diag(σ²(x₁),…,σ²(x_N)) is the heteroscedastic noise matrix. k* is the vector of kernel values between x* and all training points.
    </p>
    <div class="ctrl-row">
      <label>Observations N</label>
      <input type="range" min="1" max="15" step="1" value="5" id="n-slider" style="flex:1" oninput="drawPosterior()">
      <span id="n-val">5</span>
    </div>
    <div class="ctrl-row">
      <label>Noise level</label>
      <input type="range" min="0.01" max="1" step="0.01" value="0.15" id="noise-slider" style="flex:1" oninput="drawPosterior()">
      <span id="noise-val">0.15</span>
    </div>
    <div style="position:relative;height:260px;margin-top:0.75rem">
      <canvas id="posterior-canvas" role="img" aria-label="GP posterior mean and 95% confidence band over input space"></canvas>
    </div>
    <p style="font-size:12px;color:var(--color-text-secondary);margin:0.5rem 0 0">
      <span style="display:inline-block;width:14px;height:3px;background:#534AB7;vertical-align:middle;margin-right:4px"></span>Posterior mean &nbsp;
      <span style="display:inline-block;width:14px;height:8px;background:#EEEDFE;border:0.5px solid #534AB7;vertical-align:middle;margin-right:4px"></span>95% credible band &nbsp;
      <span style="display:inline-block;width:7px;height:7px;background:#1D9E75;border-radius:50%;vertical-align:middle;margin-right:4px"></span>Observations
    </p>
  </div>
</div>

<!-- BOOTSTRAP REGIME TAB -->
<div id="tab-regime" style="display:none">
  <div class="panel">
    <div class="section-label">Proposer regime</div>
    <p style="font-size:13px;color:var(--color-text-secondary);margin:0 0 0.75rem;line-height:1.5">
      With fewer than N₀ ≈ 10 trials the GP doesn't have enough data to be reliable. The proposer switches strategy based on trial count.
    </p>
    <div id="regime-vis" style="margin: 0.75rem 0 1rem"></div>
    <div class="ctrl-row">
      <label>Trials completed</label>
      <input type="range" min="0" max="30" step="1" value="5" id="trial-slider" style="flex:1" oninput="updateRegime()">
      <span id="trial-val">5</span>
    </div>
    <div id="regime-status" style="margin-top:1rem;padding:0.75rem 1rem;border-radius:var(--border-radius-md);border:0.5px solid var(--color-border-tertiary);font-size:14px;color:var(--color-text-primary)"></div>
  </div>

  <div class="panel">
    <div class="section-label">EHVI acquisition function</div>
    <div class="eq">α_EHVI(x; D_N)</div>
    <p style="font-size:13px;color:var(--color-text-secondary);margin:0.5rem 0;line-height:1.5">
      <strong style="font-weight:500">Expected Hypervolume Improvement</strong> measures how much a new candidate x is expected to expand the 5-dimensional Pareto frontier of (tokens, cost, scaling, quality, subjective) scores.
    </p>
    <p style="font-size:13px;color:var(--color-text-secondary);margin:0;line-height:1.5">
      Once N ≥ N₀, the proposer picks whichever unevaluated package maximises EHVI — balancing exploitation (known good regions) with exploration (high uncertainty).
    </p>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<script>
const isDark = matchMedia('(prefers-color-scheme: dark)').matches;
const purple = '#534AB7', purpleLight = isDark ? 'rgba(83,74,183,0.25)' : 'rgba(83,74,183,0.12)';
const teal = '#1D9E75';
const textColor = isDark ? '#c2c0b6' : '#3d3d3a';
const gridColor = isDark ? 'rgba(255,255,255,0.07)' : 'rgba(0,0,0,0.07)';

let kernelChart, noiseChart, posteriorChart;

// ---- TAB MANAGEMENT ----
function showTab(name) {
  ['overview','kernel','posterior','regime'].forEach(t => {
    document.getElementById('tab-'+t).style.display = t===name ? '' : 'none';
  });
  document.querySelectorAll('.tab').forEach((b,i) => {
    b.classList.toggle('active', ['overview','kernel','posterior','regime'][i]===name);
  });
  if (name==='kernel') { setTimeout(()=>{ drawKernel(); drawNoiseIllustration(); }, 30); }
  if (name==='posterior') { setTimeout(drawPosterior, 30); }
  if (name==='regime') { setTimeout(updateRegime, 10); }
}

// ---- KERNEL CHART ----
function drawKernel() {
  const ls = parseFloat(document.getElementById('ls-slider').value);
  const sf = parseFloat(document.getElementById('sf-slider').value);
  document.getElementById('ls-val').textContent = ls.toFixed(2);
  document.getElementById('sf-val').textContent = sf.toFixed(2);
  const xs = [], ys = [];
  for (let x = -3; x <= 3; x += 0.1) {
    xs.push(x.toFixed(1));
    ys.push(sf * Math.exp(-0.5 * (x*x) / (ls*ls)));
  }
  const ctx = document.getElementById('kernel-canvas').getContext('2d');
  if (kernelChart) kernelChart.destroy();
  kernelChart = new Chart(ctx, {
    type: 'line',
    data: { labels: xs, datasets: [{ data: ys, borderColor: purple, borderWidth: 2, fill: true, backgroundColor: purpleLight, pointRadius: 0, tension: 0.4 }] },
    options: {
      responsive: true, maintainAspectRatio: false, animation: false,
      plugins: { legend: { display: false }, tooltip: { enabled: false } },
      scales: {
        x: { ticks: { color: textColor, font: {size:11}, maxTicksLimit: 7 }, grid: { color: gridColor }, title: { display: true, text: "x'", color: textColor, font:{size:12} } },
        y: { ticks: { color: textColor, font: {size:11} }, grid: { color: gridColor }, min: 0, title: { display: true, text: 'k(0, x\')', color: textColor, font:{size:12} } }
      }
    }
  });
}

// ---- NOISE ILLUSTRATION ----
function drawNoiseIllustration() {
  const xs = [], ys = [];
  for (let x = 0; x <= 6; x += 0.1) {
    xs.push(x.toFixed(1));
    const base = 0.05 + 0.3 * Math.exp(-0.5*(x-2)*(x-2)) + 0.5 * Math.exp(-0.5*(x-5)*(x-5)/0.3);
    ys.push(+base.toFixed(3));
  }
  const ctx = document.getElementById('noise-canvas').getContext('2d');
  if (noiseChart) noiseChart.destroy();
  noiseChart = new Chart(ctx, {
    type: 'line',
    data: { labels: xs, datasets: [{ data: ys, borderColor: '#BA7517', borderWidth: 2, fill: true, backgroundColor: isDark?'rgba(186,117,23,0.2)':'rgba(186,117,23,0.1)', pointRadius: 0, tension: 0.4 }] },
    options: {
      responsive: true, maintainAspectRatio: false, animation: false,
      plugins: { legend: { display: false }, tooltip: { enabled: false } },
      scales: {
        x: { ticks: { color: textColor, font:{size:11}, maxTicksLimit: 7 }, grid: { color: gridColor }, title: { display: true, text: 'x', color: textColor, font:{size:12} } },
        y: { ticks: { color: textColor, font:{size:11} }, grid: { color: gridColor }, min: 0, title: { display: true, text: 'σ²(x)', color: textColor, font:{size:12} } }
      }
    }
  });
}

// ---- POSTERIOR CHART ----
function rbf(x1, x2, ls=1, sf=1) { return sf*sf*Math.exp(-0.5*(x1-x2)*(x1-x2)/(ls*ls)); }

function matInv2(A, n) {
  // Simple Cholesky-free Gauss-Jordan for small n
  const M = A.map(r=>[...r]);
  const I = Array.from({length:n},(_,i)=>Array.from({length:n},(_,j)=>i===j?1:0));
  for (let col=0;col<n;col++) {
    let pivot=M[col][col];
    for (let j=0;j<n;j++){M[col][j]/=pivot;I[col][j]/=pivot;}
    for (let row=0;row<n;row++) {
      if (row===col) continue;
      const f=M[row][col];
      for (let j=0;j<n;j++){M[row][j]-=f*M[col][j];I[row][j]-=f*I[col][j];}
    }
  }
  return I;
}

function drawPosterior() {
  const N = parseInt(document.getElementById('n-slider').value);
  const noiseLevel = parseFloat(document.getElementById('noise-slider').value);
  document.getElementById('n-val').textContent = N;
  document.getElementById('noise-val').textContent = noiseLevel.toFixed(2);

  // Fixed training points & targets (reproducible)
  const seed = [0.2,0.7,1.4,1.9,2.5,3.1,3.8,4.4,4.9,5.3,5.8,6.0,6.3,6.7,6.9];
  const ytarg = [0.8,1.4,0.5,-0.3,0.2,1.1,0.7,-0.5,-0.2,0.4,1.0,0.6,-0.1,0.3,0.9];
  const Xs = seed.slice(0,N), Ys = ytarg.slice(0,N);

  const ls = 1.2, sf = 1.0;
  // Build K + sigma*I
  const K = Xs.map((xi,i)=>Xs.map((xj,j)=>rbf(xi,xj,ls,sf)+(i===j?noiseLevel:0)));
  const Kinv = matInv2(K,N);

  // Test points
  const testX=[], mu=[], lower=[], upper=[];
  for (let x=0;x<=7;x+=0.07) {
    testX.push(+x.toFixed(2));
    const kstar = Xs.map(xi=>rbf(x,xi,ls,sf));
    // mu = kstar^T Kinv y
    let m=0;
    for (let i=0;i<N;i++){let s=0;for(let j=0;j<N;j++)s+=Kinv[i][j]*Ys[j];m+=kstar[i]*s;}
    // var = k(x,x) - kstar^T Kinv kstar
    let v=rbf(x,x,ls,sf);
    for(let i=0;i<N;i++){let s=0;for(let j=0;j<N;j++)s+=Kinv[i][j]*kstar[j];v-=kstar[i]*s;}
    v=Math.max(v,0);
    const std=Math.sqrt(v)*1.96;
    mu.push(+m.toFixed(3));
    lower.push(+(m-std).toFixed(3));
    upper.push(+(m+std).toFixed(3));
  }

  const ctx = document.getElementById('posterior-canvas').getContext('2d');
  if (posteriorChart) posteriorChart.destroy();
  posteriorChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: testX,
      datasets: [
        { label: 'Upper', data: upper, borderColor:'transparent', backgroundColor: purpleLight, fill:'+1', pointRadius:0, tension:0.4 },
        { label: 'Lower', data: lower, borderColor:'transparent', backgroundColor: purpleLight, fill:false, pointRadius:0, tension:0.4 },
        { label: 'Mean', data: mu, borderColor: purple, borderWidth:2, backgroundColor:'transparent', fill:false, pointRadius:0, tension:0.4 },
        {
          label: 'Observations', data: testX.map(x=>{ const xi=parseFloat(x); const idx=Xs.findIndex(v=>Math.abs(v-xi)<0.05); return idx>=0?Ys[idx]:null; }),
          borderColor: teal, backgroundColor: teal, pointRadius:5, showLine:false, pointStyle:'circle'
        }
      ]
    },
    options: {
      responsive:true, maintainAspectRatio:false, animation:false,
      plugins:{ legend:{display:false}, tooltip:{ filter: item=>item.dataset.label==='Observations', callbacks:{label: i=>`y = ${i.parsed.y.toFixed(2)}`} } },
      scales:{
        x:{ticks:{color:textColor,font:{size:11},maxTicksLimit:8},grid:{color:gridColor},title:{display:true,text:'x',color:textColor,font:{size:12}}},
        y:{ticks:{color:textColor,font:{size:11}},grid:{color:gridColor},title:{display:true,text:'f(x)',color:textColor,font:{size:12}}}
      }
    }
  });
}

// ---- REGIME VIS ----
function updateRegime() {
  const N = parseInt(document.getElementById('trial-slider').value);
  const N0 = 10;
  document.getElementById('trial-val').textContent = N;

  const bar = document.getElementById('regime-vis');
  const pct = Math.min(N/30*100, 100);
  const threshPct = N0/30*100;
  bar.innerHTML = `
    <div style="position:relative;height:28px;background:var(--color-background-secondary);border-radius:99px;overflow:hidden">
      <div style="position:absolute;left:0;top:0;height:100%;width:${pct}%;background:${N<N0?'#BA7517':'#1D9E75'};border-radius:99px;transition:width .3s,background .3s"></div>
      <div style="position:absolute;left:${threshPct}%;top:0;width:2px;height:100%;background:var(--color-text-secondary);opacity:0.5"></div>
      <div style="position:absolute;left:0;top:0;width:100%;height:100%;display:flex;align-items:center;justify-content:space-between;padding:0 12px;font-size:12px;font-weight:500;color:var(--color-text-primary);pointer-events:none">
        <span>N = ${N}</span><span>N₀ = ${N0}</span>
      </div>
    </div>
    <div style="display:flex;justify-content:space-between;font-size:11px;color:var(--color-text-secondary);margin-top:4px;padding:0 4px">
      <span>Random exploration</span><span>EHVI acquisition</span>
    </div>
  `;

  const status = document.getElementById('regime-status');
  if (N < N0) {
    status.style.borderColor = '#BA7517';
    status.innerHTML = `<strong style="color:#BA7517;font-weight:500">⚡ Bootstrap phase</strong> (N = ${N} < N₀ = ${N0})<br><span style="font-size:13px;color:var(--color-text-secondary)">Proposer samples uniformly at random from the unevaluated package space. The GP is not yet reliable enough to guide search.</span>`;
  } else {
    status.style.borderColor = '#1D9E75';
    status.innerHTML = `<strong style="color:#1D9E75;font-weight:500">✓ Bayesian optimisation phase</strong> (N = ${N} ≥ N₀ = ${N0})<br><span style="font-size:13px;color:var(--color-text-secondary)">Proposer selects x* = argmax α_EHVI(x; D_N) — the package expected to most improve the 5D Pareto frontier.</span>`;
  }
}

updateRegime();
</script>
</div>

<div class="act-row" style="margin-top:2rem">
  <a class="act act-sm" href="https://raw.githubusercontent.com/soulstrop/pi-agent-space/0460d618899bd7c36175b9776af4fc6ba10a1e56/docs/surrogate-model.pdf">Full surrogate-model math (pdf) <span class="arr">&darr;</span></a>
  <a class="act act-sm" href="https://github.com/soulstrop/pi-agent-space">Repository <span class="arr">&#8599;</span></a>
</div>
