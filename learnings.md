# Pinterest Automation Learnings

> **Working memory.** This file tracks recent observations and raw data.
> Proven patterns graduate to the skill file's Graduated Rules section.
> The weekly review prunes graduated data to keep this file lean.

## Combo Observations

Track what works and what doesn't as **combinations**, not single variables.

### Angle × Region

| Angle | Region | Posted | Rejected | Rate | Notes |
|-------|--------|--------|----------|------|-------|
| gift_for | Europe | 6 | 1 | 86% | Only rejection was seraphs-canvas rendering issue (gen_013) |
| gift_for | Middle East | 2 | 0 | 100% | Jordan, Turkey both strong |
| gift_for | Asia | 1 | 1 | 50% | gen_030 Maldives rejected for zoom/composition, not angle |
| gift_for | South America | 0 | 0 | — | Untested |
| gift_for | Africa | 1 | 0 | 100% | India (gen_032) |
| wall_art | Any | 8 | 1 | 89% | Works globally. Only rejection was rendering issue (gen_031 dark style) |
| your_trip | Europe | 2 | 1 | 67% | Scotland OK, Austria rejected for title color (not angle) |
| your_trip | Non-Europe | 0 | 4 | 0% | Vietnam, Bali, Peru, Australia all rejected. Angle doesn't work for exotic destinations |

### Style × Destination Type

| Style Category | Destination Type | Posted | Rejected | Notes |
|----------------|-----------------|--------|----------|-------|
| Vintage/naturalistic (vintage-treasure, parchment, forest-moss, ember-atlas, nordic-frost, rose) | Any | 8 | 0 | 100% success across all regions |
| Pure-terrain series | Continental/large countries | 5 | 0 | Dramatic, cool, borders all successful |
| Pure-terrain-land-dark | Any without labels | 0 | 1 | gen_031 Germany: dark map barren without city labels |
| Pure-terrain-ocean-dark | Coastal/island | 0 | 1 | gen_019 Australia: landscape focus, but also had your_trip angle |
| Sketch styles (slate-blue, terracotta) | Any | 2 | 0 | Working well so far |
| sepia-sketch | Any | 0 | 2 | Title text unreadable on sepia backgrounds — rendering bug |
| seraphs-canvas | Small/isolated destinations | 0 | 2 | gen_013 Czech Republic, gen_030 Maldives — style needs large/varied terrain to shine |
| seraphs-canvas | Large/continental | 0 | 0 | Untested — worth trying |

### Rendering Issues (bugs, not taste)

These are technical problems, not style/destination preferences:

- **sepia-sketch title contrast**: 2 consecutive rejections (gen_024 Switzerland, gen_025 Austria). Title text unreadable against sepia background. Quarantined until fixed.
- **Dark terrain styles need labels enabled**: gen_031 confirmed. Without labels, dark maps look barren/empty.

## Rejection Log

| Pin ID | Destination | Style | Angle | Rejection Combo | Reason |
|--------|-------------|-------|-------|-----------------|--------|
| gen_007 | Vietnam | sepia | your_trip | your_trip × Asia | Narrative angle doesn't resonate for exotic destinations |
| gen_010 | Bali | sage-green-sketch | your_trip | your_trip × Asia | Same pattern — niche experience angle ineffective |
| gen_012 | Peru | explorers-atlas | your_trip | your_trip × S. America | Adventure narrative not resonating |
| gen_013 | Czech Republic | seraphs-canvas | gift_for | seraphs-canvas × small destination | Style too ornate, destination too compact |
| gen_019 | Australia | pure-terrain-ocean-dark | your_trip | your_trip × Oceania | Landscape focus without gift/decor frame |
| gen_024 | Switzerland | sepia-sketch | gift_for | sepia-sketch × rendering | Title color unreadable |
| gen_025 | Austria | antique | your_trip | sepia/antique × rendering | Title color unreadable (antique works elsewhere — gen_008 Scotland posted) |
| gen_030 | Maldives | seraphs-canvas | gift_for | seraphs-canvas × island/atoll | Map too barren, too zoomed out for scattered atolls |
| gen_031 | Germany | pure-terrain-land-dark | wall_art | dark-terrain × no labels | Dark map barren without labels |

## Analytics Insights

**Per-pin tracking active since 2026-03-03.** Weekly review will populate this section with real Pinterest performance data correlated with pin attributes.

**Initial baseline (7-day window ending Mar 3):**
- Account: 32 impressions, 2 pin clicks, 0 saves, 0 outbound clicks
- Top pins by impressions: gen_015 Thailand (3), gen_017 South Africa (2)
- Most pins have 0-1 impressions — account is still young, need more volume

## Experiments

- **Test seraphs-canvas with large continental destinations** — only rejected for small/isolated locations so far
- **Test your_trip with proven European heritage sites only** — still viable for Scotland-type destinations
- **Monitor outbound clicks** — currently 0, smart linking should improve this
