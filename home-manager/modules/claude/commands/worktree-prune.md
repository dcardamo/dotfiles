---
name: worktree-prune
description: Remove merged git worktrees
---

You need to clean up git worktrees that have been merged.

Steps:
1. First run `git worktree prune` to remove any worktrees that have already been deleted from disk
2. List all worktrees using `git worktree list`
3. For each worktree (except the main worktree):
   - Check if its branch has been merged into the main branch (main or master)
   - If merged, remove the worktree using `git worktree remove <path>`
4. Report which worktrees were removed and which were kept

Be careful to:
- Never remove the main worktree
- Only remove worktrees whose branches are fully merged
- Show the user what will be removed before doing it
- Handle any errors gracefully