# Pinterest Automation Learnings

> **Working memory.** This file tracks recent observations and raw data.
> Proven patterns graduate to the skill file's Graduated Rules section.
> The weekly review prunes graduated data to keep this file lean.

## Combo Observations

Track what works and what doesn't as **combinations**, not single variables.

### Angle × Visual Density

| Angle | Visual Density | Posted | Rejected | Rate | Notes |
|-------|---------------|--------|----------|------|-------|
| gift_for | Any | 10 | 2 | 83% | Rejections were rendering/composition issues, not angle problems |
| wall_art | Any | 8 | 1 | 89% | Works globally. Only rejection was rendering issue (gen_031 dark style) |
| your_trip | Dense (city zoom, road-rich areas) | 2 | 1 | 67% | Scotland city-level OK, Austria rejected for title color (not angle) |
| your_trip | Sparse (wide zoom, ocean, open terrain) | 0 | 4 | 0% | Vietnam, Bali, Peru, Australia — all were zoomed-out views with sparse visual detail. The issue is low map density, not geography |

### Style × Destination Type

| Style Category | Destination Type | Posted | Rejected | Notes |
|----------------|-----------------|--------|----------|-------|
| Vintage/naturalistic (vintage-treasure, parchment, forest-moss, ember-atlas, nordic-frost, rose) | Any | 8 | 0 | 100% success across all regions |
| Pure-terrain series | Continental/large countries | 5 | 0 | Dramatic, cool, borders all successful |
| Pure-terrain-land-dark | Any without labels | 0 | 1 | gen_031 Germany: dark map barren without city labels |
| Pure-terrain-ocean-dark | Coastal/island | 0 | 1 | gen_019 Australia: landscape focus, but also had your_trip angle |
| Sketch styles (slate-blue, terracotta) | Any | 2 | 0 | Working well so far |
| sepia-sketch | Any | 0 | 2 | Title contrast bug — style is beautiful but title text unreadable. Fix: use title style with background/cartouche for contrast |
| seraphs-canvas | Low density (sparse terrain, wide zoom) | 0 | 3 | gen_013 Czech Republic, gen_030 Maldives, gen_034 Argentina (country zoom). Style's ornate detail needs visual density to shine — try at city/street zoom level |
| monochrome | Any | 0 | 1 | gen_033 Netherlands — black title loses contrast on B&W map. Rendering issue: needs contrasting title color |

### Rendering Issues (bugs, not taste)

These are technical problems, not style/destination preferences:

- **sepia-sketch title contrast**: 2 rejections (gen_024 Switzerland, gen_025 Austria). Title text unreadable against sepia background. Style is good — needs a title style with built-in contrast (cartouche, banner, etc).
- **monochrome title contrast**: gen_033 Netherlands. Black title disappears on B&W map. Needs a light/colored title or title background.
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
| gen_033 | Netherlands | monochrome | your_trip | monochrome × title contrast | Black title gets lost in black and white style. Would work with a contrasting title color. |
| gen_034 | Argentina | seraphs-canvas | wall_art | seraphs-canvas × continental zoom | Style needs city/street-level detail. At country zoom (5), ornate rendering loses appeal. |

## Analytics Insights

**Per-pin tracking active since 2026-03-03.** Weekly review will populate this section with real Pinterest performance data correlated with pin attributes.

**Initial baseline (7-day window ending Mar 3):**
- Account: 32 impressions, 2 pin clicks, 0 saves, 0 outbound clicks
- Top pins by impressions: gen_015 Thailand (3), gen_017 South Africa (2)
- Most pins have 0-1 impressions — account is still young, need more volume

## Experiments

- **Test seraphs-canvas at city/street zoom** — all 3 rejections were sparse/wide views. Try it on a dense city like Tokyo or Buenos Aires at zoom 11+
- **Test your_trip with dense city maps (any region)** — past rejections correlated with sparse wide-zoom maps, not geography. Try tight zoom on visually rich non-European cities
- **Test sepia-sketch with cartouche/banner title style** — the style is beautiful, just needs title contrast fix
- **Monitor outbound clicks** — currently 0, smart linking should improve this
