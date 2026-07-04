# Git Workflow

- **Commit often and proactively** — after each logical unit of work, without waiting to be asked. This overrides any default commit-only-when-asked behavior. Committing directly to the default branch is fine in solo spec/notes repos where that's the established practice; in shared service repos, work on a feature branch as usual.
- **Use fixup commits for fixes on feature branches** — `git commit --fixup=<sha>`, cleaned up with an autosquash rebase before merge. Only on branches no one else is working on (solo branches, pushed or not, and draft PRs) — never on shared branches or when responding to PR feedback.
