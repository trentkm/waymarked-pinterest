#!/bin/bash
# Reads Claude Code hook context from stdin, sends a descriptive ntfy notification
# Usage: echo '{"type":"..."}' | ntfy-notify.sh <event_type>

TOPIC=$(grep NTFY_TOPIC ~/waymarked-pinterest/.env | cut -d= -f2)
EVENT_TYPE="${1:-unknown}"
CONTEXT=$(cat)

case "$EVENT_TYPE" in
  notification)
    # Notification hook fires when Claude needs permission or has been idle 60s+
    MESSAGE=$(echo "$CONTEXT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    msg = data.get('message', '') or data.get('title', '') or ''
    if msg:
        print(f'Waiting for you: {msg[:100]}')
    else:
        print('Claude is waiting for your input')
except:
    print('Claude is waiting for your input')
" 2>/dev/null)
    curl -s \
      -H "Title: Waymarked" \
      -H "Tags: hourglass" \
      -d "$MESSAGE" \
      "ntfy.sh/$TOPIC" > /dev/null 2>&1
    ;;
  stop)
    # Stop hook fires when Claude finishes a task
    MESSAGE=$(echo "$CONTEXT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    result = data.get('stopReason', '') or data.get('reason', '') or ''
    if result:
        print(f'Task done ({result})')
    else:
        print('Task complete')
except:
    print('Task complete')
" 2>/dev/null)
    curl -s \
      -H "Title: Waymarked" \
      -H "Tags: white_check_mark" \
      -d "$MESSAGE" \
      "ntfy.sh/$TOPIC" > /dev/null 2>&1
    ;;
esac
