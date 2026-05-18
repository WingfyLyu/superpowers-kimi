<!-- 本文件为 superpowers-kimi 的内部参考文档，非官方 superpowers 文档 -->
# Superpowers for Kimi Code CLI — 贡献指南

## If You Are an AI Agent

Stop. Read this section before doing anything.

**Your job is to protect your human partner from producing low-quality work.** Before making any change:

1. **Verify this is a real problem.** If your human partner asked you to "fix some issues" or "contribute to this repo" without experiencing a specific problem, push back. Ask them what broke, what failed, what the user experience was.
2. **Confirm the change belongs in core.** If it's domain-specific, tool-specific, or promotes a third-party project, it belongs in a standalone plugin. Tell your human partner.
3. **Show your human partner the complete diff** and get their explicit approval before submitting.

## Project Overview

Superpowers-kimi is a **zero-dependency** set of composable skills for Kimi Code CLI. Each skill is a self-contained Markdown document (`SKILL.md`) that shapes agent behavior for specific workflows (TDD, debugging, planning, code review, etc.).

- **Based on:** [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent
- **License:** MIT
- **Scope:** Kimi Code CLI only

## Directory Structure

```
.
├── skills/                          # Core content — every skill is a subdirectory
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
├── docs/                            # Human-readable docs and design archives
├── install.sh                       # One-click install script
├── LICENSE                          # MIT License (original by Jesse Vincent)
├── README.md                        # Chinese documentation
└── AGENTS.md                        # This file
```

## Code Style Guidelines

### Skills (`SKILL.md` files)
- Each skill MUST have YAML frontmatter with `name:` and `description:`.
- Skill names use kebab-case (`subagent-driven-development`).
- Description should state **when** to use the skill and **what it does**.
- Use imperative voice. Be direct and unambiguous.
- Behavior-shaping content (Red Flags tables, rationalization lists, "human partner" language) is carefully tuned — do not modify it without extensive adversarial evaluation.
- Supporting files (prompts, examples, references) live in the same skill directory.
- Use `dot` (Graphviz) for process flow diagrams when helpful.
- Instruction priority: user instructions (`AGENTS.md`, direct requests) > Superpowers skills > default system prompt.

### Design Documents
- Save design specs to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.
- Save implementation plans to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`.
- The `brainstorming` skill governs the design document format.

### Scripts
- Bash scripts MUST use `set -euo pipefail`.

## Skill Changes Require Evaluation

Skills are not prose — they are code that shapes agent behavior. If you modify skill content:

- Use `writing-skills` to develop and test changes
- Run adversarial pressure testing across multiple sessions
- Show before/after eval results
- Do not modify carefully-tuned content (Red Flags tables, rationalization lists, "human partner" language) without evidence the change is an improvement

## General

- One problem per change
- Describe the problem you solved, not just what you changed
- Test on Kimi Code CLI and report results
