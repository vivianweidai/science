---
layout: chinese-project
project: 红外光谱
photos:
  - /research/20260401 IR Spectroscopy/PHOTOS/20260404 Setup A.jpeg
  - /research/20260401 IR Spectroscopy/PHOTOS/20260404 Setup B.jpeg
  - /research/20260401 IR Spectroscopy/PHOTOS/20260404 Setup C.jpeg
  - /research/20260401 IR Spectroscopy/PHOTOS/20260404 Setup D.jpeg
  - /research/20260401 IR Spectroscopy/PHOTOS/20260404 Setup E.jpeg
  - /research/20260401 IR Spectroscopy/PHOTOS/20260404 Setup F.jpeg
  - /research/20260401 IR Spectroscopy/PHOTOS/20260404 Samples A.jpeg
  - /research/20260401 IR Spectroscopy/PHOTOS/20260404 Samples B.jpeg
---

# 日常材料的红外光谱分析

<div class="photo-grid" id="photo-grid">
  <img id="photo-0" alt="实验照片">
  <img id="photo-1" alt="实验照片">
  <img id="photo-2" alt="实验照片">
  <img id="photo-3" alt="实验照片">
</div>
<button class="shuffle-btn" onclick="shufflePhotos()">随机切换照片</button>

<script>var _pagePhotos = {{ page.photos | jsonify }};</script>
<script src="/archives/LAYOUT/shuffle.js"></script>

<div class="project-meta">2026年4月1日<br>Thermo Scientific Nicolet 380 FT-IR Spectrometer（ATR模式）</div>

## 概述

傅里叶变换红外（FT-IR）光谱通过测量材料吸收的红外频率来鉴定其中的极性共价键。不同的官能团——O-H、C=O、C-H、N-H等——在特征频率处振动，为每种化合物产生独特的吸收指纹。本次实验对常见家用和实验室材料进行了调查，使用ATR模式的FT-IR光谱仪采集每个样品在中红外范围（~550–4000 cm⁻¹）内的光谱，建立光谱参考库并鉴定日常物质中的特征官能团。

## 实验设置

| 类别 | 详情 |
|------|------|
| 仪器 | Thermo Scientific Nicolet 380 FT-IR Spectrometer |
| 模式 | 衰减全反射（ATR） |
| 范围 | ~550–4000 cm⁻¹ |
| 分辨率 | 每个光谱约7,150个数据点 |
| 运行 | 两次实验（19 + 6个样品） |
| 软件 | Thermo Scientific OMNIC 8 |

首先采集背景光谱以建立基线。每个样品直接放置在ATR晶体上——在ATR模式下，红外光束在晶体内部全反射，倏逝波穿透样品表面几微米，因此无需任何样品制备即可直接测量。在中红外范围内采集光谱，并从OMNIC 8导出<a href="https://github.com/vivianweidai/science/tree/main/research/20260401%20IR%20Spectroscopy/DATA">原始CSV数据</a>。

## 样品

<div class="hero-single"><img src="/research/20260401 IR Spectroscopy/PHOTOS/20260404 Samples B.jpeg" alt="样品"></div>

| 类别 | 样品 |
|------|------|
| 溶剂 | 丙酮、异丙醇、水 |
| 食品/矿物 | 咖啡、盐、糖 |
| 个人护理 | 肥皂、洗发水、护发素、乳液、防晒霜、清洁剂 |
| 聚合物 | 塑料袋、塑料瓶盖、塑料手套、塑料包装纸 |
| 纸张 | 纸、纸塑杯 |
| 生物样品 | 手指、树叶、橙皮 |
| 对照 | 背景 |

## 数据

原始光谱以CSV文件形式保存，每个文件包含两列（波数cm⁻¹和透射率%），每个光谱约7,150个数据点。数据分为两次实验：<a href="https://github.com/vivianweidai/science/tree/main/research/20260401%20IR%20Spectroscopy/DATA/ONE">第一次</a>（19个样品）和<a href="https://github.com/vivianweidai/science/tree/main/research/20260401%20IR%20Spectroscopy/DATA/TWO">第二次</a>（6个样品），分别在不同日期进行。

## 方法

仪器（Nicolet 380）自动进行背景校正——每个样品的透射率已相对于背景光谱测量，因此非吸收区域读数约为100%透射率。<a href="https://github.com/vivianweidai/science/blob/main/research/20260401%20IR%20Spectroscopy/OUTPUT/clean_data.py">数据清洗流程</a>：

1. **解析** — 原始CSV使用科学计数法且无表头；每个文件被解析为波数和透射率数值列。
2. **转换为吸光度** — 使用 A = −log₁₀(T/100) 将透射率转换为吸光度，其中T为百分透射率。吸光度无量纲，通过Beer-Lambert定律与浓度成正比。
3. **导出** — 所有23个样品保存为带表头（波数、透射率、吸光度）的清洗CSV文件，存入<a href="https://github.com/vivianweidai/science/tree/main/research/20260401%20IR%20Spectroscopy/OUTPUT/SCRUBBED">SCRUBBED</a>文件夹。

所有光谱图、峰值鉴定和分类叠加图均使用清洗数据通过Python库在<a href="https://github.com/vivianweidai/science/blob/main/research/20260401%20IR%20Spectroscopy/OUTPUT/ir_analysis.ipynb">分析笔记本</a>中生成。

## 结果

### 代表性样品

<div class="tabs">
  <input type="radio" name="spec-tab" id="tab-acetone">
  <input type="radio" name="spec-tab" id="tab-water">
  <input type="radio" name="spec-tab" id="tab-salt">
  <input type="radio" name="spec-tab" id="tab-plastic">
  <input type="radio" name="spec-tab" id="tab-sugar">

  <div class="tab-labels">
    <label for="tab-acetone">丙酮</label>
    <label for="tab-water">水</label>
    <label for="tab-salt">盐</label>
    <label for="tab-plastic">塑料袋</label>
    <label for="tab-sugar">糖</label>
  </div>

  <div class="tab-content" id="content-acetone">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/acetone_spectrum.png" alt="丙酮光谱" class="result-img">
    <p>丙酮显示出教科书级的红外光谱。~1,715 cm⁻¹处的主峰是C=O羰基伸缩振动——酮类中最强最具特征性的吸收。C–H甲基伸缩振动出现在2,950–3,000 cm⁻¹附近，~1,350–1,450 cm⁻¹处的峰为C–H弯曲振动（CH₃基团的对称和不对称剪式振动），1,000–1,300 cm⁻¹区域的尖锐峰对应C–O和C–C骨架伸缩振动。宽阔O–H带的缺失证实样品是无水的。</p>
  </div>

  <div class="tab-content" id="content-water">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/water_spectrum.png" alt="水光谱" class="result-img">
    <p>水产生经典的宽阔O–H伸缩带，中心约在3,300 cm⁻¹，由于氢键作用几乎跨越整个3,000–3,600 cm⁻¹区域。~1,640 cm⁻¹处的尖锐峰是O–H弯曲（剪式）振动模式。1,000 cm⁻¹以下上升的强吸收是液态水的摇摆振动模式。</p>
  </div>

  <div class="tab-content" id="content-salt">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/salt_spectrum.png" alt="盐光谱" class="result-img">
    <p>盐（NaCl）是离子化合物，没有共价键，因此产生几乎平坦的基线，无特征红外吸收。可见的微小特征可能是表面水分（微量O–H）和大气CO₂干扰。这使得盐成为有效的阴性对照，也解释了为什么NaCl传统上用于红外样品窗口。</p>
  </div>

  <div class="tab-content" id="content-plastic">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/plastic_bag_spectrum.png" alt="塑料袋光谱" class="result-img">
    <p>聚乙烯（塑料袋）显示出几乎纯粹的C–H光谱。~2,920和~2,850 cm⁻¹处的尖锐双峰对应CH₂主链的不对称和对称C–H伸缩振动。~1,460 cm⁻¹（剪式）和~720 cm⁻¹（摇摆）处的C–H弯曲峰完成了这幅图景。没有O–H、C=O或其他杂原子峰——只有碳和氢。</p>
  </div>

  <div class="tab-content" id="content-sugar">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/sugar_spectrum.png" alt="糖光谱" class="result-img">
    <p>糖（蔗糖）在3,000–3,500 cm⁻¹处显示出宽阔的O–H伸缩带，来自其众多羟基，加上1,500 cm⁻¹以下丰富的指纹区，主要由糖苷键和糖环的C–O伸缩振动主导。指纹区的复杂性反映了分子的大小——每种糖都有独特的红外指纹，可用于鉴定。</p>
  </div>
</div>


### 家用品分类

<div class="tabs">
  <input type="radio" name="cat-tab" id="cat-solvents">
  <input type="radio" name="cat-tab" id="cat-food">
  <input type="radio" name="cat-tab" id="cat-personal">
  <input type="radio" name="cat-tab" id="cat-polymers">
  <input type="radio" name="cat-tab" id="cat-paper">
  <input type="radio" name="cat-tab" id="cat-biological">

  <div class="cat-tab-labels tab-labels">
    <label for="cat-solvents">溶剂</label>
    <label for="cat-food">食品/矿物</label>
    <label for="cat-personal">个人护理</label>
    <label for="cat-polymers">聚合物</label>
    <label for="cat-paper">纸张</label>
    <label for="cat-biological">生物样品</label>
  </div>

  <div class="tab-content" id="content-solvents">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/solvents_spectrum.png" alt="溶剂光谱" class="result-img">
    <p>三种键合方式截然不同的溶剂。<strong>水</strong>以其宽阔的O–H伸缩带（中心约3,300 cm⁻¹）和尖锐的O–H弯曲峰（~1,640 cm⁻¹）为主导。<strong>异丙醇</strong>结合了宽阔的O–H带（氢键合醇）、~2,950 cm⁻¹处的强C–H伸缩和1,000–1,150 cm⁻¹附近丰富的C–O伸缩区。<strong>丙酮</strong>以其~1,715 cm⁻¹处尖锐的C=O羰基峰脱颖而出——酮类的标志——且无O–H带，确认其为无水状态。</p>
  </div>

  <div class="tab-content" id="content-food">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/food_minerals_spectrum.png" alt="食品/矿物光谱" class="result-img">
    <p><strong>咖啡</strong>在3,300 cm⁻¹附近产生宽阔的O–H带（来自水和有机酸中的羟基），加上指纹区中来自咖啡因、绿原酸和脂质的C=O和C–O吸收。<strong>糖</strong>（蔗糖）由于其众多羟基也显示出类似的宽阔O–H区域，但其1,500 cm⁻¹以下的指纹区由糖苷键和糖环的强烈C–O伸缩振动主导——每种糖在此处都有独特的指纹。<strong>盐</strong>（NaCl）是异类：作为纯离子化合物，没有共价键，它产生几乎完美平坦的基线——没有红外活性振动可以吸收。</p>
  </div>

  <div class="tab-content" id="content-personal">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/personal_care_spectrum.png" alt="个人护理光谱" class="result-img">
    <p>个人护理产品是复杂的混合物，但共享共同特征。所有六个样品在3,000–3,500 cm⁻¹处显示宽阔的O–H/N–H带，来自水、甘油和脂肪醇。~2,920/2,850 cm⁻¹处的C–H伸缩反映了长链脂肪酸和表面活性剂。<strong>肥皂</strong>和<strong>清洁剂</strong>以更尖锐的C–H峰和更强的指纹吸收突出，而<strong>洗发水</strong>、<strong>护发素</strong>和<strong>乳液</strong>聚集在一起——考虑到它们类似的水和表面活性剂配方，这并不意外。<strong>防晒霜</strong>因紫外线过滤化合物中的额外C=O吸收而与众不同。</p>
  </div>

  <div class="tab-content" id="content-polymers">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/polymers_spectrum.png" alt="聚合物光谱" class="result-img">
    <p>四个塑料样品表明并非所有聚合物都相同。<strong>塑料袋</strong>（聚乙烯）和<strong>塑料包装纸</strong>都显示经典的PE特征：~2,920/2,850 cm⁻¹处尖锐的C–H双峰，其他吸收极少。<strong>塑料瓶盖</strong>（聚丙烯）增加了甲基C–H肩峰和额外的弯曲峰。<strong>塑料手套</strong>（丁腈或乙烯基）是异类——其光谱包括C=O、C–O和可能的C≡N伸缩，揭示了一种含杂原子官能团的更复杂聚合物。</p>
  </div>

  <div class="tab-content" id="content-paper">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/paper_spectrum.png" alt="纸张光谱" class="result-img">
    <p><strong>纸</strong>主要是纤维素——3,000–3,500 cm⁻¹处宽阔的O–H伸缩来自多糖链上的羟基，1,000–1,150 cm⁻¹处强烈的C–O吸收是糖苷键的特征。<strong>纸塑杯</strong>在纤维素基底上叠加了聚乙烯涂层：新增的~2,920/2,850 cm⁻¹ C–H伸缩揭示了PE内衬，而纸基底的O–H和C–O带依然可见。</p>
  </div>

  <div class="tab-content" id="content-biological">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/biological_spectrum.png" alt="生物样品光谱" class="result-img">
    <p>生物样品化学成分丰富。<strong>手指</strong>（皮肤）显示角蛋白的酰胺I带（~1,640 cm⁻¹）和酰胺II带（~1,540 cm⁻¹），加上脂质C–H伸缩和宽阔的O–H/N–H区域。<strong>树叶</strong>结合了纤维素特征（O–H、C–O）与角质层蜡质C–H峰和可能的叶绿素吸收。<strong>橙皮</strong>以萜烯和精油特征为主——强烈的C–H伸缩、来自柠檬酸或酯的C=O带，以及来自果皮中果胶和糖的复杂C–O吸收。</p>
  </div>
</div>


### 化学分类

<div class="tabs">
  <input type="radio" name="chem-tab" id="chem-oh">
  <input type="radio" name="chem-tab" id="chem-ch">
  <input type="radio" name="chem-tab" id="chem-co">
  <input type="radio" name="chem-tab" id="chem-mixed">
  <input type="radio" name="chem-tab" id="chem-cellulose">
  <input type="radio" name="chem-tab" id="chem-protein">
  <input type="radio" name="chem-tab" id="chem-ionic">

  <div class="chem-tab-labels tab-labels">
    <label for="chem-oh">O–H主导</label>
    <label for="chem-ch">C–H主导</label>
    <label for="chem-co">羰基</label>
    <label for="chem-mixed">有机物</label>
    <label for="chem-cellulose">纤维素</label>
    <label for="chem-protein">蛋白质</label>
    <label for="chem-ionic">离子</label>
  </div>

  <div class="tab-content" id="content-chem-oh">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/chem_oh_spectrum.png" alt="O–H主导光谱" class="result-img">
    <p><strong>水、咖啡、糖、乳液、洗发水、护发素</strong>——都以3,200–3,600 cm⁻¹处宽阔的O–H伸缩带作为最突出的特征。无论羟基来自液态水、溶解的糖还是化妆品中的甘油，氢键合O–H伸缩主导了光谱。指纹区各有不同——糖和咖啡显示丰富的C–O模式，而个人护理产品更平滑——但O–H特征将它们联系在一起。</p>
  </div>

  <div class="tab-content" id="content-chem-ch">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/chem_ch_spectrum.png" alt="C–H主导光谱" class="result-img">
    <p><strong>塑料袋、塑料瓶盖、塑料包装纸（×2）</strong>——几乎完全由碳和氢组成的聚烯烃塑料。~2,920/2,850 cm⁻¹处尖锐的C–H伸缩双峰和~1,460 cm⁻¹处的C–H弯曲几乎是唯一的特征。这些光谱高度重叠，因为底层聚合物（聚乙烯或聚丙烯）化学结构简单——没有杂原子的长碳氢链。</p>
  </div>

  <div class="tab-content" id="content-chem-co">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/chem_co_spectrum.png" alt="羰基光谱" class="result-img">
    <p><strong>丙酮、防晒霜</strong>——都在~1,715 cm⁻¹处产生强烈的C=O羰基伸缩。在丙酮中是酮羰基；在防晒霜中来自含有酯基或酮基的紫外线吸收化合物（阿伏苯宗、桂皮酸盐）。尽管是完全不同的产品，羰基峰都是二者的决定性光谱特征。</p>
  </div>

  <div class="tab-content" id="content-chem-mixed">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/chem_mixed_spectrum.png" alt="混合有机物光谱" class="result-img">
    <p><strong>异丙醇、肥皂、清洁剂、橙皮</strong>——这些样品显示多种官能团且无单一主导。异丙醇的O–H、C–H和C–O均处于平衡状态。肥皂和清洁剂含有脂肪酸盐，带有C–H链和羧酸盐基团。橙皮是萜烯、柠檬酸、果胶和精油的天然混合物——产生了几乎每个区域都有贡献的繁忙光谱。</p>
  </div>

  <div class="tab-content" id="content-chem-cellulose">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/chem_cellulose_spectrum.png" alt="纤维素光谱" class="result-img">
    <p><strong>纸、纸（第二次）、纸塑杯、树叶</strong>——都含有纤维素作为结构骨架。特征模式是宽阔的O–H带（多糖链上的羟基）与1,000–1,150 cm⁻¹处来自糖苷键的强C–O伸缩。纸塑杯在纤维素基底上增加了聚乙烯C–H峰。树叶包含额外的角质层蜡质特征，但底层纤维素框架清晰可见。</p>
  </div>

  <div class="tab-content" id="content-chem-protein">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/chem_protein_spectrum.png" alt="蛋白质/酰胺光谱" class="result-img">
    <p><strong>手指（皮肤）、塑料手套</strong>——一个出人意料的组合。人体皮肤（角蛋白）在~1,640 cm⁻¹显示经典的酰胺I带，在~1,540 cm⁻¹显示酰胺II带，来自蛋白质肽键。塑料手套（丁腈或乙烯基）由于其聚合物结构也显示类似酰胺的吸收。两个光谱都具有这些中程羰基/氮带，将它们与更简单的碳氢化合物或羟基主导的组别区分开来。</p>
  </div>

  <div class="tab-content" id="content-chem-ionic">
    <img src="/research/20260401 IR Spectroscopy/OUTPUT/IMAGES/chem_ionic_spectrum.png" alt="离子光谱" class="result-img">
    <p><strong>盐</strong>——NaCl是纯离子化合物，没有共价键，因此没有红外活性振动，产生基本平坦的基线。微小的特征是表面微量水分和大气CO₂。盐是唯一没有分子吸收特征的样品——这正是NaCl历史上被用于制造红外透明窗口和压片的原因。</p>
  </div>
</div>


<script src="/archives/LAYOUT/tabs.js"></script>

查看<a href="https://github.com/vivianweidai/science/blob/main/research/20260401%20IR%20Spectroscopy/OUTPUT/ir_analysis.ipynb">静态笔记本</a>或<a href="https://colab.research.google.com/github/vivianweidai/science/blob/main/research/20260401%20IR%20Spectroscopy/OUTPUT/ir_analysis.ipynb">自行运行可重复分析</a>。

---

<div class="footer"><div class="footer-nav"><a href="/archives/CHINESE/curriculum/">课程</a><a href="/archives/CHINESE/olympiads/">竞赛</a><a href="/archives/CHINESE/research/">研究</a></div><a class="footer-github" href="/research/20260401%20IR%20Spectroscopy/">English</a></div>
