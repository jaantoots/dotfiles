#!/usr/bin/env python3
"""PreToolUse guard: Workflow agents never inherit the session model.

Every agent() call in a Workflow script must set an explicit opts.model.
Direct Agent subagents are intentionally exempt. Ceiling is opus — allowed
families: opus, sonnet, haiku. Anything else (including inheriting the session
model by omission) is denied with an actionable reason so the caller fixes the
spawn instead of working around it.
"""
import json
import os
import re
import sys

ALLOWED_FAMILIES = ("opus", "sonnet", "haiku")


def model_allowed(value):
    return any(fam in value for fam in ALLOWED_FAMILIES)


def deny(reason):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }))
    sys.exit(0)


def load_workflow_script(tool_input):
    """Return (source, None) or (None, unresolved_name)."""
    path = tool_input.get("scriptPath")
    if path:
        try:
            with open(os.path.expanduser(path)) as f:
                return f.read(), None
        except OSError:
            return None, None  # let the tool surface the read error itself
    script = tool_input.get("script")
    if script:
        return script, None
    name = tool_input.get("name")
    if name and re.fullmatch(r"[\w-]+", name):
        for base in (".claude/workflows", os.path.expanduser("~/.claude/workflows")):
            for ext in (".js", ".mjs"):
                candidate = os.path.join(base, name + ext)
                if os.path.isfile(candidate):
                    try:
                        with open(candidate) as f:
                            return f.read(), None
                    except OSError:
                        return None, None
        return None, name
    return None, None


def agent_call_spans(src):
    """Yield (call_text, line_number) for each top-level agent(...) call.

    Paren-matching skips string/template contents; heuristic, not a JS parser.
    """
    for m in re.finditer(r"(?<![\w.$])agent\s*\(", src):
        i = m.end()
        depth = 1
        quote = None
        while i < len(src) and depth:
            c = src[i]
            if quote:
                if c == "\\":
                    i += 2
                    continue
                if c == quote:
                    quote = None
            elif c in "'\"`":
                quote = c
            elif c == "(":
                depth += 1
            elif c == ")":
                depth -= 1
            i += 1
        yield src[m.start():i], src.count("\n", 0, m.start()) + 1


def check_workflow(tool_input):
    src, unresolved_name = load_workflow_script(tool_input)
    if unresolved_name:
        deny(
            f"Named workflow '{unresolved_name}' would run its agents on the session model "
            "(no script found under .claude/workflows to verify). Recreate it as an inline "
            "script (or run its persisted scriptPath) with an explicit model on every "
            "agent() call — 'opus' for hard stages, 'sonnet'/'haiku' for mechanical ones."
        )
    if src is None:
        return
    problems = []
    for span, line in agent_call_spans(src):
        if not re.search(r"\bmodel\s*:", span):
            problems.append(f"line {line}: agent() call without an explicit model")
    for m in re.finditer(r"\bmodel\s*:\s*['\"]([^'\"]+)['\"]", src):
        if not model_allowed(m.group(1)):
            problems.append(
                f"model '{m.group(1)}' is above the opus ceiling (allowed: opus, sonnet, haiku)"
            )
    if problems:
        deny(
            "Workflow blocked by the model-ceiling guard — agents must never inherit the "
            "session model. Set opts.model explicitly on EVERY agent() call: 'opus' for hard "
            "stages, 'sonnet'/'haiku' for mechanical ones. If a call takes a shared opts "
            "variable, inline `model:` into the call so the guard can see it. Problems: "
            + "; ".join(problems)
        )


def main():
    try:
        data = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        return
    tool_input = data.get("tool_input") or {}
    tool_name = data.get("tool_name")
    if tool_name == "Workflow":
        check_workflow(tool_input)


if __name__ == "__main__":
    main()
