---
name: worktree-pr-fix
description: Fix unresolved PR comments for the current worktree
---

You need to fetch and address unresolved comments from the GitHub pull request for the current worktree.

Steps:
1. Get the current branch name and find its associated PR using `gh pr list --head <branch>`
2. If no PR exists, inform the user and exit
3. Fetch all unresolved review comments using `gh api repos/{owner}/{repo}/pulls/{pr-number}/comments` and `gh api repos/{owner}/{repo}/pulls/{pr-number}/reviews`
4. Analyze the comments to categorize them:
   - Simple/clear fixes (typos, formatting, simple refactoring)
   - Complex/ambiguous changes (architectural changes, unclear requirements, multiple possible approaches)
5. If there are complex/ambiguous comments:
   - Create a plan listing all comments and proposed fixes
   - Present the plan to the user for confirmation before proceeding
   - Use the TodoWrite tool to track each fix
6. If all comments are straightforward:
   - Start fixing immediately
   - Use the TodoWrite tool to track progress
7. For each comment:
   - Navigate to the file and line mentioned
   - Make the requested change
   - Mark the todo as completed
8. After all fixes, show a summary of changes made

Important:
- Always fetch the latest comments before starting
- Group related comments together when fixing
- If a comment is unclear, ask for clarification
- Show progress as you work through the comments
- Handle deleted files or outdated line numbers gracefully
- Consider if comments conflict with each other