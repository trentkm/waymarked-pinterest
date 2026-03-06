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
| Vintage/naturalistic (vintage-treasure, parchment, forest-moss, ember-atlas, nordic-frost, rose) | Any | 8 | 1 | ember-atlas rejected at high visual density (Cuba) — ink-and-paper aesthetic works better at moderate density |
| Pure-terrain series | Continental/large countries | 5 | 0 | Dramatic, cool, borders all successful |
| Pure-terrain-land-dark | Any without labels | 0 | 1 | gen_031 Germany: dark map barren without city labels |
| Pure-terrain-ocean-dark | Coastal/island | 0 | 1 | gen_019 Australia: landscape focus, but also had your_trip angle |
| Sketch styles (slate-blue, terracotta) | Any | 2 | 0 | Working well so far |
| sepia-sketch | Any | 0 | 3 | Title contrast bug persists — even cartouche title can fail when it overlaps a same-color river. Needs title color that contrasts with map background AND nearby features. |
| seraphs-canvas | Low density (sparse terrain, wide zoom) | 0 | 3 | gen_013 Czech Republic, gen_030 Maldives, gen_034 Argentina (country zoom). Style's ornate detail needs visual density to shine. |
| seraphs-canvas | High density (city zoom 12+) | 1 | 0 | gen_038 Singapore zoom 12 — APPROVED. First success. City-zoom unlocks the style. |
| monochrome | Any | 0 | 1 | gen_033 Netherlands — black title loses contrast on B&W map. Rendering issue: needs contrasting title color |

### Rendering Issues (bugs, not taste)

These are technical problems, not style/destination preferences:

- **sepia-sketch title contrast**: 3 rejections (gen_024 Switzerland, gen_025 Austria, gen_036 Egypt). Cartouche title (gen_036) still failed when it overlapped a same-color river. True fix requires a title color that contrasts with both the sepia background AND surrounding map features.
- **monochrome title contrast**: gen_033 Netherlands. Black title disappears on B&W map. Needs a light/colored title or title background.
- **Dark terrain styles need labels enabled**: gen_031 confirmed. Without labels, dark maps look barren/empty.
- **vintage-treasure + banner title contrast**: gen_040 Tanzania. User loved the map but couldn't read the title. Banner title on vintage-treasure poster bar lacks contrast. Use cartouche or stamp title style for better legibility with this style.
- **forest-moss + modern title contrast**: gen_041 Taipei. User loved the map but couldn't see the title. Modern title against green forest-moss palette is unreadable. Use cartouche or banner title with a background for contrast.

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
| gen_036 | Egypt | sepia-sketch | your_trip | sepia-sketch × title color × Nile map | Title overlaps a river of the same color — unreadable. Style and map are great. Needs contrasting title color. Cartouche fix did not fully resolve the contrast issue in this map. |
| gen_037 | Cuba | ember-atlas | gift_for | ember-atlas × high-density destination | Map density doesn't suit the ink-and-paper aesthetic of ember-atlas. Style works better at lower visual density. |
| gen_040 | Tanzania | vintage-treasure | wall_art | vintage-treasure × banner title × poster bar | Title unreadable: banner title on vintage-treasure style lacks contrast. User loved the map but couldn't read the title. Title style or placement needs adjustment for this style combo. |
| gen_041 | Taipei | forest-moss | your_trip | forest-moss × modern title × horizontal bar | Title not visible: modern title on forest-moss style lacks contrast. User loved the map but couldn't see the title. Needs a title style with stronger contrast against the green palette. |

## Analytics Insights

**Per-pin tracking active since 2026-03-03.** Weekly review will populate this section with real Pinterest performance data correlated with pin attributes.

**Initial baseline (7-day window ending Mar 3):**
- Account: 32 impressions, 2 pin clicks, 0 saves, 0 outbound clicks
- Top pins by impressions: gen_015 Thailand (3), gen_017 South Africa (2)
- Most pins have 0-1 impressions — account is still young, need more volume

## Experiments

- **seraphs-canvas city/street zoom — CONFIRMED** — gen_038 Singapore zoom 12 approved and posted. Style works at city zoom. Expand usage to other dense cities at zoom 11+.
- **Test your_trip with dense city maps (any region)** — past rejections correlated with sparse wide-zoom maps, not geography. Try tight zoom on visually rich non-European cities
- **Test sepia-sketch with cartouche/banner title style** — the style is beautiful, just needs title contrast fix
- **Monitor outbound clicks** — currently 0, smart linking should improve this
