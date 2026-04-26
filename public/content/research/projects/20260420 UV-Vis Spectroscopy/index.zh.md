---
project: 紫外-可见光谱
---

<div class="page-header"><h2>研究</h2><div class="header-nav"><a href="/zh/curriculum/">课程</a><a href="/zh/olympiads/">竞赛</a><a class="active" href="/zh/research/">研究</a></div></div>

<div class="project-title"><h1>日常荧光团的紫外-可见光谱分析</h1><span class="chip chem">化学</span></div>

<div class="photo-grid" id="photo-grid">
  <img id="photo-0" alt="实验照片">
  <img id="photo-1" alt="实验照片">
  <img id="photo-2" alt="实验照片">
  <img id="photo-3" alt="实验照片">
</div>
<button class="shuffle-btn" onclick="shufflePhotos()">随机切换照片</button>

<script src="/content/research/layouts/shuffle.js"></script>

<div class="section-heading"><h2>概述</h2><span class="section-date">2026年4月20日</span></div>

一组样品，三台仪器，三个问题：

- **UV-2550** —— 化合物吞下哪些颜色的光，吞得有多贪婪。
- **FluoroMax-3** —— 吸收之后又吐出哪些颜色的光。
- **Lambda 750** —— 溶剂如何表现。

样品都是荧光团：捕获一个光子又释放出一个更长波长光子的分子。两个峰之间的距离称为**斯托克斯位移**，正是这个位移让本实验有趣——返回的光子永远不是入射的那一个。日常来源代替了实验室参考品：奎宁来自汤力水，荧光素和罗丹明类染料来自荧光笔墨水，姜黄素来自姜黄，叶绿素来自绿茶，水杨酸来自阿司匹林。

## 实验设置

<style>.instrument-table tbody tr td { background: #fff44f; }</style>

<div class="instrument-table" markdown="1">

| 仪器 | 用途 | 范围 |
|------|------|------|
| Shimadzu UV-2550 UV/Vis Spectrophotometer | 吸收（λ<sub>max</sub>） | 200–800 nm |
| Horiba Jobin Yvon FluoroMax-3 Spectrofluorometer | 荧光（发射和激发） | 200–800 nm |
| PerkinElmer Lambda 750 UV/Vis/NIR Spectrophotometer | 溶剂（近红外倍频） | 200–2500 nm |

</div>

| 工具 | 详情 |
|------|------|
| 比色皿 | 荧光级10 mm四面透光石英比色皿 |
| 软件 | UVProbe（Shimadzu）、FluorEssence（Horiba）、UV WinLab（PerkinElmer） |
| 空白 | 蒸馏水（水溶液样品）、95%乙醇（乙醇样品） |

比色皿规程（每台仪器都相同）：3次蒸馏水冲洗、1次乙醇、1次水，用Kimwipe擦拭每个光学面，仅以陶瓷镊子夹住顶端边缘。每个样品在正式装液前，先用自身润洗比色皿一次。

## 样品

<div class="hero-single"><img src="/research/projects/20260420 UV-Vis Spectroscopy/photos/samples/samples3.jpeg" alt="八个标记的琥珀色储存瓶 —— 六个荧光团样品加两个空白溶剂"></div>

六种荧光团加两种空白，按溶剂分组。分组也是扫描顺序：先以水基线扫描四个水样品，然后重新建立基线再运行两个乙醇提取物。每个样品都来自日常物品：奎宁来自脱气汤力水，荧光素和罗丹明类染料来自荧光笔墨水，姜黄素和叶绿素分别从姜黄和绿茶中用乙醇提取，水杨酸由阿司匹林加少许小苏打水解而成。

<style>
  .samples-tabs #s-water:checked ~ .tab-labels label[for="s-water"],
  .samples-tabs #s-ethanol:checked ~ .tab-labels label[for="s-ethanol"] {
    color: #5c7a10; border-bottom-color: #5c7a10; background: var(--subj-chem);
  }
  .samples-tabs #s-water:checked ~ #content-s-water,
  .samples-tabs #s-ethanol:checked ~ #content-s-ethanol {
    display: block;
  }
  .samples-tabs table { width: 100%; }
</style>

<div class="tabs samples-tabs">
  <input type="radio" name="samples-tab" id="s-water" checked>
  <input type="radio" name="samples-tab" id="s-ethanol">

  <div class="tab-labels">
    <label for="s-water">水基</label>
    <label for="s-ethanol">乙醇基</label>
  </div>

  <div class="tab-content" id="content-s-water" markdown="1">

| 类别 | 样品 |
|------|------|
| 抗疟药 | 奎宁（汤力水，已脱气） |
| 荧光染料 | 黄色荧光笔（荧光素类） |
| 荧光染料 | 粉色荧光笔（罗丹明类） |
| 药物 | 水杨酸（阿司匹林 + NaHCO₃） |
| 空白 | 蒸馏水 |

  </div>

  <div class="tab-content" id="content-s-ethanol" markdown="1">

| 类别 | 样品 |
|------|------|
| 天然色素 | 姜黄素（姜黄 + 乙醇） |
| 天然色素 | 绿茶提取物（茶叶 + 乙醇） |
| 空白 | 95%乙醇 |

  </div>
</div>

## 方法

相同样品，三台仪器依次运行。UV-2550的结果喂给FluoroMax：其λ<sub>max</sub>设定FluoroMax的λ<sub>ex</sub>，其峰值吸光度设定稀释因子 D = A / 0.05。

<style>
  .methods-tabs #m-uv:checked ~ .tab-labels label[for="m-uv"],
  .methods-tabs #m-flu:checked ~ .tab-labels label[for="m-flu"],
  .methods-tabs #m-lam:checked ~ .tab-labels label[for="m-lam"] {
    color: #5c7a10; border-bottom-color: #5c7a10; background: var(--subj-chem);
  }
  .methods-tabs #m-uv:checked ~ #content-m-uv,
  .methods-tabs #m-flu:checked ~ #content-m-flu,
  .methods-tabs #m-lam:checked ~ #content-m-lam {
    display: block;
  }
  .methods-tabs table { width: 100%; }
  .methods-tabs td:first-child, .methods-tabs th:first-child { width: 2.5em; text-align: center; }
</style>

<div class="tabs methods-tabs">
  <input type="radio" name="methods-tab" id="m-uv" checked>
  <input type="radio" name="methods-tab" id="m-flu">
  <input type="radio" name="methods-tab" id="m-lam">

  <div class="tab-labels">
    <label for="m-uv"><span class="label-full">UV-2550</span><span class="label-abbr">UV-2550</span></label>
    <label for="m-flu"><span class="label-full">FluoroMax-3</span><span class="label-abbr">FluoroMax</span></label>
    <label for="m-lam"><span class="label-full">Lambda 750</span><span class="label-abbr">Lambda 750</span></label>
  </div>

  <div class="tab-content" id="content-m-uv" markdown="1">

| # | 样品 | 稀释 |
|---|------|------|
| 1 | *基线 —— 蒸馏水* | — |
| 2 | 空白（蒸馏水）—— 确认 ~0 A | — |
| 3 | 奎宁 | 约3倍 |
| 4 | 黄色荧光笔 | 约3倍 |
| 5 | 粉色荧光笔 | 约3倍 |
| 6 | 水杨酸 | 约3倍 |
| 7 | *重新基线 —— 95%乙醇* | — |
| 8 | 空白（95%乙醇）—— 确认 ~0 A | — |
| 9 | 姜黄素 | 约3倍 |
| 10 | 绿茶 | 约3倍 |

每个样品一次吸收扫描，190–800 nm，得出λ<sub>max</sub>和峰值A。每条基线之后都跑一次空白当作样品扫描：应该回到接近零的平直状态，确认基线在跑真样品前已生效。多数储液都需要大幅稀释才能落入0.3–0.8 A的甜蜜区——每次保留前一储液的一滴并补足新鲜溶剂，直到峰值落入范围。

  </div>

  <div class="tab-content" id="content-m-flu" markdown="1">

| # | 样品 | 预期 λ<sub>ex</sub> | 预期 λ<sub>em</sub> |
|---|------|------|------|
| 1 | *基线 —— 蒸馏水* | — | — |
| 2 | 空白（蒸馏水）—— 确认平直 | — | — |
| 3 | 奎宁 | 350 | 450 |
| 4 | 水杨酸 | 300 | 410 |
| 5 | *重新基线 —— 95%乙醇* | — | — |
| 6 | 空白（95%乙醇）—— 确认平直 | — | — |
| 7 | 绿茶 | 430 | 670 |
| 8 | 姜黄素 | 425 | 540 |
| 9 | *换用"染料"比色皿 + 重新基线蒸馏水* | — | — |
| 10 | 空白（蒸馏水）—— 确认平直 | — | — |
| 11 | 黄色荧光笔 | 488 | 515 |
| 12 | 粉色荧光笔 | 540 | 585 |

每个样品两次扫描，使用稀释至 D = A / 0.05 的等分试样（每滴样品加 D 滴溶剂）。发射扫描固定λ<sub>ex</sub>（来自UV-2550的λ<sub>max</sub>）并扫描发射波长。激发扫描固定λ<sub>em</sub>并扫描激发波长。样品按稀→浓的顺序运行以避免读数之间的残留。对**绿茶提取物**和**粉色荧光笔**进行激发-发射矩阵（EEM）扫描——这两个样品最可能是多种荧光团的混合物（绿茶含叶绿素a + b + 多酚；荧光笔含罗丹明类染料的混合配方）。EEM同时扫描λ<sub>ex</sub>和λ<sub>em</sub>，产生二维等高线指纹，弥补单激发/单发射扫描会丢失的信息。

  </div>

  <div class="tab-content" id="content-m-lam" markdown="1">

| # | 样品 |
|---|------|
| 1 | 蒸馏水空白 |
| 2 | 95%乙醇空白 |

每种溶剂跑一次，800–2500 nm —— 没有其他仪器能覆盖的波段。水在 ~970、1200、1450、1940 nm 处显示O–H倍频；乙醇在 ~1400、1700 nm 处增加C–H倍频。同时在六个UV-2550荧光团样品上做200–800 nm的简短复扫，兼作校准检查 —— 峰值位置应与UV-2550在 ~1 nm 内吻合。

  </div>
</div>

## 数据

| 仪器 | 每次运行的文件数 |
|------|------------------|
| UV-2550 | 8 —— 6样品 + 2空白 |
| FluoroMax-3 | 20 —— 2次扫描（EM + EX）×（6样品 + 3空白）+ 2 EEM |
| Lambda 750 | 10 —— 6次UV-Vis复扫 + 2次NIR空白 + 2个额外NIR样品 |

*实验结果待出。*

## 结果

### 紫外-可见吸收 - UV-2550

<div class="tabs">
  <input type="radio" name="uv-tab" id="uv-overlay" checked>
  <input type="radio" name="uv-tab" id="uv-baseline">
  <input type="radio" name="uv-tab" id="uv-quinine">
  <input type="radio" name="uv-tab" id="uv-yellow">
  <input type="radio" name="uv-tab" id="uv-pink">
  <input type="radio" name="uv-tab" id="uv-salicylate">

  <div class="tab-labels">
    <label for="uv-overlay">叠加</label>
    <label for="uv-baseline">基线</label>
    <label for="uv-quinine">奎宁</label>
    <label for="uv-yellow">黄色荧光笔</label>
    <label for="uv-pink">粉色荧光笔</label>
    <label for="uv-salicylate">水杨酸</label>
  </div>

  <div class="tab-content" id="content-uv-overlay">
    <img src="/research/projects/20260420 UV-Vis Spectroscopy/output/images/uvvis_overlay.png" alt="UV-Vis 叠加" class="result-img">
  </div>
  <div class="tab-content" id="content-uv-baseline">
    <img src="/research/projects/20260420 UV-Vis Spectroscopy/output/images/uvvis_baseline.png" alt="蒸馏水基线" class="result-img">
  </div>
  <div class="tab-content" id="content-uv-quinine">
    <img src="/research/projects/20260420 UV-Vis Spectroscopy/output/images/uvvis_quinine.png" alt="奎宁 UV-Vis 光谱" class="result-img">
  </div>
  <div class="tab-content" id="content-uv-yellow">
    <img src="/research/projects/20260420 UV-Vis Spectroscopy/output/images/uvvis_yellow.png" alt="黄色荧光笔 UV-Vis 光谱" class="result-img">
  </div>
  <div class="tab-content" id="content-uv-pink">
    <img src="/research/projects/20260420 UV-Vis Spectroscopy/output/images/uvvis_pink.png" alt="粉色荧光笔 UV-Vis 光谱" class="result-img">
  </div>
  <div class="tab-content" id="content-uv-salicylate">
    <img src="/research/projects/20260420 UV-Vis Spectroscopy/output/images/uvvis_salicylate.png" alt="水杨酸 UV-Vis 光谱" class="result-img">
  </div>
</div>

*逐样品解读待补充。*

### 荧光 - FluoroMax-3

<img src="/research/projects/20260420 UV-Vis Spectroscopy/output/images/fluoromax_yellow.png" alt="黄色荧光笔的激发与发射光谱">

*说明待补充。*

### 溶剂 - Lambda 750

*待补充。*

<h2 id="extensions">延伸</h2>

相邻的电子/手性光学光谱仪器——波长范围与紫外-可见相同，测量内容不同。本项目均未使用。

<div class="instrument-table" markdown="1">

| 仪器 | 延伸方向 | 为何值得加入 |
|------|---------|------------|
| Thermo Scientific Evolution 220 UV-Vis 分光光度计 | 备用台式 UV-Vis（单色器，近红外延伸到 1100 nm） | 较新的中端仪器；比 Shimadzu UV-2550（上限 900 nm）多覆盖 200 nm 的近红外波段，但杂散光较高。当 UV-2550 被占用或样品近红外特征较弱时可作为交叉验证 |
| 圆二色光谱仪 (CD Spectrometer) | 采用圆偏振光的 UV-Vis 变体 | 测量样品对左/右圆偏振紫外光的差异吸收——揭示蛋白质二级结构（α-螺旋与 β-折叠）及手性，普通 UV-Vis 吸收无法区分 |

</div>

<script src="/content/research/layouts/tabs.js"></script>

---

<div class="footer"><a class="footer-github" href="/zh/">科学</a><div class="footer-nav"><a href="/zh/curriculum/">课程</a><a href="/zh/olympiads/">竞赛</a><a class="active" href="/zh/research/">研究</a></div></div>
