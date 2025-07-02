---
name: worktree-new
description: Create a new git worktree with a descriptive name
---

You need to create a new git worktree based on the provided argument.

Steps:
1. Get the current git repository's root directory name (e.g., if in /home/user/projects/myapp, the project name is "myapp")
2. Create a worktree at ../<project-name>-<argument> where <argument> is the short name provided by the user
3. The worktree should be created from the current branch

For example:
- If in project "dotfiles" and argument is "feature-x", create worktree at ../dotfiles-feature-x
- If in project "myapp" and argument is "bugfix", create worktree at ../myapp-bugfix

Use the git worktree add command to create the worktree. Report success or any errors that occur.