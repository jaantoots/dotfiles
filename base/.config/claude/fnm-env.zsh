# Claude Code runs this before every Bash command (CLAUDE_ENV_FILE). Its shells don't carry the
# interactive fnm cd hook, and the working directory persists between commands, so apply the
# directory's version at start as well as on cd.
if command -v fnm >/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
  export FNM_LOGLEVEL=error
  _fnm_autoload_hook
fi
