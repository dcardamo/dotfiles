---
name: worktree-pr
description: Add, commit, push changes and create/update a pull request for the current worktree
---

You need to prepare and push changes from the current worktree, then create or update a pull request.

Steps:
1. Check git status to see what files need to be added
2. Add all untracked and modified files using `git add .`
3. Create a commit with a descriptive message based on the changes
4. Check if a PR already exists for the current branch using `gh pr list --head <current-branch>`
5. Push the changes to the remote
6. If no PR exists:
   - Create a new PR using `gh pr create` with a title and body based on the commit(s)
   - Include a clear description of what changed
7. If a PR already exists:
   - Just push to update it
   - Show the PR URL so the user can review it

Important:
- Always show the user what files will be added before committing
- Create meaningful commit messages based on the actual changes
- For PR titles and descriptions, summarize the changes clearly
- Handle cases where there are no changes to commit
- Handle cases where the branch has no upstream set (use `git push -u origin <branch>`)
- Show the PR URL after creating or updating