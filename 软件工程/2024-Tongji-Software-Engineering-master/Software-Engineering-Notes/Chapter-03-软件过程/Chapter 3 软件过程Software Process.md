**软件过程结构 (Software Process Structure)**

软件过程是为构建高质量软件而执行的一系列活动、方法和实践的框架。第三章主要探讨了软件过程的结构，包括**框架活动 (Framework Activities)，伞状活动(Umbrella Activities)和过程模式 (Process Patterns)**。



## 3.1 通用过程模型Generic Process Model

通用过程框架(generic process framework) 定义了5个框架活动(framework activity)——CPMCD，以及一系列伞活动(umbrella activity)——project tracking and control, risk management, quality assurance, configuration management, technical reviews, and others

**※软件过程框架Software process framework**

通用过程框架(generic process framework) 包含两部分

- 框架活动(framework activity)(CPMCD)——development dimension开发维度
- 伞型活动(umbrella activity)——management dimension管理维度(评审，QA等）

framework activity → software engineering action → task sets

action是若干个task sets，其内容：

- T：工作任务 work tasks：
  - 行动模型中的具体活动。比如编写代码、进行测试或者撰写文档。这些是行动模型中具体的步骤，定义了达到目标所必须执行的活动。
- P：工作产品 work products:：
  - 工作产品是执行工作任务后生成的结果物，如软件代码、测试报告、用户手册等。这些产品是物理的或电子的，可以是文档、软件模块、设计图等等。
- Q：质量保证点 quality assurance( QA ) points:：
  - 产生work products后要有质量保证。质量保证点是确保工作产品满足既定标准的检查点。在这些点上，可能会进行代码审查、设计评审、测试结果评估等，以确保产品质量符合要求。
- M：里程碑 milestone:：形成里程碑
  - 里程碑是项目中的一个关键事件或成就，代表了项目的一个重要阶段的完成。通常，在达到里程碑时，会有一个评估过程，以确定项目是否按计划进行，这可能包括完成特定的工作产品和通过质量保证点。

![Untitled](Chapter%203%20%E8%BD%AF%E4%BB%B6%E8%BF%87%E7%A8%8BSoftware%20Process%20e7160395fe3c4f20856e027664643d8a/Untitled.png)

我们应该注意，尚未讨论软件过程的一个重要方面。这个方面被称为过程流程process flow - 描述了如何在序列和时间内组织在每个框架活动中发生的框架活动和动作和任务

**※工作流Process flow**

种类:

1. Linear
2. Iterative
3. Evolutionary
4. Parallel
- **线性工作流和迭代工作流**

![Untitled](Chapter%203%20%E8%BD%AF%E4%BB%B6%E8%BF%87%E7%A8%8BSoftware%20Process%20e7160395fe3c4f20856e027664643d8a/Untitled%201.png)

迭代流的几个迭代箭头：

1. communication和planning反复迭代(planning后，由于1.需求变更;2. 技术和业务更深层的理解;3. 有错误等，重复迭代)→CUE
2. modeling部分的迭代
3. construction后(coding&testing)，可能在testing时发现需求不明确，又回到了前面四个阶段迭代
- **演化工作流(Evolutionary)——螺旋上升**

![Untitled](Chapter%203%20%E8%BD%AF%E4%BB%B6%E8%BF%87%E7%A8%8BSoftware%20Process%20e7160395fe3c4f20856e027664643d8a/Untitled%202.png)

解读：本质还是迭代开发

Planning不回到Communication: 在planning阶段发现有communication的问题，但不回去，而是记录下来直到把本次迭代做完，不论有多少问题，都先进行完本次开发

increment released: **和单纯的迭代流不同，每次迭代完必须要有一个可展示的产品**

每一次的输入（下次迭代要解决的问题）：下次开发的新功能+本次开发中记录下来的问题+用户使用这个increment的产品后反馈要解决的问题

- **并行工作流(Parallel)**

![Untitled](Chapter%203%20%E8%BD%AF%E4%BB%B6%E8%BF%87%E7%A8%8BSoftware%20Process%20e7160395fe3c4f20856e027664643d8a/Untitled%203.png)

planning和modeling同时做，在communication时导出需求，可以进行planning；同时明确的部分可以进行modeling
**1. 软件过程框架 (Software Process Framework)**

- **定义：** 软件过程框架为软件开发提供了一个基础结构，它定义了软件开发过程中的关键活动和流程。
- **通用框架活动**：一个通用的软件工程框架包含5个活动:
    - **沟通 (Communication)**：在项目开始之前，与客户和其他干系人沟通，了解他们的需求，并定义软件的功能和特性。
    - **计划 (Planning)**：制定软件开发计划，包括时间表，资源分配和风险管理。这涉及对项目进行评估，制定详细的计划并进行跟踪
    - **建模 (Modeling)**：创建软件的抽象表示，如用例图、类图和数据模型。这可以帮助更好地理解问题，并为设计提供基础.
    - **构建 (Construction)**：根据设计创建实际的软件代码。这包括代码生成（手动或自动）和测试，以发现代码中的错误。
    - **部署 (Deployment)**：将软件交付给客户，提供支持并收集反馈。
- **特点**：
    - **并非严格线性**：这些框架活动不是严格按照顺序执行的，而是 **以迭代的方式进行**。在实际项目中，这些活动可以被重复执行多次，并且在项目进展中不断完善。
    - **适应性强**: 不同的项目可能需要不同细节的软件过程，**框架活动需要根据项目特点进行调整**。例如，小型项目可能只需要简单的框架活动，而大型项目则需要更详细的框架活动。
    - **迭代**： 每个迭代都会产生一个 **软件增量**，并提供给干系人进行反馈，以便持续改进。
## 3.2 定义框架活动Framework Activity

**关键问题**：框架活动的关键问题：考虑到要解决的问题的性质、从事工作的人员的特征以及赞助项目的利益相关者，哪些行动适合框架活动？

- 小项目：
    1. 在线讨论需求和开发笔记；

一个人(远程）有直接的需求进行一个小的软件项目：电话交流就好，

task：

1. 和stakeholder通过电话甲流；
2. 将笔记组织成一个简单的需求书面(written)声明；
3. 和stakeholder用电子邮件进行审阅和通过

- 大项目：

多个股东，股东的需求不同甚至有冲突

action:
[[Chapter 8 需求 Requirements]]
1. I奠基inception 
2. E诱导elicitation (诱导需求，功能需求和非功能需求function requirement& non-function requirements)→requirement gathering
3. E细化elaboration (建模，用UML各种diagram对需求内容进行抽象)
4. N协商negotiation ( 甲方讨论需要和不需要的需求，需求规约，需求分析)   **与3存在迭代**
5. S规约specification 
6. V确认validation

开发过程控制:MS-project
**2. 伞状活动 (Umbrella Activities)**

- **定义：** 伞状活动是贯穿整个软件开发过程，**支持和管理框架活动** 的活动。
- **主要伞状活动**：
    - **项目跟踪和控制 (Project Tracking and Control)**：监控项目进展，确保项目按计划进行。
    - **风险管理 (Risk Management)**：识别、评估和应对项目中的潜在风险。
    - **软件质量保证 (Software Quality Assurance)**：确保软件产品符合预期的质量标准。
    - **配置管理 (Configuration Management)**：管理软件配置项，确保软件的各个版本和组件的一致性。
    - **技术审查 (Technical Reviews)**：对软件工程的各种工作产品进行审查，以发现缺陷并改进质量。
    - **可重用性管理 (Reusability Management)**: 提高代码的复用性，降低开发成本和时间。
    - **工作产品准备和生产 (Work product preparation & production)**: 为软件开发活动提供所需的文档和模型。
- **特点**：
    - **贯穿始终**：这些活动在整个软件开发生命周期中都存在。
    - **支持作用**：它们支持和管理框架活动，确保项目顺利进行。
    - **关注质量**：它们有助于提高软件质量并降低项目风险。

## 3.3 定义任务列表Identify a Task Set

- 软件工程工作任务work tasks
- 相关工作产品products
- 质量保证点 quality assurance points
- 项目里程碑project milestone的集合

例子：

elicitation:

![Untitled](Chapter%203%20%E8%BD%AF%E4%BB%B6%E8%BF%87%E7%A8%8BSoftware%20Process%20e7160395fe3c4f20856e027664643d8a/Untitled%204.png)

e.g. 书上没有的例子:

Coding过程的Action :1个

task set: 

1. 分析理解详细设计（详细的设计规约，理解接口）；
2. 算法以及数据结构；
3. 准备环境写代码
4. (单元测试）自我测试self-testing（可能考虑的：算法复杂度时间性能）；
5. SQA软件质量保证；
6. refactor重构（测试后对大项目可能要重构，规范性的）
7. code review；
8. code end(里程碑任务milestone)

提高系统性能的几个方法：

1. 后端的数据库设计(冗余设计，表空间划分，范式)(高访问量的几张表不能放在一个表空间里)；
2. 架构设architecture design；
3. 前端和后端的接口（交易频繁的分到不同接口支流中）；
4. 前端本身的memory使用，和后端的通讯；
5. 模拟工具测试得到性能

(TODO)

## 3.4 过程模式 Process Pattern

**※ 非常重要**

定义：

过程模式Process Pattern描述了在软件工程工作中遇到的与过程有关的问题，确定了遇到该问题的环境，并提出了一个或多个行之有效的解决问题的方法。

流程模式为你提供了一个模板--一种在软件流程的背景下描述问题解决方案的一致方法。

pattern: 已证实有用的，抽象成一个模板步骤

具体来说：

描述与完整流程模型（例如原型设计）相关的问题（和解决方案）；可用于描述与框架活动（例如，计划）或框架活动（例如，项目估算）内的行动相关联的问题（和解决方案）

**※ 描述模板template**

| 内容 | 中文 | 描述 | 例子 |
| --- | --- | --- | --- |
| Pattern Name | 模式名字 | 形容软件过程的context | TechnicalReviews |
| Force | 环境 | 所需要的环境，硬件，网络，版本管理工具等 |  |
| Type | 类型 | stage pattern: 解决activity相关的（EstablishingCommunication）；task pattern：解决action或task的(RequirementGathering)；phase pattern: 整个框架活动的序列，涉及各种activity(SpiralModel, Prototyping) | stage pattern; task pattern; phase pattern |
| Initial Context | 启动条件 | 在模式启动之前： (1) 已经发生了哪些组织或团队相关的活动？ (2)进程的入口状态是什么？ (3) 已有哪些软件工程信息或项目信息？ （Activity Happended? State ? SE info) | 规划模式Stage pattern的Initial Context（1）客户和软件工程师建立了协作沟通； (2) 成功完成了通信模式的多个任务模式[指定]； (3)项目范围、基本业务需求、项目约束条件已知。 |
| Problem | 问题 | Pattern可以用来解决什么问题 |  |
| Solution | 解决方案 | 描述如何成功执行Pattern |  |
| Resulting Context | 接口（出口条件） | 为接下来提交什么信息(哪些activity必须出现；过程的出口状态是怎样的；开发了什么软件工程信息) |  |
| Related Pattern | 相关的Pattern | 提供与此直接相关的所有流程模式的列表。这可以表示为层次结构或以其他示意性形式表示（同级或上下） | 比如：同一个action下的两个task上下相关；又比如关于unit test不知道怎么做，去寻找相关、包含或并行的stage pattern |
| Know Uses and Examples | 用过的案例 |  |  |

![Untitled](Chapter%203%20%E8%BD%AF%E4%BB%B6%E8%BF%87%E7%A8%8BSoftware%20Process%20e7160395fe3c4f20856e027664643d8a/Untitled%205.png)
3. 过程模式 (Process Patterns)**

- **定义：** 过程模式描述了在软件开发中反复出现的问题以及解决这些问题的经验性方法。每个模式都提供了针对特定问题或任务的解决方案。
- **模式模板**：一个过程模式通常包括以下内容：
    - **模式名称 (Pattern Name)**： 模式的名称，用于标识模式。
    - **应用场景 (Forces)**：模式适用的环境和问题。
    - **类型 (Type)**： 模式的类型，例如，阶段模式（Stage Pattern）、任务模式（Task Pattern）、阶段模式（Phase Pattern）。
        - **阶段模式（Stage Pattern）**： 定义了与框架活动相关的活动序列，例如，**规划模式（Planning Pattern）**。
        - **任务模式（Task Pattern）**：定义了与软件工程实践相关的活动。例如，**需求收集模式 (Requirements Gathering)**
        - **阶段模式 (Phase Pattern)**： 定义了在软件过程中的活动顺序，即使是迭代的，例如，**原型模式（Prototyping Pattern）**
    - **初始上下文 (Initial Context)**：模式开始时存在的情况，例如，组织或团队的相关活动，初始状态以及所需要的软件工程信息。
    - **问题 (Problem)**：模式要解决的具体问题。
    - **解决方案 (Solution)**：如何解决问题，以及在模式实现之前，需要将软件工程或项目信息如何转换。
    - **结果上下文 (Resulting Context)**：模式成功应用后产生的结果，例如，组织或团队的活动，以及产生的软件工程信息。
    - **相关模式 (Related Patterns)**：与该模式相关的其他模式，例如，**沟通模式 (Communication)** 与 **需求收集模式 (Requirements Gathering)**。
    - **已知用途和示例 (Known Uses and Examples)**：模式的应用示例。
- **作用**：
    - **提供指导**：为软件开发过程提供可重用的解决方案。
    - **提高效率**：通过借鉴已有的经验，可以加快开发速度。
    - **规范流程**：帮助团队遵循最佳实践，提高软件质量。

## 3.5 过程评估与改进Assessment and Improvement

Process patterns必须与可靠的软件工程实践相结合。 此外，可以对过程本身进行评估，以确保它满足一组基本过程标准，这些标准已被证明对于成功的软件工程至关重要。

(CMMI)

Initial Repeatable Defined Managed Optimize
**4. 过程评估与改进 (Process Assessment and Improvement)**

- **目的**：评估当前的软件过程，并进行改进，从而提高软件开发的效率和质量。
- **方法**：
    - **CMMI (Capability Maturity Model Integration)**：一种通用的软件过程改进框架，用于评估和改进组织的软件开发能力。CMMI 模型定义了五个成熟度级别：初始级（Initial），可重复级（Repeatable），已定义级（Defined），已管理级（Managed），优化级（Optimize）。
    - **过程模式的结合**：将过程模式与可靠的软件工程实践相结合。
    - **持续改进**： 软件过程需要不断地评估和改进，以适应新的技术和需求。

**总结**

- **软件过程结构**：包括框架活动，伞状活动和过程模式。
- **框架活动** 定义了软件开发的核心活动。
- **伞状活动** 支持和管理框架活动。
- **过程模式** 提供可重用的解决方案。
- **过程改进** 确保软件过程不断优化。

## 软件成熟度模型CMMI

![Untitled](Chapter%203%20%E8%BD%AF%E4%BB%B6%E8%BF%87%E7%A8%8BSoftware%20Process%20e7160395fe3c4f20856e027664643d8a/Untitled%206.png)

![Untitled](Chapter%203%20%E8%BD%AF%E4%BB%B6%E8%BF%87%E7%A8%8BSoftware%20Process%20e7160395fe3c4f20856e027664643d8a/Untitled%207.png)

注：上图的机构过程焦点的例子在下图
