#!/bin/bash
source ~/.bash_profile 2>/dev/null || source ~/.profile 2>/dev/null
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

TOPIC=$(grep NTFY_TOPIC ~/waymarked-pinterest/.env | cut -d= -f2)

OUTPUT=$(CLAUDECODE= claude -p "Say OK" 2>&1 | head -5)

if echo "$OUTPUT" | grep -qi "not logged in\|please run /login\|unauthorized\|authentication"; then
  echo "[$(date)] Claude auth check FAILED: $OUTPUT" >> ~/waymarked-pinterest/cron.log
  curl -s \
    -H "Title: Waymarked: Login Required" \
    -H "Tags: warning" \
    -H "Priority: high" \
    -d "Claude is not logged in. Run /login before 8am cron jobs fail." \
    "ntfy.sh/$TOPIC" > /dev/null 2>&1
else
  echo "[$(date)] Claude auth check OK" >> ~/waymarked-pinterest/cron.log
fi
