# Kundali: Product and API Reference

This document records the current plan for the Kundali experience in `zp_expert`.
It is a working reference, not a final specification: page content, API selection, and
copy may change as the product is refined.

## Data provider

The Kundali experience will use the **Prokerala Astrology API v2**.

- Documentation: <https://api.prokerala.com/docs>
- OpenAPI specification: <https://api.prokerala.com/spec/astrology.v2.yaml>
- Authentication: OAuth 2.0 client credentials; obtain an access token from
  `https://api.prokerala.com/token` and send it as a Bearer token.

Successful JSON responses generally use this envelope:

```json
{
  "status": "ok",
  "data": {}
}
```

Do not call every endpoint when the Kundali opens. APIs should load on demand when
the expert opens the related page, both for performance and API-credit efficiency.

## Information architecture

The Kundali should stay technical, quick to scan, and useful to an expert. The
planned sections are:

1. Summary
2. Charts
3. Planets
4. Timing
5. Doshas
6. Yogas

The app should present computed facts first. It should not invent long generic
personality readings or predictions.

## 1. Summary

The default page gives an expert the essential chart context at a glance.

### Show

- Client birth details: date, exact time, birth place, and timezone.
- Lagna / Ascendant.
- Moon sign (Janma Rashi).
- Nakshatra and Pada.
- Small D1 / Lagna-chart preview, linked to Charts.
- Current Mahadasha and Antardasha with their dates.
- A compact technical-status row:
  - Mangal Dosha: present or absent.
  - Kaal Sarp Dosha: present or absent.
  - Sade Sati: active or inactive.
  - Number of detected Yogas.
- Brief technical facts such as lagna lord, Moon-sign lord, and retrograde planets.

### APIs

- Initial Kundali data: `GET /astrology/kundli/advanced`
- Planet facts: `GET /astrology/planet-position`

The initial page must not trigger every Dosha, Yoga, or chart endpoint. If a status
is not available in initial data, show it only after its page is loaded.

## 2. Charts

Charts visualise the same underlying Kundali in different divisional charts and
regional display styles.

### Show

- D1 / Rashi / Lagna chart as the primary chart.
- D9 / Navamsa chart as the second primary chart.
- Optional divisional-chart selector: D7, D10, D12, and other supported Vargas.
- North Indian and South Indian display styles as a visual-style selector, not as
  separate chart types.
- A clear label for every chart type and selected ayanamsa.

### Transit / Gochar

Transit is time-based and should live primarily in **Timing**, rather than being
mixed with the natal chart list. A Vedic Gochar can be built by requesting a Vedic
chart and planet positions for the selected current/future datetime, then comparing
them with natal positions in the app.

### APIs

- Rendered Vedic charts: `GET /astrology/chart`
  - Supports `chart_type`, `chart_style`, and SVG output.
- Divisional positions: `GET /astrology/divisional-planet-position`
- Current or selected Gochar positions: `GET /astrology/chart` and
  `GET /astrology/planet-position`, called with the selected transit datetime.

`/astrology/transit-chart` is in Prokerala's Western Astrology set. Do not present
it as the user's Vedic Gochar chart.

## 3. Planets

The planets page is a technical reference table with a concise default layout and
an expandable detail view per planet.

### Show

- Planet name.
- Sign / Rashi and sign lord.
- Degree.
- House.
- Nakshatra, Nakshatra lord, and Pada.
- Retrograde state as a small `R` badge.
- Optional detailed fields: longitude and position.

Useful filters:

- All planets.
- Benefic / malefic (only if the product defines the classification clearly).
- Retrograde only.
- House-wise grouping.

### APIs and calculation notes

- Main API: `GET /astrology/planet-position`
- Prokerala returns planet name, longitude, `is_retrograde`, sign (`rasi`), sign
  lord, and degree.
- The API field named `position` represents the sign position; it is **not** the
  natal house. Derive each planet's house relative to the Ascendant sign.
- Nakshatra, Nakshatra lord, and Pada may be derived from the returned sidereal
  longitude, using the same ayanamsa selected for the Kundali. This logic must be
  covered by tests before relying on it in the expert UI.

## 4. Timing

Timing is a dedicated section for Dasha and current transit context. It is the only
new top-level page added beyond the original plan because it is fundamental to an
expert's reading.

### Show

- Current Mahadasha.
- Current Antardasha.
- Next Antardasha.
- Start, end, and remaining duration.
- Expandable Mahadasha timeline.
- Sade Sati state and phase.
- Optional current Gochar summary, clearly marked as a transit rather than natal
  data.

### APIs

- Initial Dasha summary: `GET /astrology/kundli/advanced`
- Full timeline: `GET /astrology/dasha-periods`
- Sade Sati: `GET /astrology/sade-sati`

## 5. Doshas

This page should be called **Doshas**, not "All Doshas." Prokerala does not provide
one JSON API that evaluates every possible dosha.

### Show

#### Mangal Dosha

- Present or absent.
- Type / severity and explanation.
- Exceptions or cancellation conditions.
- Remedies only when supplied by the API.

#### Kaal Sarp Dosha

- Present or absent.
- Kaal Sarp type.
- Explanation.

#### Papa Samyam

- Total points.
- Ascendant, Moon, and Venus evaluation.
- Mars, Saturn, Sun, and Rahu dosha influences for each evaluation.

Sade Sati belongs in Timing because it is a Saturn transit cycle, not a natal
dosha.

### APIs

- Detailed Mangal Dosha: `GET /astrology/mangal-dosha/advanced`
- Kaal Sarp Dosha: `GET /astrology/kaal-sarp-dosha`
- Papa Samyam: `GET /astrology/papasamyam`

### Current limitations

Do not claim that the app detects Pitra Dosha, Guru Chandal, Kemadruma, Shani
Dosha, or other unsupported doshas. Supporting them would require a separately
defined and validated astrology rule engine; they are not returned by a general
Prokerala "all doshas" endpoint.

## 6. Yogas

Title this page **Detected Yogas**. Do not imply all results are positive: the
underlying data may describe positive, negative, or mixed influences.

### Show per Yoga

- Yoga name.
- Category, for example Raja, Nabhasa, Solar, Lunar, Career, or Wealth.
- Nature: positive, negative, or both.
- Areas of influence: career, wealth, marriage, health, and so on.
- The planets forming the Yoga.
- Expandable technical explanation.

The Summary page can show only the number of detected Yogas or the top few names,
then link here.

### APIs

- Detailed Yoga detection: `GET /astrology/raja-yoga`
- Basic Raja Yoga query, where relevant: `GET /astrology/yoga`

## API loading plan

| When | APIs |
| --- | --- |
| Kundali opens | `/astrology/kundli/advanced`, `/astrology/planet-position` |
| Charts opens | `/astrology/chart`, `/astrology/divisional-planet-position` |
| Timing opens | `/astrology/dasha-periods`, `/astrology/sade-sati` |
| Doshas opens | `/astrology/mangal-dosha/advanced`, `/astrology/kaal-sarp-dosha`, `/astrology/papasamyam` |
| Yogas opens | `/astrology/raja-yoga` |

Cache API data by client birth details, selected ayanamsa, selected language, chart
style, chart type, and (for transit) the requested datetime. A change to any
calculation input must invalidate the relevant cached data.

## Deferred features

The following are valuable but should not be part of the initial Kundali flow:

- Ashtakavarga and Sarvashtakavarga: available through
  `/astrology/ashtakavarga` and `/astrology/sarvashtakavarga`; suitable for a
  future Advanced Tools area.
- KP astrology: available through the `kp-*` endpoints; keep separate from the
  default Vedic Kundali experience.
- Marriage compatibility: Nadi, Bhakoot, and similar checks require two people;
  build them in a dedicated matching flow, not an individual's Kundali.
- Shadbala / complete planet-strength UI: the current Prokerala JSON API set does
  not expose a standalone Shadbala endpoint.
- Universal remedies or life predictions: do not invent these. Only display
  remedies explicitly returned by an API, or introduce an approved and validated
  content/rule system later.
