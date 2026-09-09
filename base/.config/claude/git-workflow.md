## Git Workflow

- **Commit often and proactively** — after each logical unit of work, without waiting to be asked. This overrides any default commit-only-when-asked behavior. Committing directly to the default branch is fine in solo spec/notes repos where that's the established practice; in shared service repos, work on a feature branch as usual.
- **Adjudicate auto-review findings critically, and reply adopted/rejected with reasons.** Scrutinize a reviewer's *proposed fix* as hard as its finding — constants and thresholds included: where does the number come from, and what legitimate data would it reject? When successive rounds keep producing findings of one class, **the cluster is the finding** — refactor the structure generating them instead of running another symptom pass.
