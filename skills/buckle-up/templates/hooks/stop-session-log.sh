#!/bin/bash
# Log session end for continuity
echo "[$(date)] Session ended" >> .claude/session.log
exit 0
