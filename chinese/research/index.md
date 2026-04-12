---
layout: chinese-default
---

<div class="page-header"><h2>研究</h2><a class="back-link" href="/chinese/">科学</a></div>

<div class="timeline">
  <div class="year-marker">2026</div>

  <div class="entry">
    <div class="top-line"><div class="month">四月</div>
    <div class="chips-cell"><span class="chip chem">化学</span></div></div>
    <div class="name-cell"><a href="20260411%20Centrifuge/">离心分离</a> — 日常液体的离心分离与pH测量</div>
  </div>

  <div class="entry">
    <div class="top-line"><div class="month">四月</div>
    <div class="chips-cell"><span class="chip chem">化学</span></div></div>
    <div class="name-cell"><a href="20260405%20Melting%20Point/">熔点测定</a> — 咖啡因与阿司匹林的熔点测定</div>
  </div>

  <div class="entry">
    <div class="top-line"><div class="month">四月</div>
    <div class="chips-cell"><span class="chip phys">物理</span></div></div>
    <div class="name-cell"><a href="20260404%20Four%20Point%20Probe/">四探针法</a> — 导电材料的薄层电阻测量</div>
  </div>

  <div class="entry hl">
    <div class="top-line"><div class="month">四月</div>
    <div class="chips-cell"><span class="chip chem">化学</span></div></div>
    <div class="name-cell"><a href="20260401%20IR%20Spectroscopy/">红外光谱</a> — 日常材料的官能团鉴定</div>
  </div>

  <div class="entry">
    <div class="top-line"><div class="month">四月</div>
    <div class="chips-cell"><span class="chip bio">生物</span></div></div>
    <div class="name-cell"><a href="20260401%20Genes%20in%20Space/">太空基因</a> — 微重力环境下的基因表达变化</div>
  </div>

  <div class="year-marker">2025</div>

  <div class="entry">
    <div class="top-line"><div class="month">二月</div>
    <div class="chips-cell"><span class="chip comp">计算</span></div></div>
    <div class="name-cell"><a href="20250225%20Catfood/">猫粮颜色偏好</a> — 红色与绿色食物偏好实验</div>
  </div>
</div>

<style>
  .timeline { border-left: 2px solid #d1d9e0; margin-left: .8em; padding-left: 1.2em; }
  .timeline .year-marker { font-weight: 700; font-size: 1.1em; margin: 1.2em 0 .4em 0; }
  .timeline .entry {
    display: grid;
    grid-template-columns: 6.5em auto 1fr;
    gap: 0 .5em;
    padding: .35em 0;
    font-size: .95em;
    align-items: first baseline;
  }
  .timeline .entry .top-line {
    display: contents;
  }
  .timeline .entry .month { color: #656d76; font-variant-numeric: tabular-nums; white-space: nowrap; }
  .timeline .entry .chips-cell { white-space: nowrap; display: flex; gap: 2px; align-items: center; }
  .timeline .entry .name-cell { }
  .timeline .entry.hl { position: relative; }
  .timeline .entry.hl::before { content: ''; position: absolute; inset: -.1em -.4em; background: #fff44f; border-radius: 6px; z-index: -1; }
  .timeline .entry .name-cell a { color: #0969da; text-decoration: none; font-weight: 600; }
  .timeline .entry .name-cell a:hover { text-decoration: underline; }

  .chip {
    display: inline-block; padding: 1px 7px; border-radius: 999px;
    font-size: .72em; font-weight: 600; color: #1f2328;
    text-align: center; white-space: nowrap; line-height: 1.6;
  }
  .chip.math  { background: #c5d9f7; }
  .chip.comp  { background: #d9ccee; }
  .chip.phys  { background: #f9c4a8; }
  .chip.chem  { background: #cdeaa6; }
  .chip.bio   { background: #b8e0c4; }
  .chip.astro { background: #f4c2cb; }

  @media (max-width: 600px) {
    .timeline .entry {
      display: flex;
      flex-direction: column;
      gap: .15em;
      padding: .5em 0;
    }
    .timeline .entry .top-line {
      display: flex;
      align-items: center;
      gap: .35em;
      flex-wrap: wrap;
    }
    .timeline .entry .month { display: inline; font-size: .82em; }
    .timeline .entry .chips-cell { display: inline-flex; }
    .timeline .entry .name-cell { font-size: .95em; line-height: 1.4; }
  }
</style>

---

### 仪器设备

- <span class="chip chem">化学</span> <a href="20260401%20IR%20Spectroscopy/">Thermo Scientific Nicolet 380 FT-IR Spectrometer</a> — 中红外吸收/透射光谱
- <span class="chip chem">化学</span> <a href="20260405%20Melting%20Point/">OptiMelt Automated Melting Point System</a> — 熔点测定
- <span class="chip chem">化学</span> <a href="20260411%20Centrifuge/">Thermo Scientific Refrigerated Centrifuge</a> — 按密度分离混合物
- <span class="chip chem">化学</span> <a href="20260411%20Centrifuge/">VWR pH 1100 L</a> — 台式pH测量
- <span class="chip phys">物理</span> <a href="20260404%20Four%20Point%20Probe/">Jandel RM3 Four-Point Probe</a> — 薄层电阻测量
- <span class="chip bio">生物</span> <a href="20260401%20Genes%20in%20Space/">miniPCR Thermal Cycler</a> — DNA/RNA靶标的PCR扩增
- <span class="chip bio">生物</span> <a href="20260401%20Genes%20in%20Space/">P51 Fluorescence Viewer</a> — 荧光检测与凝胶成像
- <span class="chip bio">生物</span> <a href="20260401%20Genes%20in%20Space/">BioBits Cell Free System</a> — DNA模板的体外蛋白表达
- <span class="chip comp">计算</span> GitHub、Python与Jupyter Notebooks — 统计分析与可重复研究流程

---

### 仓库结构

所有项目均按以下文件夹结构记录：

```
YYYYMMDD 项目名称/
├── DATA/       # 原始仪器数据
├── PHOTOS/     # 实验照片
├── PAPERS/     # 参考文献
├── OUTPUT/     # 分析与报告
└── index.md    # 项目概述页面
```

---

<div class="footer"><div class="footer-nav"><a href="/chinese/curriculum/">课程</a><a href="/chinese/olympiads/">竞赛</a><a href="/chinese/research/">研究</a></div><a class="footer-github" href="/research/">English</a></div>
