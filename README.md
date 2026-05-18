# Superpowers for Kimi Code CLI

本项目基于 [obra/superpowers](https://github.com/obra/superpowers) 改造，专为 **Kimi Code CLI** 适配。

- **原作者**: Jesse Vincent ([Prime Radiant](https://primeradiant.com))
- **原仓库**: https://github.com/obra/superpowers
- **协议**: MIT（详见 `LICENSE` 文件）
- **当前状态**: 已去除 Claude Code、Codex、Cursor、Gemini、OpenCode 等其他平台支持，**仅适配 Kimi Code CLI**。

---

## 这是什么

Superpowers 是一套完整的 AI 辅助软件开发方法论，通过可组合的 Skills（技能）来规范 Agent 的工作流程。它会从会话开始的那一刻起介入：当你想构建某个功能时，Agent **不会**直接跳进去写代码，而是先通过对话澄清需求、产出设计文档，在你确认后再进入实现、测试、代码审查的完整闭环。

核心流程如下：

1. **brainstorming** — 写代码前先澄清需求，探索多种方案，分段呈现设计并征得你同意
2. **using-git-worktrees** — 在新分支上创建隔离工作区，验证测试基线
3. **writing-plans** — 将设计拆解为 2-5 分钟一个的小任务，每个任务包含精确的文件路径、完整代码和验证步骤
4. **subagent-driven-development** — 为每个任务派发独立子代理，经过 spec 合规审查 + 代码质量审查两轮把关
5. **test-driven-development** — 严格执行 RED-GREEN-REFACTOR：先写失败测试，再看它失败，再写最小实现，再看它通过
6. **requesting-code-review** — 任务间自动审查，严重问题阻塞继续
7. **finishing-a-development-branch** — 完成后验证测试、提交选项（合并/PR/保留/丢弃）、清理工作区

**Agent 在执行任何任务前都会检查是否有相关 skill。** 这不是建议，是强制工作流。

---

## 安装

### 前提
- 已安装 [Kimi Code CLI](https://www.example.com/kimi-cli)（替换为实际地址）
- Git 与 SSH 已配置

### 一键安装

```bash
# 1. 克隆到任意位置（建议固定路径，方便后续更新）
git clone git@github.com:WingfyLyu/superpowers-kimi.git ~/superpowers-kimi
cd ~/superpowers-kimi

# 2. 运行安装脚本（软链接到 ~/.kimi/skills/）
./install.sh
```

安装脚本会将 `skills/` 下的每个 skill 目录软链接到 `~/.kimi/skills/`，因此：
- 更新时只需 `git pull`，无需重新安装
- 卸载时删除对应软链接即可

### 手动安装（如果不想用脚本）

```bash
cp -r skills/* ~/.kimi/skills/
```

### 验证安装

1. 启动 Kimi Code CLI 的新会话
2. 发送：
   ```
   Let's make a react todo list
   ```
3. 观察 Agent 是否在写代码前自动进入 `brainstorming` 流程（询问需求、探索方案等）

如果未自动触发，可手动输入：
```
/skill:using-superpowers
```

---

## Skills 清单

### 测试
- **test-driven-development** — RED-GREEN-REFACTOR 循环（含测试反模式参考）

### 调试
- **systematic-debugging** — 四阶段根因分析流程（含 root-cause-tracing、defense-in-depth、condition-based-waiting）
- **verification-before-completion** — 确保问题真的被修复

### 协作
- **brainstorming** — 苏格拉底式设计澄清
- **writing-plans** — 详细实现计划
- **executing-plans** — 批量执行与检查点
- **dispatching-parallel-agents** — 并发子代理工作流
- **requesting-code-review** — 预审查清单
- **receiving-code-review** — 响应审查反馈
- **using-git-worktrees** — 并行开发分支
- **finishing-a-development-branch** — 合并/PR 决策工作流
- **subagent-driven-development** — 快速迭代 + 两阶段审查（spec 合规 + 代码质量）

### 元能力
- **writing-skills** — 遵循最佳实践创建新 skill（含测试方法论）
- **using-superpowers** — Skill 系统入门与使用规则

---

## 换电脑迁移

在新电脑上只需两步：

```bash
git clone git@github.com:WingfyLyu/superpowers-kimi.git ~/superpowers-kimi
cd ~/superpowers-kimi && ./install.sh
```

所有 skill 配置会随仓库同步，无需额外手动操作。

---

## 理念

- **测试驱动开发** — 永远先写测试
- **系统化优于临时性** — 流程胜过猜测
- **复杂度削减** — 简洁是首要目标
- **证据优于断言** — 宣称成功前先验证

---

## 致谢

感谢 [Jesse Vincent](https://blog.fsck.com) 及 [Prime Radiant](https://primeradiant.com) 团队创建了原版 Superpowers。
