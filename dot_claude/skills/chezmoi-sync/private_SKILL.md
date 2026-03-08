---
name: chezmoi-sync
description: Sync chezmoi dotfiles by adding all changes, committing them, and pushing to the remote repository. Use when you've made updates to your dotfiles and want to back them up to the remote repository.
disable-model-invocation: true
allowed-tools: Bash(cd *, git *)
---

# Chezmoi Sync Skill

This skill automates the process of synchronizing your chezmoi dotfiles configuration with the remote repository.

## Commit Message

If you provided a custom message, use it. Otherwise, use: "Update dotfiles"

Custom message: $ARGUMENTS

## Execution Steps

Execute the following commands in order to sync your dotfiles:

1. **Change to the chezmoi directory**:
   ```bash
   cd ~/.local/share/chezmoi
   ```

2. **Check the current status** to verify there are changes:
   ```bash
   git status
   ```

3. **Stage all changes**:
   ```bash
   git add -A
   ```

4. **Commit the changes**:
   If ARGUMENTS were provided, commit with that message.
   Otherwise, use the default message "Update dotfiles".

5. **Push to the remote repository**:
   ```bash
   git push
   ```

## Important Notes

- Only proceed if `git status` shows changes
- Ensure you have write access to the remote repository
- Verify the commit message is descriptive and helpful
- Report the results clearly (success/failure)
