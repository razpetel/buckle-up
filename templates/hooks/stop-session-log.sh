#!/usr/bin/env bash
# stop-session-log.sh
# Logs session info for later review

LOG_FILE=".claude/session-history.log"
mkdir -p "$(dirname "$LOG_FILE")"

{
  echo "---"
  echo "session_end: $(date -Iseconds)"
  echo "directory: $(pwd)"
  echo "git_branch: $(git branch --show-current 2>/dev/null || echo 'n/a')"
  echo "git_status: $(git status --porcelain 2>/dev/null | wc -l | tr -d ' ') uncommitted files"
  echo ""
} >> "$LOG_FILE"
