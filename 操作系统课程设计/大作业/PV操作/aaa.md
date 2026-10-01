**题目草案**

**SLaTE: Sparse Latent Trajectory Features for Stage-Aware Interpretation and Feature-Guided Early Stopping in Latent Chain-of-Thought**

中文可写成：

**基于稀疏潜在轨迹特征的 latent CoT 阶段分解与特征引导早停**

这个题目把你想连起来做的两件事都放进去了：

- `1`：Delta-SAE / feature decomposition，解释 latent CoT 里不同阶段到底在干什么
- `3`：feature-guided control，把这些 feature 真正用起来做 early stopping / verifier

我会把它做成一篇 **“解释 + 因果验证 + 实用控制”** 的 AAAI 风格论文，而不是纯可视化 interpretability paper。

---

**一、问题定义**

latent CoT 现在有两个明显缺口：

1. **我们知道 step 重要，但不知道 step 里到底是什么在重要**  
   现有工作已经做到：
   - 哪一步被干预后会翻车
   - 哪些 step 之间有非局部传播
   - 什么时候输出已经偏向一个答案

   但它们还是停在 **step-level**。  
   还没有回答：

   - 第 3 步里是哪些 feature 在写候选答案？
   - 哪些 feature 在第 5/6 步才做 commitment？
   - 哪些 feature 只是 routing，不直接决定答案？

2. **latent CoT 缺少一个可解释的 test-time stopping / control 信号**  
   现有早停或切换策略大多依赖：
   - answer confidence
   - entropy
   - latent reward score
   - step count 固定预算

   但这些信号都比较粗。  
   如果我们能学出 feature-level 的“探索”“承诺”“稳定化”信号，就可以做更细的控制。

所以这篇 proposal 的核心问题是：

> **能否把 latent CoT 的每一步 hidden state 分解成一组稀疏功能特征，并证明这些特征既能解释 latent reasoning 的阶段结构，又能用于更好的 early stopping / control？**

---

**二、核心假设**

我建议把论文建立在 3 个明确假设上。

**H1.** latent CoT 的隐藏轨迹不是同质计算，而是由若干 **阶段性 feature family** 驱动。  
这些 feature family 至少包括：
- exploration / candidate-writing
- routing / relay
- commitment
- stabilization / verification

**H2.** 对 latent CoT 来说，直接对 `h_t` 做 SAE 不如对 **增量表示** 做 SAE 更合理。  
也就是：
\[
\Delta h_t = h_t - h_{t-1}
\]
更接近“这一步新增了什么 computation”。

**H3.** 用 feature-level 信号做 stopping / control，比只看 confidence、entropy 或固定 latent budget 更优，能得到更好的 **accuracy-efficiency Pareto front**。

---

**三、方法总览**

整篇方法分成两块：

### 模块 A：Delta-SAE for Latent CoT Decomposition
输入是 latent CoT 模型的轨迹：
\[
h_1, h_2, \dots, h_T
\]

我们不直接对 `h_t` 做 SAE，而是对：
\[
\Delta h_t = h_t - h_{t-1}
\]
做稀疏分解。

理由是：

- `h_t` 混着历史状态、背景信息、当前新增 computation
- `Δh_t` 更接近“第 t 步到底做了什么更新”

训练目标可以写成：

\[
z_t = E(\Delta h_t)
\]
\[
\widehat{\Delta h_t} = D(z_t)
\]
\[
\mathcal{L}_{sae} = \|\Delta h_t - \widehat{\Delta h_t}\|_2^2 + \lambda \|z_t\|_1
\]

其中：
- `E` 是 encoder
- `D` 是 decoder
- `z_t` 是 sparse code

在更强版本里，可以做 **context-conditioned Delta-SAE**：

\[
z_t = E(h_{t-1}, h_t)
\]
\[
\hat h_t = h_{t-1} + D(z_t)
\]

这样更接近 SSAE 的“当前 step 新增信息”思想，但迁移到 latent CoT。

---

### 模块 B：Feature-Guided Early Stopping / Control
训练好 SAE 之后，我们不只解释 feature，还把它们用于控制。

具体做一个 lightweight controller，输入是第 `t` 步的 feature activity，输出是：

- `continue latent reasoning`
- `stop and decode`

如果你愿意再强一点，还可以加第三个动作：
- `escalate to verifier / explicit fallback`

但我建议 AAAI 第一版先专注在 **early stopping**，更聚焦也更稳。

控制信号不直接看整条 hidden vector，而是看 feature family 的聚合量，比如：

- `ExplorationMass_t`
- `CommitmentMass_t`
- `RoutingMass_t`
- `StabilityMass_t`

控制规则可以有两种版本：

**版本 1：非参数控制器**
当：
- commitment feature 已高
- exploration feature 已低
- 最近几步 feature drift 很小

则停止。

**版本 2：轻量学习控制器**
训练一个小 MLP / linear head：
\[
p(\text{stop at } t \mid z_{1:t})
\]
用 supervision 标注“最早稳定可停步”。

我建议先做版本 1，再做版本 2 作为增强版。

---

**四、论文的真正创新点**

这篇 proposal 的创新点要写得很清楚，不然容易被审稿人看成“又一篇 SAE + 可视化”。

我建议主打这 4 点：

1. **首次把 step-level SAE 明确迁到 latent CoT 的 latent trajectory 上**  
   不是显式 CoT step，不是普通 token hidden，而是 latent reasoning step。

2. **提出 Delta-SAE / Incremental SAE 视角**  
   不分解状态本身，而分解每一步新增 computation。  
   这是方法上的小创新，但很关键。

3. **从 step-level 走到 feature-level 的 latent reasoning 解释**  
   现有工作最多说“第几步重要”，我们要回答“这一步里哪些 feature 在重要”。

4. **把 feature 解释和 early stopping 真正打通**  
   不是只看懂，还把它用作 test-time control。  
   这会让文章从纯解释论文变成“解释 + 实用方法”论文。

---

**五、和现有工作的关系与差异**

这部分你在引言和 related work 里必须讲透。

**和 SSAE 的差异**
- SSAE：显式 CoT step-level SAE
- 我们：latent CoT trajectory 的 Delta-SAE
- SSAE 解释的是文本 reasoning step
- 我们解释的是 hidden latent reasoning updates

**和 A Latent Computational Mode in LLMs 的差异**
- 它找的是整体 reasoning mode
- 我们关注的是 **step-wise latent trajectory 内部结构**
- 它不是在 latent CoT 模型上拆解“阶段功能”

**和 Causal Concept Graphs 的差异**
- 它学的是 sparse concept graph
- 我们先把问题限定在 latent CoT 的 step-feature 分解与 early stopping
- 如果主实验成功，后续可以自然扩展到 feature graph，但第一篇不建议太贪

**和那篇否定 SAE reasoning feature 的文章的关系**
- 它提醒我们：feature 可能只是 cue
- 我们会把 **cue-vs-causal** 作为实验设计的一部分，而不是回避它
- 这反而会让文章更扎实

**和 latent CoT 因果分析论文的关系**
- 它做 step-wise intervention、influence graph、commitment
- 我们可以把它当强 related work + 现成动机
- 它停在 step-level，我们进一步做到 feature-level

---

**六、技术路线细化**

### 1. 数据与平台

**主平台**
- Huginn-3.5B  
  理由：latent trajectory 定义最清楚，天然适合 step-wise 分解

**补充平台**
- Coconut 或一个连续 thought 模型  
  用来证明方法不是只对 recurrent-depth latent reasoning 有效

**任务**
建议覆盖三类：
- 数学：GSM8K, SVAMP, GSM-Symbolic
- 常识：CommonsenseQA / StrategyQA
- 代码：MBPP 或 HumanEval 小子集

这样工作量足够，也符合 AAAI 喜欢的“多任务验证”。

---

### 2. Feature discovery

对每个样本抽：
\[
h_1, h_2, ..., h_T
\]
再构造：
\[
\Delta h_t = h_t - h_{t-1}
\]

训练 SAE 后得到 feature activation：
\[
z_t \in \mathbb{R}^K
\]

然后给 feature 定义几个统计量：

- **Step concentration**  
  某个 feature 主要活跃在哪些 step

- **Correctness association**  
  feature 和 correct / incorrect trajectory 的关系

- **Answer association**  
  feature 和 final answer mode 的关系

- **Temporal drift**
  feature 是否在后期趋稳

- **Intervention sensitivity**
  去掉 feature 后 final answer / downstream hidden 的变化

再用这些统计量把 feature 聚成几类 family：
- exploration
- routing
- commitment
- stabilization

---

### 3. Feature-level causal validation

这是整篇最关键的硬度来源。

至少做三类干预：

**(a) Feature ablation**
- 在某一步把某个 feature 或 feature family 置零
- 用 decoder 重构回 `Δh_t`
- 看 final answer 变化、late-step readout 变化

**(b) Feature amplification**
- 放大某类 feature
- 看是否能延缓/加速 commitment
- 看是否能减少错误 trajectory

**(c) Random-matched control**
- 取相同稀疏度、相同幅度的随机 feature 对照
- 防止你只是因为改了向量范数就看见效果

如果能做到，再加一类更强的：

**(d) Cue falsification**
- 构造 lexical paraphrase / format perturbation
- 检查某个 feature 是否只是表面 cue 触发，而不是真 reasoning mechanism

这一步会显著增加文章说服力。

---

### 4. Feature-guided early stopping

设计一个 stopping score：

\[
S_t = f(\text{CommitmentMass}_t, \text{ExplorationMass}_t, \text{StabilityMass}_t, \Delta z_t)
\]

停止条件可以定义为：

- commitment 足够高
- exploration 足够低
- 最近几步 feature 漂移足够小

一个简单版本是规则式；
一个更强版本是训练一个 `stop predictor`。

**监督怎么来？**

可以定义“最早稳定可停步”：

对第 `t` 步解码，若满足：
- 当前步答案正确
- 从 `t` 继续往后到 `T`，答案基本不再变化
- 对局部小扰动不敏感

就把 `t` 当作一个正 stopping point。

这样 controller 学的是：
**不是 first-decodable，而是 first-stably-decodable。**

这点会特别漂亮，因为它正好和我们前面读过的那篇 latent CoT 因果论文对上。

---

**七、实验设计**

### 实验 1：分解质量
验证 Delta-SAE 是否比 vanilla SAE 更适合 latent CoT。

指标：
- reconstruction error
- sparsity
- feature diversity
- step concentration
- linear probing correctness / phase prediction

对比：
- SAE on `h_t`
- SAE on `Δh_t`
- PCA / ICA baseline
- token-level SAE baseline

预期结论：
- `Δh_t` 更稀疏、更阶段化、更容易解释

---

### 实验 2：阶段性 feature family
证明 latent CoT 有不同 feature family。

可视化：
- feature activation heatmap over steps
- family-level activation over time
- correct vs incorrect trajectory comparison

预期结论：
- early features 更像 exploration
- late features 更像 commitment/stabilization
- correct / incorrect 的 family 轨迹不同

---

### 实验 3：feature-level causality
做 ablation / amplification。

指标：
- answer flip rate
- downstream latent drift
- final answer confidence shift
- readout mode collapse timing

对比：
- feature family ablation
- random feature ablation
- whole-step ablation

预期结论：
- 少数 feature family 就能解释大部分 step-level effect
- step 不是最小有意义单元，feature 才更接近机制单元

---

### 实验 4：feature-guided early stopping
核心实用实验。

对比 baselines：
- fixed latent budget
- answer confidence stopping
- entropy stopping
- latent reward model stopping
- random stopping
- maybe simple step index heuristic

指标：
- accuracy
- average latent steps used
- latency / compute
- area under accuracy-efficiency curve
- compute-normalized accuracy

预期结论：
- feature-guided stopping 在相同准确率下能更早停
- 或在相同步数预算下更稳

---

### 实验 5：跨模型泛化
把在 Huginn 上学到的某些 stopping / family statistic 迁到另一个 latent reasoning model 上测试。

不用要求完全零迁移成功，但只要能证明：
- feature family 的部分规律有共性
- stopping 信号不是某个模型专属噪声

这会让文章站得更高一点。

---

**八、预期主要图表**

如果文章顺利，主文最应该有这些图：

1. **方法图**  
   latent trajectory -> Delta-SAE -> feature families -> early stopping controller

2. **Feature timeline 图**  
   不同 family 在 step 1...T 的平均激活

3. **Correct vs incorrect trajectory 图**  
   同一问题或同一数据集上，feature family 的动态差异

4. **Feature ablation 图**  
   不同 family 去掉后，flip rate / confidence / downstream drift 的变化

5. **Accuracy-efficiency Pareto 图**  
   feature-guided stopping vs confidence/entropy/LRM baselines

6. **Case study 图**
   展示某道题从 exploration feature 到 commitment feature 的演化

这套图出来，论文就会很完整。

---

**九、主要 baseline**

你这篇 baseline 要做足，不然 AAAI 容易说实验不够硬。

**解释类 baseline**
- raw hidden probing
- vanilla SAE on `h_t`
- PCA / ICA
- SSAE 思路 adapted baseline（如果能做）
- latent reward model / correctness probe

**控制类 baseline**
- fixed T
- answer confidence stopping
- entropy stopping
- LTO/LRM score stopping
- random stopping
- maybe “first decodable” stopping

---

**十、预期贡献写法**

最后 paper 的贡献可以写成：

1. 我们首次提出 **Delta-SAE** 视角来分解 latent CoT 的 step-wise computation，发现 latent reasoning 可被拆为稀疏的阶段性 feature family。  
2. 我们通过 feature-level intervention 证明，latent CoT 的关键因果作用集中在少量 feature family 上，而非均匀分布在整个 step hidden state 中。  
3. 我们提出 **feature-guided early stopping**，将解释性特征转化为 test-time control signal，在多个 latent reasoning benchmark 上获得更优的 accuracy-efficiency tradeoff。

---

**十一、风险点与应对**

**风险 1：feature 不稳定**
- 应对：多 seed、多任务、多模型验证 feature family 一致性

**风险 2：feature 只是 cue**
- 应对：random control + lexical falsification + causal ablation

**风险 3：early stopping 提升不明显**
- 应对：把 stopping 改成 verifier / rerank 信号
- 或转成“同精度更省步数”的 efficiency paper，而不是强追精度提升

**风险 4：Coconut 上不好复现**
- 应对：主文聚焦 Huginn，把跨架构泛化放附录或次要实验

---

**十二、为什么这题适合 AAAI**

AAAI 比较喜欢这种：

- 问题明确
- 方法不花哨但扎实
- 实验多、验证全面
- 解释性和实用性兼顾

这题正好符合：

- 有清晰 gap：latent CoT 缺 feature-level mechanism understanding
- 有明确方法：Delta-SAE + feature-guided stopping
- 有足够实验量：分解、因果、控制、跨任务、跨模型
- 有实际价值：能转化成更好的 test-time compute control

所以这题不是一篇“只讲 insight 的 workshop 风格工作”，而是完全有机会做成 AAAI 主会风格的论文。

---

**我建议的工作顺序**

1. 先只做 Huginn + GSM8K / SVAMP，验证 Delta-SAE 是否能学出稳定 family  
2. 再做 feature-level ablation，确保这条线不是纯故事  
3. 然后接 early stopping controller  
4. 最后扩到 CommonsenseQA / MBPP 和第二个 latent model

这样风险最低。

如果你愿意，我下一步可以直接把这份 mini proposal 再往下推一层，变成真正可以开做的东西：

- 具体模型输入输出长什么样
- Delta-SAE 的 loss 怎么写
- feature family 怎么自动聚类
- early stopping label 怎么构造
- 一周一周的实验计划怎么排

**目标先定死**

我们把这篇往一个很明确的 AAAI 题目推进：

**用 Delta-SAE 把 latent CoT 的 hidden trajectory 分解成阶段性 sparse features，并把这些 features 变成可解释的 early-stopping / control 信号。**

一句话版贡献：

1. 首次对 latent CoT 的 `h1...hT` 做 **incremental feature decomposition**  
2. 证明 step-level 重要性其实集中在少数 **feature families** 上  
3. 用这些 feature family 做 **更好的 test-time stopping**

---

**一、方法落地版**

我建议方法名先叫：

**SLaTE: Sparse Latent Trajectory Encoding for Stage-Aware Reasoning**

核心 pipeline：

```text
question x
  -> latent reasoning model
  -> latent trajectory h1...hT
  -> Delta-SAE on Δh_t
  -> sparse features z_t
  -> feature family discovery
  -> causal validation
  -> feature-guided stopping / control
```

这里最关键的是：

\[
\Delta h_t = h_t - h_{t-1}
\]

我们主打的不是对 `h_t` 做 SAE，而是对“这一步新增了什么”做 SAE。

---

**二、具体模型设计**

**模块 A：Delta-SAE**

输入：
\[
\Delta h_t \in \mathbb{R}^d
\]

编码：
\[
z_t = \text{ReLU}(W_e \Delta h_t + b_e)
\]

解码：
\[
\widehat{\Delta h_t} = W_d z_t + b_d
\]

损失：
\[
\mathcal{L}_{recon} = \|\Delta h_t - \widehat{\Delta h_t}\|_2^2
\]
\[
\mathcal{L}_{sparse} = \lambda \|z_t\|_1
\]
\[
\mathcal{L}_{total} = \mathcal{L}_{recon} + \mathcal{L}_{sparse}
\]

增强版可以加一个 temporal consistency 项：

\[
\mathcal{L}_{temp} = \gamma \sum_t \|z_t - z_{t-1}\|_1
\]

但我建议第一版先别加，先把基本版跑通。

---

**模块 B：feature family discovery**

对每个 feature `j`，构造一个统计描述向量：

\[
s_j = [
\text{step activation profile},
\text{correct-vs-wrong gap},
\text{answer-mode gap},
\text{ablation utility},
\text{temporal variance}
]
\]

然后做聚类：
- `HDBSCAN` 或 `spectral clustering`
- 先聚成 4 到 8 个 family
- 再人工命名

我建议最初目标只找出 4 类：

- `Exploration`
- `Routing`
- `Commitment`
- `Stabilization`

命名标准不是“看起来像”，而是靠后面的因果实验支撑。

---

**模块 C：feature-level causal validation**

对每个 feature 或 family 做三类干预。

1. **Ablation**
\[
z_t^{(-j)} = z_t,\quad z_{t,j}=0
\]
再解码回：
\[
\widetilde{\Delta h_t} = W_d z_t^{(-j)} + b_d
\]

2. **Amplification**
\[
z_{t,j} \leftarrow \alpha z_{t,j}, \alpha > 1
\]

3. **Random control**
保持稀疏度和范数相近，随机抹掉/放大对照 feature

然后测：

- final answer flip rate
- downstream latent drift
- answer confidence shift
- commitment time shift

我建议定义一个 feature 的 **Causal Utility**：

\[
CU_j = \mathbb{E}[ \Delta \log p(y^* \mid x) ]
\]

再定义一个 **Cue Sensitivity**：

\[
CS_j = \mathbb{E}[ |a_j(x) - a_j(\text{paraphrase}(x))| ]
\]

最后给一个 **Reasoning Index**：

\[
RI_j = \frac{CU_j}{CS_j + \epsilon}
\]

这会很好用。它能把“真 reasoning feature”和“只是 cue 的 feature”分开。

---

**模块 D：feature-guided early stopping**

定义 family mass：

\[
M_f(t) = \sum_{j \in \mathcal{F}_f} z_{t,j}
\]

其中 `f` 是 family，比如 exploration/commitment。

控制器输入用这些量：
- `M_explore(t)`
- `M_commit(t)`
- `M_stable(t)`
- `\|z_t - z_{t-1}\|_1`
- optional: answer confidence / entropy

先做一个 **规则版 stopping**：

在第 `t` 步停止，当且仅当：

1. `M_commit(t)` 高于阈值  
2. `M_explore(t)` 低于阈值  
3. `\|z_t - z_{t-1}\|_1` 足够小

然后再做一个 **学习版 stopping head**：

\[
p_{\phi}(\text{stop at } t \mid z_{1:t})
\]

用轻量 MLP 或 linear probe 就够了。

---

**三、stopping label 怎么构造**

这个是整篇里最重要的工程细节之一。

我们不要用“最早能答对”当标签，要用：

**最早稳定可停步** `t^*`

定义：

\[
t^* = \min \{ t :
\hat y_t = y^*,
\hat y_{t'} = \hat y_t \ \forall t' \in [t, T],
\text{and local perturbations at } t \text{ do not flip answer}
\}
\]

人话就是：

- 第 `t` 步开始已经能答对
- 后面继续想也不改答案
- 对这一步做小扰动也不容易翻车

这比 `first-decodable` 强很多，也更符合我们前面读到的 latent CoT causal paper。

---

**四、实验设置**

**主平台**
- Huginn-3.5B
- 如果复现成本太高，先在公开可跑的 recurrent-depth latent reasoning model 做缩小版

**辅助平台**
- Coconut 或 SoftCoT 风格模型，做泛化验证

**数据集**
- 数学：GSM8K, SVAMP, GSM-Symbolic
- 常识：CommonsenseQA 或 StrategyQA
- 代码：MBPP

**主指标**
- SAE 侧：
  - reconstruction error
  - sparsity
  - feature stability across seeds
- 解释侧：
  - correct-vs-wrong separability
  - feature family step concentration
  - RI 分数
- 控制侧：
  - accuracy
  - average latent steps used
  - latency / FLOPs proxy
  - accuracy-efficiency Pareto

**baseline**
- Fixed step budget
- First-decodable stopping
- Confidence-based stopping
- Entropy-based stopping
- Latent reward model stopping
- Vanilla SAE on `h_t`
- PCA / ICA
- random feature control

---

**五、最关键的图表**

主文里最应该有 6 张图：

1. 方法总图：trajectory -> Delta-SAE -> feature families -> stopping  
2. feature activation over steps：不同 family 的时间曲线  
3. correct vs wrong trajectories：family 级动态差异  
4. feature ablation heatmap：哪类 feature 改了影响最大  
5. cue-vs-causal 散点图：`CU_j` vs `CS_j`  
6. accuracy-efficiency Pareto：我们 vs stopping baselines

如果这 6 张图出来，故事会很完整。

---

**六、工作顺序**

我建议别一上来就摊太大，按这个顺序推进。

**第 1 周**
- 跑通 Huginn / latent reasoning 平台
- 抽取 `h1...hT`
- 做最基础的 first-decodable / stable-decodable 统计

**第 2 周**
- 训练 `SAE(h_t)` 和 `SAE(Δh_t)`
- 比较 reconstruction / sparsity / step separability

**第 3 周**
- 做 feature family 聚类
- 出第一版 timeline 图
- 看能不能人工命名出 3 到 4 类 family

**第 4 周**
- 做 feature ablation / amplification
- 计算 `CU_j`, `CS_j`, `RI_j`

**第 5 周**
- 先做规则版 feature-guided stopping
- 和 fixed / confidence / entropy 比

**第 6 周**
- 做学习版 stopping head
- 扩到第二个任务

**第 7 周**
- 扩第二个平台或第二任务族
- 做泛化与鲁棒性实验

**第 8 周**
- 整理论文图表
- 写 related work 和 discussion
- 补 negative results / failure cases

---

**七、最小可发表版本**

如果中途时间不够，先保底做这个版本也够像论文：

- 只做 Huginn
- 只做 2 个数据集：GSM8K + CommonsenseQA
- 只做 Delta-SAE + feature family + feature-guided stopping
- 不做跨模型泛化
- 但一定做 feature-level causal validation

这个版本已经足够有一个 AAAI 风格的完整故事。

---

**八、最需要提前规避的风险**

1. **Huginn 不好跑或复现慢**  
   方案：先做小规模 trajectory 抽取，不先追 full benchmark

2. **feature family 不稳定**  
   方案：多 seed 训练 SAE，只保留稳定重现的 feature

3. **feature 只是 cue**  
   方案：把 cue sensitivity 和 lexical perturbation 写进主实验，不要回避

4. **early stopping 提升不明显**  
   方案：主打 Pareto tradeoff，而不是只盯 accuracy 提升

---

**九、我对这篇 proposal 的最终判断**

这题最强的地方在于：

- 它不是凭空造新架构
- 但也不是纯可视化 interpretability
- 它把 latent CoT 的“看懂”直接接到“能控制”

这很适合 AAAI，因为它有：
- 明确新问题
- 方法上有一点新设计（Delta-SAE）
- 实验量充足
- 还能给出实际收益（更好的 stopping）

如果你愿意，下一步我可以直接继续给你写：

1. **论文摘要草稿**
2. **introduction 的四段式结构**
3. **method 章节的正式写法**
4. **第一周具体该做哪些实验脚本和数据抽取**