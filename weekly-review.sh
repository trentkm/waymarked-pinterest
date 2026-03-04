#!/bin/bash
source ~/.bash_profile 2>/dev/null || source ~/.profile 2>/dev/null
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

echo "[$(date)] Starting weekly review..." >> ~/waymarked-pinterest/cron.log

cd ~/repos/waymarked

CLAUDECODE= claude --dangerously-skip-permissions -p "You are the Waymarked weekly review analyst.

## Data Sources

1. Read ~/waymarked-pinterest/analytics/pin-metrics.json for per-pin performance data
   - Each pin has impressions, saves, pin_clicks, outbound_clicks over the last 7 days
2. Read ~/waymarked-pinterest/audit.json for pin attributes (style, angle, destination, board, region)
3. Read ~/waymarked-pinterest/learnings.md (working memory — combo observations, rejection log, experiments)
4. Read ~/waymarked-pinterest/waymarked-pinterest.md — specifically the Graduated Rules section (permanent memory)

## Analysis: Correlate Performance with Combos

Cross-reference pin-metrics.json with audit.json to answer:
- Which style × destination-type combos get the most impressions?
- Which angle × region combos drive saves and clicks?
- Which boards have the best engagement?
- Are outbound clicks happening? (If 0, note as link strategy issue)
- Do any approved pins have zero impressions? (Flag as potential SEO/distribution issue)
- Does Pinterest data contradict or confirm the approval-based patterns?

IMPORTANT: Always think in combinations. A style is not good or bad alone — it depends on what it was paired with.

## Update learnings.md

- Update the Combo Observations tables with any new data
- Update the Analytics Insights section with real per-pin performance data
- Rank pins by impressions and engagement
- Note new combo patterns discovered from analytics
- Keep the Rejection Log as-is (only add new entries, never remove)

## Graduation: learnings.md → Skill File

Check if any combo observation in learnings.md has 3+ supporting data points AND is confirmed by Pinterest analytics (not just approval data). If so:

1. Write the rule into ~/waymarked-pinterest/waymarked-pinterest.md under the Graduated Rules section, in the appropriate subsection (Angle Rules, Style Rules, Composition Rules, or Link Rules)
2. Remove the graduated raw data from learnings.md (keep a one-line note: 'Graduated to skill file on YYYY-MM-DD')
3. Keep the Rejection Log entries — those are permanent reference

## Pruning learnings.md

- Remove any observations that have been graduated
- Remove analytics data older than 4 weeks (keep only recent snapshots)
- Keep the file under 100 lines if possible
- learnings.md is working memory, not a permanent archive

## Output

IMPORTANT: As your very last output, print ONLY a one-line plain text summary (no markdown, no bold, no asterisks) in this exact format:
SUMMARY: [number] insights updated, [number] rules graduated, top pin: [gen_id] [destination] ([impressions] impressions, [saves] saves)

Be concise and actionable." --model sonnet --output-format text >> ~/waymarked-pinterest/cron.log 2>&1

# Extract the summary line from cron.log and send as notification
SUMMARY=$(grep 'SUMMARY:' ~/waymarked-pinterest/cron.log | tail -1 | sed 's/.*SUMMARY:[* ]*//')
if [ -n "$SUMMARY" ]; then
  curl -s \
    -H "Title: Weekly review done" \
    -H "Tags: bar_chart" \
    -d "$SUMMARY" \
    ntfy.sh/$(grep NTFY_TOPIC ~/waymarked-pinterest/.env | cut -d= -f2) > /dev/null 2>&1
else
  curl -s \
    -H "Title: Weekly review" \
    -H "Tags: warning" \
    -d "Weekly review ran but couldn't extract summary. Check cron.log" \
    ntfy.sh/$(grep NTFY_TOPIC ~/waymarked-pinterest/.env | cut -d= -f2) > /dev/null 2>&1
fi

echo "[$(date)] Weekly review complete." >> ~/waymarked-pinterest/cron.log
