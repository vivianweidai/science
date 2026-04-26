---
project: 四探针法
---

<div class="page-header"><h2>研究</h2><div class="header-nav"><a href="/zh/curriculum/">课程</a><a href="/zh/olympiads/">竞赛</a><a class="active" href="/zh/research/">研究</a></div></div>

# 四探针法薄层电阻测量

<div class="photo-grid" id="photo-grid">
  <img id="photo-0" alt="实验照片">
  <img id="photo-1" alt="实验照片">
  <img id="photo-2" alt="实验照片">
  <img id="photo-3" alt="实验照片">
</div>
<button class="shuffle-btn" onclick="shufflePhotos()">随机切换照片</button>

<script src="/research/layouts/shuffle.js"></script>

<div class="project-meta">2026年4月4日<br>Jandel RM3 Four-Point Probe</div>

## 概述

薄层电阻衡量电流在材料表面流动的难易程度，以欧姆每方块（Ω/□）为单位。它无需知道精确厚度即可表征导电材料。这很有用，因为材料厚度通常不均匀或难以精确测量，薄层电阻允许在厚度未知时直接比较材料和进行质量控制。

四探针技术将电流传输和电压检测功能分配给不同的探针对。Jandel RM3通过外侧两个探针施加已知电流，并测量内侧两个探针之间的电压降。由于几乎没有电流流过电压检测探针，每个探针尖端与样品表面之间的接触电阻完全从测量中消除——只捕获样品本身的电阻。

## 实验设置

| 类别 | 详情 |
|------|------|
| 仪器 | Jandel RM3 Four-Point Probe |
| 技术 | 四探针法——分离的电流和电压探针对消除接触电阻 |
| 测量 | 薄层电阻（Ω/□） |

将每个样品放在测量台上，四探针头降到表面，通过外侧探针施加电流，同时测量内侧两个探针之间的电压。每个样品测量多个点。

## 样品

<div class="hero-single"><img src="/research/projects/20260404 Four Point Probe/photos/setup/setup39.jpeg" alt="四探针下的三色带硬币"></div>

| 类别 | 样品 |
|------|------|
| 硬币 | 25美分硬币、1美分硬币（未抛光/半抛光/完全抛光） |
| 家用金属 | 不锈钢勺子、铝箔、金属垫圈、房门钥匙 |
| 生物样品 | 树叶 |
| 其他 | DVD、纸板 |

导电样品（硬币、家用金属）产生可测量的薄层电阻读数。非导电样品（树叶、DVD、纸板）在所有电流设置下均返回接触限或超出范围。1美分硬币被打磨成三个带——未处理的铜面、轻微抛光面和完全打磨露出锌的面——以比较表面状态的影响。每个样品在正向和反向电流方向上多次测量。

## 数据

原始数据为每次测量后拍摄的仪器显示屏照片，手动转录为CSV文件。原始照片在<a href="https://github.com/vivianweidai/science/tree/main/research/projects/20260404%20Four%20Point%20Probe/photos">photos</a>目录中，清洗后的<a href="https://github.com/vivianweidai/science/blob/main/research/projects/20260404%20Four%20Point%20Probe/output/four_point_probe_readings.csv">CSV</a>在<a href="https://github.com/vivianweidai/science/tree/main/research/projects/20260404%20Four%20Point%20Probe/output">output</a>目录中。

## 结果

共在9 µA下收集了56个有效薄层电阻读数。三个非导电样品（树叶、DVD、纸板）在所有电流设置下均返回接触限，一个金属垫圈读数因<a href="https://vivianweidai.com/research/projects/20260404%20Four%20Point%20Probe/photos/20260404%20Setup%2089.jpeg">电流量程错误（20 nA）</a>被排除——测试绝缘体样品时为了查看不同电流能否产生检测而改变了电流设置，测量垫圈前未重置。

| 样品 | 材料 | n | 平均值（Ω/□） | 范围 |
|------|------|--:|---------------|------|
| 25美分硬币 | 镀镍铜 | 2 | 37.8 | 37.6–37.9 |
| 勺子 | 不锈钢 | 7 | 39.0 | 36.6–41.5 |
| 1美分硬币（未抛光） | 镀铜锌 | 3 | 47.3 | 44.5–48.9 |
| 铝箔 | 铝 | 5 | 48.1 | 47.6–48.7 |
| 1美分硬币（半抛光） | 镀铜锌 | 10 | 48.6 | 46.1–51.8 |
| 1美分硬币（完全抛光） | 镀铜锌 | 16 | 50.1 | 47.5–55.7 |
| 铝箔（翻面） | 铝 | 3 | 54.7 | 52.8–56.2 |
| 金属垫圈 | 钢 | 5 | 54.8 | 53.2–56.2 |
| 房门钥匙 | 黄铜 | 5 | 57.2 | 56.1–58.3 |

25美分硬币和勺子是导电性最好的样品，黄铜钥匙最差——所有非金属均无法测量。两个结果引人注目：将1美分硬币从铜面打磨至锌面*增加了*薄层电阻（47.3 → 50.1 Ω/□），翻转铝箔也增加了电阻（48.1 → 54.7 Ω/□），表明哑光面和光亮面具有可测量的不同表面导电性。

<img src="/research/projects/20260404 Four Point Probe/output/mean_sheet_resistance.png" alt="各样品平均薄层电阻" class="result-img">

### 局限性

测量过程中读数波动显著——显示值持续漂移，即使在同一样品上不移动探针也无法完全稳定。同一物品的重复测量产生了较大的值分布，难以得出确切的定量结论。上表中的宽范围反映的是这种不稳定性而非测量点之间的真正差异。四探针法设计用于具有可控接触压力的平坦均匀样品，因此家用物品的不规则和弯曲表面可能是导致变异的原因。

查看<a href="https://github.com/vivianweidai/science/blob/main/research/projects/20260404%20Four%20Point%20Probe/output/four_point_probe_analysis.ipynb">静态笔记本</a>或<a href="https://colab.research.google.com/github/vivianweidai/science/blob/main/research/projects/20260404%20Four%20Point%20Probe/output/four_point_probe_analysis.ipynb">自行运行可重复分析</a>。

---

<div class="footer"><a class="footer-github" href="/zh/">科学</a><div class="footer-nav"><a href="/zh/curriculum/">课程</a><a href="/zh/olympiads/">竞赛</a><a class="active" href="/zh/research/">研究</a></div></div>
