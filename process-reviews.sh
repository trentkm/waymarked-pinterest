#!/bin/bash
source ~/.bash_profile 2>/dev/null || source ~/.profile 2>/dev/null
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

echo "[$(date)] Starting review processing..." >> ~/waymarked-pinterest/cron.log

cd ~/repos/waymarked

# Find closed pin review issues that haven't been processed yet
CLOSED_ISSUES=$(gh issue list --repo trentkm/waymarked --state closed --search "Pin review:" --json number,title,closedAt --jq '.[] | select(.title | startswith("Pin review:")) | .number' 2>/dev/null)

# Find already-processed issue numbers
PROCESSED_FILE=~/waymarked-pinterest/processed-issues.txt
touch "$PROCESSED_FILE"

UNPROCESSED=""
for ISSUE_NUM in $CLOSED_ISSUES; do
  if ! grep -q "^${ISSUE_NUM}$" "$PROCESSED_FILE"; then
    UNPROCESSED="${UNPROCESSED} ${ISSUE_NUM}"
  fi
done

if [ -z "$(echo "$UNPROCESSED" | xargs)" ]; then
  echo "[$(date)] No new closed pin review issues to process." >> ~/waymarked-pinterest/cron.log
  echo "[$(date)] Review processing complete." >> ~/waymarked-pinterest/cron.log
  exit 0
fi

echo "[$(date)] Processing issues:${UNPROCESSED}" >> ~/waymarked-pinterest/cron.log

# For each unprocessed issue, extract body + comments and pass to Claude
for ISSUE_NUM in $UNPROCESSED; do
  ISSUE_BODY=$(gh issue view "$ISSUE_NUM" --repo trentkm/waymarked --json body --jq '.body' 2>/dev/null)
  ISSUE_COMMENTS=$(gh issue view "$ISSUE_NUM" --repo trentkm/waymarked --json comments --jq '.comments[].body' 2>/dev/null)
  ISSUE_TITLE=$(gh issue view "$ISSUE_NUM" --repo trentkm/waymarked --json title --jq '.title' 2>/dev/null)

  # Write context to a temp file for Claude
  CONTEXT_FILE=$(mktemp)
  cat > "$CONTEXT_FILE" <<CTXEOF
=== ISSUE #${ISSUE_NUM}: ${ISSUE_TITLE} ===

--- ISSUE BODY ---
${ISSUE_BODY}

--- USER COMMENTS ---
${ISSUE_COMMENTS}
CTXEOF

  CLAUDECODE= claude --dangerously-skip-permissions -p "You are the Waymarked Pinterest review processor.

You have a closed GitHub Issue containing pin review decisions from the user. Process their feedback.

1. Read the review context file at ${CONTEXT_FILE}
2. Read ~/waymarked-pinterest/audit.json for current pin data
3. Read ~/waymarked-pinterest/learnings.md for current learnings
4. Read ~/waymarked-pinterest/waymarked-pinterest.md for Pinterest posting instructions

For each pin mentioned in the issue:
- Parse the user's decision (approve or reject)
- If APPROVED: update the pin's status in audit.json to 'approved'
- If REJECTED: update the pin's status in audit.json to 'rejected', add the rejection reason, and add an entry to the Rejection Log in learnings.md

5. For approved pins that have images in ~/waymarked-pinterest/exports/:
   - Post them to Pinterest using the Pinterest API as described in waymarked-pinterest.md
   - Update their status in audit.json to 'posted' after successful posting
   - Record the Pinterest URL in audit.json

6. If the user said 'approve all' with no specific rejections, approve and post all pins from this batch.

7. As your very last output, print ONLY a one-line plain text summary (no markdown, no bold, no asterisks) in this exact format:
   SUMMARY: Issue #${ISSUE_NUM} — [X] approved, [Y] rejected, [Z] posted to Pinterest

Be precise. Only process pins mentioned in or related to this issue." --model sonnet --output-format text >> ~/waymarked-pinterest/cron.log 2>&1

  rm -f "$CONTEXT_FILE"

  # Mark issue as processed
  echo "$ISSUE_NUM" >> "$PROCESSED_FILE"

  # Add a comment to the issue confirming processing
  PROCESS_SUMMARY=$(grep 'SUMMARY:' ~/waymarked-pinterest/cron.log | tail -1 | sed 's/.*SUMMARY:[* ]*//')
  gh issue comment "$ISSUE_NUM" --repo trentkm/waymarked --body "Processed: ${PROCESS_SUMMARY}" 2>/dev/null

  echo "[$(date)] Processed issue #${ISSUE_NUM}: ${PROCESS_SUMMARY}" >> ~/waymarked-pinterest/cron.log
done

# Send notification summary
TOTAL_PROCESSED=$(echo "$UNPROCESSED" | wc -w | xargs)
FINAL_SUMMARY=$(grep 'SUMMARY:' ~/waymarked-pinterest/cron.log | tail -1 | sed 's/.*SUMMARY:[* ]*//')
curl -s \
  -H "Title: Reviews processed" \
  -H "Tags: white_check_mark" \
  -d "${TOTAL_PROCESSED} issue(s) processed. ${FINAL_SUMMARY}" \
  ntfy.sh/$(grep NTFY_TOPIC ~/waymarked-pinterest/.env | cut -d= -f2) > /dev/null 2>&1

echo "[$(date)] Review processing complete." >> ~/waymarked-pinterest/cron.log
