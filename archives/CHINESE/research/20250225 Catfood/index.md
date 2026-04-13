---
layout: chinese-project
project: 猫粮颜色偏好
photos:
  - /research/projects/20250225 Catfood/PHOTOS/20240901 Catfood A.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240901 Catfood B.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240901 Catfood C.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240901 Catfood D.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240906 Catfood.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240907 Catfood A.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240907 Catfood B.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood A.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood B.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood C.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood D.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood E.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood F.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood G.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood H.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood I.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood J.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood K.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood L.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240920 Catfood M.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240923 Catfood A.jpeg
  - /research/projects/20250225 Catfood/PHOTOS/20240923 Catfood B.jpeg
data_photos:
  - /research/projects/20250225 Catfood/DATA/20240901 Catfood B.jpeg
  - /research/projects/20250225 Catfood/DATA/20240907 Catfood B.jpeg
  - /research/projects/20250225 Catfood/DATA/20240920 Catfood N.jpeg
---

# 红色还是绿色，Mi更喜欢什么颜色的猫粮？

<div class="photo-grid" id="photo-grid">
  <img id="photo-0" alt="实验照片">
  <img id="photo-1" alt="实验照片">
  <img id="photo-2" alt="实验照片">
  <img id="photo-3" alt="实验照片">
</div>
<button class="shuffle-btn" onclick="shufflePhotos()">随机切换照片</button>

<script>var _pagePhotos = {{ page.photos | jsonify }};</script>
<script src="/archives/LAYOUT/shuffle.js"></script>

<div class="project-meta">2025年2月25日</div>

## 概述

猫更喜欢红色还是绿色的食物？本实验测试了一只英国短毛猫（Mi）是否对红色或绿色染色的猫粮表现出统计显著的偏好。普通干猫粮用食用色素染色，在30天内以两个并排碗呈现。记录Mi首先接近的碗作为当天的偏好。使用卡方检验来确定观察到的偏好是否显著不同于随机。

## 实验设置

| 类别 | 详情 |
|------|------|
| 实验对象 | 英国短毛猫（Mi） |
| 食物 | 普通干猫粮 |
| 染料 | 红色和绿色食用色素 |
| 份量 | 每碗每次10粒 |
| 持续时间 | 30天（2024年8–9月） |

将普通干猫粮分别与红色和绿色食用色素在不同罐中混合制备彩色猫粮。每天放置两个并排的碗——一碗10粒红色，一碗10粒绿色。碗的位置每天交替以控制方位偏差。记录Mi首先接近并开始进食的颜色作为其偏好。还追踪了剩余粒数、进食时间和食用色素浓度。Mi两碗都不吃的天数被排除。30天后，对观察到的偏好进行卡方拟合优度检验。

## 数据

原始数据记录在手写数据表上并拍照。每次实验追踪的变量包括：日期、份数、投放和剩余粒数、碗的位置（左/右）、进食时间和色素滴数。原始手写数据表的照片可在<a href="https://github.com/vivianweidai/science/tree/main/research/projects/20250225%20Catfood/DATA">DATA</a>中查看。偏好计数从手写记录转录到<a href="https://github.com/vivianweidai/science/blob/main/research/projects/20250225%20Catfood/OUTPUT/catfood_summary.csv">catfood_summary.csv</a>。

<div class="photo-grid three-col" id="data-grid">
  <img id="data-0" alt="数据表">
  <img id="data-1" alt="数据表">
  <img id="data-2" alt="数据表">
</div>

<script>
var allData = {{ page.data_photos | jsonify }};
(function() {
  for (var i = 0; i < allData.length; i++) {
    document.getElementById('data-' + i).src = allData[i];
  }
})();
</script>

## 结果

在30天中，Mi选择红色13天，绿色17天。自由度为1的卡方拟合优度检验得出检验统计量为0.533，远低于95%置信水平下的临界值3.841。未拒绝原假设（无颜色偏好）。Mi对红色或绿色猫粮没有表现出统计显著的偏好。

**注意 — 书面报告的更正：** Claude发现了原始PDF报告中的算术错误。报告将每个 (O − E)² 项除以30（观察总数）计算出 χ² = 0.266。正确的卡方公式应将每项除以该类别的期望计数（15），而非总数N。修正值为 χ² = (13 − 15)² / 15 + (17 − 15)² / 15 = 0.267 + 0.267 = **0.533**，如可重复笔记本中的计算所示。结论不变——两个值都远低于临界值3.841——但0.533是正确的检验统计量。

查看<a href="https://github.com/vivianweidai/science/blob/main/research/projects/20250225%20Catfood/OUTPUT/20250225%20Catfood.pdf">书面报告</a>、<a href="https://github.com/vivianweidai/science/blob/main/research/projects/20250225%20Catfood/OUTPUT/catfood_analysis.ipynb">静态笔记本</a>或<a href="https://colab.research.google.com/github/vivianweidai/science/blob/main/research/projects/20250225%20Catfood/OUTPUT/catfood_analysis.ipynb">自行运行可重复分析</a>。

---

<div class="footer"><div class="footer-nav"><a href="/archives/CHINESE/curriculum/">课程</a><a href="/archives/CHINESE/olympiads/">竞赛</a><a href="/archives/CHINESE/research/">研究</a></div><a class="footer-github" href="/research/projects/20250225%20Catfood/">English</a></div>
