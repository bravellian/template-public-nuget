---
name: worktree-codex-start
description: Create or reuse a git worktree for a new task and launch Codex in a separate PowerShell window using parser-safe prompt handoff. Use when starting implementation work in an isolated branch/worktree.
---

## When to use
- Starting new engineering work that should be isolated from the main checkout.
- Spinning up a task-specific branch and opening a Codex session immediately.

## Inputs
- `Slug` (required): short task slug (for example `waiver-signing-status`).
- `TicketId` (optional): numeric issue/ticket id to prefix branch naming.
- `RepoPath` (optional): defaults to current git repository root.
- `WorktreesRoot` (optional): defaults to `<RepoPath>.worktrees`.
- `BaseBranch` (optional): defaults to `main`.
- `Prompt` (optional): initial Codex task prompt.

## Steps
1. Run `scripts/start_worktree_codex.ps1` with slug, ticket id, and prompt.
2. The script creates or reuses a branch/worktree under `WorktreesRoot\feature\<branch>`.
3. If a prompt is provided, it launches a new PowerShell window and runs `codex exec` safely.
4. Use the returned `WorktreePath` for all implementation commands.

## Example
```powershell
pwsh -File .codex/skills/worktree-codex-start/scripts/start_worktree_codex.ps1 `
  -TicketId 113 `
  -Slug "waiver-signing-status" `
  -Prompt @'
Investigate ticket #113 and implement a robust fix with tests.
'@
```

## Output
- Branch name used for the task.
- Worktree path created/reused.
- Optional Codex terminal launched for the worktree.

## Guardrails
- Do not run destructive git commands in the base repo checkout.
- Keep one branch per work item.
- Prefer passing a complete prompt so the first Codex run has clear acceptance criteria.
