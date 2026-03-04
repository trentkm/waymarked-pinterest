# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Hands-off Pinterest + blog marketing system for [Waymarked](https://waymarked.com) running on a Mac Mini. Generates Pinterest pins (travel map images) and blog posts daily via cron, learns from user feedback and Pinterest analytics, and posts approved pins automatically via webhook-triggered processing.

## Architecture

**All automation scripts invoke `claude --dangerously-skip-permissions -p` with Sonnet.** The scripts are thin shell wrappers that set up PATH, invoke Claude with a detailed prompt, extract a `SUMMARY:` line from output, and send ntfy push notifications.

### Core Loop

1. `pull-analytics.sh` (7:55am daily) — curls Pinterest API for account + per-pin metrics
2. `generate-pins.sh` (8am daily) — Claude generates 3 pins via Playwright against a local Next.js dev server, creates a GitHub Issue with preview images uploaded to R2
3. `generate-blog.sh` (9am daily) — Claude writes an MDX blog post, creates a PR on the waymarked repo
4. User reviews on phone via GitHub (approve/reject pins on Issues, merge/close blog PRs)
5. Closing a pin review Issue → GitHub webhook → `webhook-server.mjs` (port 9876) → writes `.run-reviews` trigger → launchd WatchPaths → `process-reviews.sh` → Claude posts approved pins to Pinterest
6. `weekly-review.sh` (Monday 10am) — Claude cross-references per-pin analytics with audit data, updates learnings, graduates proven rules

### Two-Layer Self-Learning Memory

- **`learnings.md`** — working memory. Combo observations, rejection log, experiments. Updated by process-reviews.sh and weekly-review.sh. Read before every generation.
- **`waymarked-pinterest.md`** — graduated rules (permanent). Hard constraints confirmed by 3+ data points. The weekly review promotes rules here and prunes learnings.md.

Learning is **combo-based**: a style isn't good or bad alone — it depends on what it's paired with (destination type, angle, region, zoom).

### Always-On Services (launchd)

Plists in `~/Library/LaunchAgents/com.waymarked.*.plist`:
- **devserver** — Next.js at localhost:3000 (Playwright map capture target)
- **tunnel** — Cloudflare Tunnel routing webhook.waymarked.com → localhost:9876
- **webhook** — `webhook-server.mjs` receiving GitHub webhook POSTs
- **process-reviews** — WatchPaths on `.run-reviews`, runs process-reviews.sh

## Key Files

| File | Role |
|------|------|
| `waymarked-pinterest.md` | Skill file — full generation rules, Pinterest API posting flow, style/board/angle definitions, audit schema |
| `learnings.md` | Working memory — combo observations, rejection log, experiment tracking |
| `audit.json` | Every pin generation with status, attributes, Pinterest URL (source of truth) |
| `.pinterest-boards.json` | Board name → Pinterest board ID mapping (8 boards) |
| `analytics/pin-metrics.json` | Per-pin rolling metrics (last 8 weekly snapshots) |
| `webhook-server.mjs` | GitHub webhook receiver — verifies HMAC, writes trigger file after 10s delay |
| `upload-to-r2.mjs` | Uploads pin preview JPEGs to Cloudflare R2 (uses S3Client, reads creds from `~/repos/waymarked/.env.local`) |

## External Dependencies

- **Waymarked repo** at `~/repos/waymarked` — Next.js app with dev server for map rendering, blog content in `content/blog/*.mdx`
- **Pinterest API v5** — pin posting, analytics. Token in `.pinterest-token`, auto-refreshes on 401
- **Cloudflare R2** — pin preview image hosting for GitHub Issue embeds
- **GitHub repo** `trentkm/waymarked` — Issues for pin review, PRs for blog drafts
- **ntfy.sh** — push notifications to phone (topic in `.env`)

## Script Pattern

All cron scripts follow the same structure:
```
source bash_profile → set PATH → log start → invoke claude -p with detailed prompt → extract SUMMARY: line → send ntfy notification → log completion
```

The `SUMMARY:` line convention is critical — it's how scripts extract structured output from Claude for notifications and GitHub comments.

## Common Operations

```bash
# Check cron logs
tail -100 ~/waymarked-pinterest/cron.log

# Check service status
launchctl list | grep waymarked

# Test dev server
curl -s http://localhost:3000

# Test ntfy notifications
curl -s -d "test" ntfy.sh/$(grep NTFY_TOPIC ~/waymarked-pinterest/.env | cut -d= -f2)

# Refresh Pinterest token manually
curl -X POST https://api.pinterest.com/v5/oauth/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -u "$(grep PINTEREST_APP_ID .env | cut -d= -f2):$(grep PINTEREST_APP_SECRET .env | cut -d= -f2)" \
  -d "grant_type=refresh_token&refresh_token=$(cat .pinterest-refresh-token)"

# Check webhook/tunnel logs
tail webhook.log tunnel.log process-reviews.log
```

## Important Conventions

- **Never use em dashes** anywhere in generated content (titles, descriptions, messages). Use commas or periods.
- **Never post to Pinterest without explicit user approval.** Batch mode sets status to `pending_review`; interactive mode waits for "go".
- Pin descriptions use one of three angles (`your_trip`, `gift_for`, `wall_art`) rotated based on target board. Board determines angle, not the other way around.
- Smart linking: pin descriptions link to matching blog posts by angle/category, falling back to `/create`. Never link to homepage.
- 80/20 board split: 80% inspiration boards, 20% product boards.
- Audit log IDs increment sequentially: `gen_001`, `gen_002`, etc.
- Map capture uses `window.__RENDER_READY__` (30s timeout) and `window.__captureMap__()` via Playwright.
