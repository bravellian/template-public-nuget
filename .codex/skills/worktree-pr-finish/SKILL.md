---
name: worktree-pr-finish
description: Validate work in a task worktree, commit safely, push the branch, and open a pull request to main using GitHub CLI. Use when wrapping up implementation and preparing review.
---

## When to use
- Finishing a task branch in a worktree.
- Running verification before commit/push.
- Opening or checking a PR for that branch.

## Inputs
- `WorktreePath` (required): path to task worktree.
- `VerifyCommand` (optional): repo-specific verification command (for example `dotnet test`, `npm test`, or a build script).
- `CommitMessage` (optional): if provided, script stages and commits.
- `BaseBranch` (optional): defaults to `main`.
- `Repo` (optional): explicit `owner/repo` for `gh pr create`.

## Steps
1. Run `scripts/finish_worktree_pr.ps1` from any location.
2. Script validates the worktree and runs `VerifyCommand` when provided (unless `-SkipVerify` is used).
3. If `CommitMessage` is provided, it stages changes and creates a commit.
4. It pushes the current branch and creates (or reuses) a PR via `gh`.

## Example
```powershell
pwsh -File .codex/skills/worktree-pr-finish/scripts/finish_worktree_pr.ps1 `
  -WorktreePath "C:\src\payewaive\internal.worktrees\feature\ticket-113-waiver-signing-status" `
  -CommitMessage "Fix ticket 113 signing status reconciliation" `
  -PrTitle "Fix ticket 113 signing status reconciliation" `
  -PrBody "Includes webhook + reconcile auto-repair and deployment defaults."
```

## Output
- Verification command result.
- Branch status and latest commit.
- Push result.
- PR URL when created/found.

## Guardrails
- Do not auto-stage everything unless intended.
- Prefer `-Paths` for targeted commits.
- Keep PR body factual: summary, validation, and known gaps.
