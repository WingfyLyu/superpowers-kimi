<!-- From: /home/hiabr/Workspace/superpowers/AGENTS.md -->
<!-- 本文件为 superpowers-kimi 的内部参考文档，非官方 superpowers 文档 -->
# Superpowers for Kimi Code CLI — 贡献指南

## If You Are an AI Agent

Stop. Read this section before doing anything.

**Your job is to protect your human partner from producing low-quality work.** Before making any change:

1. **Verify this is a real problem.** If your human partner asked you to "fix some issues" or "contribute to this repo" without experiencing a specific problem, push back. Ask them what broke, what failed, what the user experience was.
2. **Confirm the change belongs in core.** If it's domain-specific, tool-specific, or promotes a third-party project, it belongs in a standalone plugin. Tell your human partner.
3. **Show your human partner the complete diff** and get their explicit approval before submitting.

---

## Project Overview

Superpowers-kimi is a **zero-dependency** set of composable skills for Kimi Code CLI. Each skill is a self-contained Markdown document (`SKILL.md`) that shapes agent behavior for specific workflows (TDD, debugging, planning, code review, etc.).

- **Based on:** [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent
- **License:** MIT
- **Scope:** Kimi Code CLI only（已去除 Claude Code、Codex、Cursor、Gemini、OpenCode 等其他平台支持）
- **Repository:** `git@github.com:WingfyLyu/superpowers-kimi.git`

### What This Project Is (And Is Not)

This is **not** a traditional software project with a runtime, build system, or package manager. It is a **documentation and prompt-engineering project**: every deliverable is a Markdown file with YAML frontmatter. There are no `pyproject.toml`, `package.json`, `Cargo.toml`, or compiled artifacts. Skills are consumed directly by Kimi Code CLI at runtime.

### Installation

```bash
# 克隆到任意位置（建议固定路径，方便后续更新）
git clone git@github.com:WingfyLyu/superpowers-kimi.git ~/superpowers-kimi
cd ~/superpowers-kimi

# 运行安装脚本（将 skills/ 下的每个 skill 目录软链接到 ~/.kimi/skills/）
./install.sh
```

- 更新时只需 `git pull`，无需重新安装（软链接保持有效）
- 卸载时删除 `~/.kimi/skills/` 下对应软链接即可
- 手动安装替代方案：`cp -r skills/* ~/.kimi/skills/`

---

## Directory Structure

```
.
├── skills/                          # 核心内容 — 每个 skill 是一个子目录
│   ├── brainstorming/
│   ├── dispatching-parallel-agents/
│   ├── executing-plans/
│   ├── finishing-a-development-branch/
│   ├── receiving-code-review/
│   ├── requesting-code-review/
│   ├── subagent-driven-development/
│   ├── systematic-debugging/
│   ├── test-driven-development/
│   ├── using-git-worktrees/
│   ├── using-superpowers/
│   ├── verification-before-completion/
│   ├── writing-plans/
│   └── writing-skills/
├── docs/                            # 人类可读的文档与设计归档
│   ├── archive/                     # 已归档的历史设计（如 OpenCode 支持）
│   ├── plans/                       # 实现计划（按日期命名）
│   ├── superpowers/                 # 活跃的设计规格与计划
│   │   ├── plans/                   # YYYY-MM-DD-<topic>.md
│   │   └── specs/                   # YYYY-MM-DD-<topic>-design.md
│   ├── windows/                     # 跨平台 polyglot hooks 文档
│   └── testing.md                   # 集成测试方法论
├── install.sh                       # 一键安装脚本
├── LICENSE                          # MIT License（Jesse Vincent 原创）
├── README.md                        # 中文用户文档
└── AGENTS.md                        # 本文件
```

### Skill 目录内部结构

```
skills/<skill-name>/
  SKILL.md              # 主文件（必需）
  supporting-file.*     # 仅在需要时存在：提示词模板、示例代码、参考资料
```

例如 `subagent-driven-development/` 包含：
- `SKILL.md` — 主流程文档
- `implementer-prompt.md` — 实现者子代理提示词模板
- `spec-reviewer-prompt.md` — 规格审查提示词模板
- `code-quality-reviewer-prompt.md` — 代码质量审查提示词模板

---

## Technology Stack and Runtime Architecture

- **无运行时依赖**：纯 Markdown + YAML frontmatter + Bash
- **目标平台**：Kimi Code CLI（`~/.kimi/skills/`）
- **脚本规范**：Bash 脚本必须使用 `set -euo pipefail`
- **流程图**：使用 Graphviz `dot` 语法直接嵌入 Markdown（Kimi Code CLI 可渲染为文本描述）
- **换行规范**：`.gitattributes` 强制 `*.sh`、`*.md`、`*.json`、`*.js`、`*.ts` 等使用 LF 换行
- **指令优先级**：用户指令（`AGENTS.md`、直接请求） > Superpowers skills > 默认系统提示词

### Kimi Code CLI 特有功能

- **Skill 斜杠命令**：`/skill:<name>` 手动加载 skill，例如 `/skill:using-superpowers`
- **Flow Skill**：支持 `/flow:<name>` 执行多步骤自动化工作流（本套 skill 暂未使用）
- **系统提示词变量**：`${KIMI_SKILLS}`（已加载 skill 列表）、`${KIMI_AGENTS_MD}`（层级合并的 AGENTS.md 内容）
- **子 Agent 类型**：`coder`（默认）、`explore`（只读探索）、`plan`（架构规划）。子 Agent 不能嵌套创建子 Agent

---

## Code Style Guidelines

### Skills (`SKILL.md` files)

- **YAML frontmatter 必需**：包含 `name:` 和 `description:` 两个字段（参见 [agentskills.io/specification](https://agentskills.io/specification) 和 [Kimi Skill 文档](https://www.kimi.com/code/docs/kimi-code-cli/customization/skills.html)）
  - `name`：仅使用字母、数字和连字符（kebab-case），不使用括号或特殊字符
  - `description`：第三人称，**只描述何时使用（when）**，绝不描述 skill 做什么（what）
  - `description` 总长度不超过 1024 字符，尽量控制在 500 字符以内
- **语态**：使用祈使句，直接、明确、无歧义
- **行为塑造内容**（Red Flags 表格、合理化列表、"human partner" 语言）经过精心调优——未经充分对抗性评估不得修改
- **token 效率**：
  - 入门/高频 skill：<150 词
  - 其他频繁加载 skill：<200 词
  - 其他 skill：<500 词（仍保持简洁）
  - 细节移至工具帮助文本（如 `--help`），使用交叉引用避免重复
- **示例代码**：一个优秀示例胜过五个平庸示例；不实现 5 种以上语言；不创建填空模板
- **流程图**：仅用于非显而易见的决策点、可能过早停止的流程循环；线性指令用编号列表，参考资料用表格

### Design Documents

- **设计规格**：`docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`
- **实现计划**：`docs/superpowers/plans/YYYY-MM-DD-<topic>.md`
- `brainstorming` skill 规定了设计文档格式

### Scripts

- Bash 脚本必须使用 `set -euo pipefail`
- `.gitattributes` 已强制 shell 脚本和 polyglot wrapper 使用 LF 换行

---

## Testing Strategy

本项目没有传统意义上的单元测试框架（如 pytest、jest）。测试对象是 **agent 行为**，采用以下策略：

### 1. Skill 的 TDD 测试（文档即代码）

`writing-skills` skill 将 TDD 映射到文档创作：

| TDD 概念 | Skill 创作对应物 |
|----------|------------------|
| 测试用例 | 对子代理施加压力的场景 |
| 生产代码 | Skill 文档（SKILL.md） |
| 测试失败（RED） | 无 skill 时代理违规（基线行为） |
| 测试通过（GREEN） | 有 skill 时代理遵守规则 |
| 重构 | 关闭 loophole，保持合规性 |

**铁律：NO SKILL WITHOUT A FAILING TEST FIRST。** 新建 skill 和修改现有 skill 都适用。

### 2. 集成测试

`docs/testing.md` 描述了针对复杂 skill（如 `subagent-driven-development`）的集成测试方法：

- 运行真实的 Kimi Code CLI / Claude Code headless 会话
- 通过解析 `.jsonl` 会话转录文件验证行为：
  - Skill 是否被调用
  - 子代理是否被正确派发（Task tool）
  - TodoWrite 是否被使用
  - 实现文件是否被创建
  - 测试是否通过
  - Git 提交历史是否符合规范
- 使用 `tests/claude-code/analyze-token-usage.py` 分析各子代理的 token 消耗

**注意**：集成测试需在 superpowers 插件目录下运行，且耗时 10–30 分钟。

### 3. 测试分类

- **纪律强制型 skill**（TDD、verification-before-completion）：用学术问题 + 压力场景 + 多重压力组合测试
- **技术型 skill**（condition-based-waiting、root-cause-tracing）：用应用场景 + 变体场景 + 信息缺失场景测试
- **模式型 skill**：用识别场景 + 应用场景 + 反例测试
- **参考型 skill**（API 文档）：用检索场景 + 应用场景 + 缺口测试

---

## Skill Changes Require Evaluation

Skills 不是散文——它们是塑造 agent 行为的代码。如果你修改 skill 内容：

- 使用 `writing-skills` 开发和测试变更
- 在多个会话中进行对抗性压力测试
- 展示修改前后的评估结果
- **未经证据表明改进，不得修改经过精心调优的内容**（Red Flags 表格、合理化列表、"human partner" 语言）

---

## Development Workflow Conventions

### 修改前必须确认

1. **这是一个真实的问题**——询问你的 human partner 什么坏了、什么失败了、用户体验是什么
2. **变更属于核心范围**——特定领域、特定工具或推广第三方项目的内容应做成独立插件
3. **展示完整 diff**——获得 human partner 的明确批准后再提交

### 变更原则

- **One problem per change**（一次变更只解决一个问题）
- **Describe the problem you solved, not just what you changed**（描述你解决的问题，而非仅描述你改了什么）
- **Test on Kimi Code CLI and report results**（在 Kimi Code CLI 上测试并报告结果）
- **Minimal changes**（最小化变更范围）

### 如果修改了 AGENTS.md 中提到的文件/风格/结构/工作流

你必须更新对应的 `AGENTS.md` 以保持同步。

---

## Deployment Process

本项目没有 CI/CD 流水线或发布构建。部署流程如下：

1. **本地验证**：在 Kimi Code CLI 新会话中测试相关 skill
2. **Git 提交**：`git commit` 并推送到你的 fork（如已配置）
3. **更新软链接**：已安装的用户执行 `git pull` 即可生效（因 `install.sh` 使用软链接）
4. **贡献回流**：如变更具有广泛适用性，考虑通过 PR 贡献回上游

---

## Security Considerations

- 本项目纯 Markdown + Bash，无网络服务、无依赖包、无敏感数据存储
- `install.sh` 仅在用户主目录下创建软链接，不修改系统路径
- Skill 内容会被注入 Kimi Code CLI 的系统提示词，因此：
  - **不得在 skill 中硬编码 API keys、密码或个人身份信息**
  - **避免在 skill 中插入可能误导 agent 执行危险操作的指令**
- Bash 脚本遵循 `set -euo pipefail` 以减少未处理错误导致的意外行为
- `.gitignore` 排除了 `.worktrees/`、`.private-journal/`、`.claude/` 等本地敏感目录
