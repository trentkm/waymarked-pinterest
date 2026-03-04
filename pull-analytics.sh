#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"

TOKEN=$(cat ~/waymarked-pinterest/.pinterest-token)
START_DATE=$(date -v-7d +%Y-%m-%d)
END_DATE=$(date +%Y-%m-%d)
TODAY=$(date +%Y-%m-%d)

# --- Account-level analytics ---
OUTPUT=~/waymarked-pinterest/analytics/$TODAY.json
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.pinterest.com/v5/user_account/analytics?start_date=$START_DATE&end_date=$END_DATE&metric_types=IMPRESSION,SAVE,PIN_CLICK,OUTBOUND_CLICK" \
  > "$OUTPUT" 2>&1

echo "[$(date)] Account analytics saved to $OUTPUT" >> ~/waymarked-pinterest/cron.log

# --- Per-pin analytics ---
PIN_METRICS=~/waymarked-pinterest/analytics/pin-metrics.json

# Initialize if missing
if [ ! -f "$PIN_METRICS" ]; then
  echo '{}' > "$PIN_METRICS"
fi

# Extract posted pin IDs from audit.json
PIN_IDS=$(python3 -c "
import json
with open('$HOME/waymarked-pinterest/audit.json') as f:
    data = json.load(f)
for g in data['generations']:
    url = g.get('pinterest_url')
    if url:
        pin_id = url.rstrip('/').split('/')[-1]
        print(g['id'] + ':' + pin_id)
")

PIN_COUNT=0
for ENTRY in $PIN_IDS; do
  GEN_ID=$(echo "$ENTRY" | cut -d: -f1)
  PIN_ID=$(echo "$ENTRY" | cut -d: -f2)

  RESPONSE=$(curl -s -H "Authorization: Bearer $TOKEN" \
    "https://api.pinterest.com/v5/pins/$PIN_ID/analytics?start_date=$START_DATE&end_date=$END_DATE&metric_types=IMPRESSION,SAVE,PIN_CLICK,OUTBOUND_CLICK")

  # Extract summary metrics and update pin-metrics.json
  python3 -c "
import json, sys

response = json.loads('''$RESPONSE''')
summary = response.get('all', {}).get('summary_metrics', {})

with open('$PIN_METRICS') as f:
    metrics = json.load(f)

if '$GEN_ID' not in metrics:
    metrics['$GEN_ID'] = {'pinterest_id': '$PIN_ID', 'snapshots': []}

metrics['$GEN_ID']['snapshots'].append({
    'date': '$TODAY',
    'period': '$START_DATE to $END_DATE',
    'impressions': summary.get('IMPRESSION', 0),
    'saves': summary.get('SAVE', 0),
    'pin_clicks': summary.get('PIN_CLICK', 0),
    'outbound_clicks': summary.get('OUTBOUND_CLICK', 0)
})

# Keep only the last 8 snapshots per pin (2 months of weekly data)
metrics['$GEN_ID']['snapshots'] = metrics['$GEN_ID']['snapshots'][-8:]

# Update latest summary for quick access
metrics['$GEN_ID']['latest'] = metrics['$GEN_ID']['snapshots'][-1]

with open('$PIN_METRICS', 'w') as f:
    json.dump(metrics, f, indent=2)
" 2>/dev/null

  PIN_COUNT=$((PIN_COUNT + 1))
done

echo "[$(date)] Per-pin analytics updated for $PIN_COUNT pins" >> ~/waymarked-pinterest/cron.log
