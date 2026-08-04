## Multi-Agent Defaults (ultracode, workflows, subagents)

- **Standing authorization.** Use subagents and workflows for substantive
  tracks (research, investigations, builds, reviews). No need to ask for
  confirmation, exercise your judgement.
- **Model ceiling: opus.** Every Workflow `agent()` call sets `model`
  explicitly — `opus` for hard stages, `sonnet`/`haiku` for mechanical ones. The
  same applies as guidance to Agent-tool fan-outs: parallel subagents on
  opus or cheaper.
- **Codex as a second perspective.** Substantive ultracode work includes an
  OpenAI Codex pass (codex-review skill / `codex` CLI) in the review or
  verification phase — a different model family as one adversarial voice among
  the verifiers, not the arbiter.
