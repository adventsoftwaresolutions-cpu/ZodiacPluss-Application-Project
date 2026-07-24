# AGENTS.md — zp_expert Feature and Screen Builder

Scope: building or extending code in `zp_expert`, including a screen from a
Figma screenshot and work that may belong in the shared `zp_core` package.

**This file does not restate skill.md. `skill.md` is the zp_expert architecture
source of truth — folder structure, repository pattern, theming, naming, state
management, and the shared-code decision. Read it in full before touching
code. For code that belongs in `zp_core`, also read
`../../packages/zp_core/core.md` in full.**

## 0. Decide the ownership before writing code

Before creating a feature, check `skill.md`'s **Shared Code and `zp_core`**
section.

- Expert-only work belongs in `apps/zp_expert/lib/**`.
- Common expert/client behaviour belongs in `packages/zp_core/lib/**` only when
  it passes the three shared-code conditions.
- For a mixed feature, put only the common layers in `zp_core`; keep routes,
  scaffolds, navigation, expert API clients, and expert-specific composition
  in `zp_expert`.
- Do not add app imports, app role checks, or direct `lib/src/**` imports to
  shared code.
- If ownership is unclear, inspect `zp_client` before deciding. Do not create
  a second copy of a potentially shared component.

## 1. Read before writing any code, in this order
1. `skill.md` — full architecture. Do not re-derive or contradict it.
2. `../../packages/zp_core/core.md` — if the work could be shared.
3. `lib/theme/**` — colors, typography, and spacing tokens.
4. `lib/shared/widgets/`, `lib/shared/constants/`, and `packages/zp_core/lib/`
   — search for an existing shared component or asset.
5. Sibling `lib/features/*/widgets/` — reuse or extend close matches rather
   than creating near-duplicates.
6. `lib/navigation/router.dart` — route naming and shell structure.

If any of these don't answer something you need, stop and ask. Do not assume.

## 2. Repository stub — naming convention (extends skill.md's migration strategy)
skill.md says the repository "currently returns local data" and later swaps to Supabase/Node without UI changes. Concretely:
- Interface: `XRepository` (abstract), methods return `Future<T>` per skill.md.
- Current implementation: `StubXRepository implements XRepository`, hardcoded data.
- Models: include `fromJson`/`toJson` even though unused today, so the shape already matches the eventual API and the later swap is a one-line provider change.

## 3. Widget extraction — concrete threshold (sharpens skill.md's "keep widgets small")
If a `build()` method would exceed ~40 lines or mixes more than one visual concern, extract a widget. `feature.dart` stays composition-only, per skill.md.

## 4. Routing
Register every screen in `lib/navigation/router.dart` using `GoRoute`, consistent with the existing shell structure. Route paths as named constants, never inline literals repeated across files.

Shared `zp_core` views never own a route, `Scaffold`, or expert app bar. The
expert route wraps the shared content in the expert-specific screen chrome.

## 5. Assets
Expert-only assets are referenced through `lib/shared/constants/app_assets.dart`.
Shared assets belong in `zp_core`, are declared in `zp_core/pubspec.yaml`, and
are referenced as `packages/zp_core/assets/...`. Do not copy a shared asset
into both apps.

## 6. Reused components (zp_expert-specific, not in skill.md)
Header chat/notification icons → `zp_expert/widgets/header_action_button.dart`. Wire it in only if the Figma header actually shows those icons — don't force it onto every screen.

## 7. Ambiguity protocol (Figma-specific, not in skill.md)
If the screenshot doesn't show one of: empty state, loading state, error state, or a tap target's destination — ask before inventing one. Silent guessing here is how different screens end up with inconsistent invented behavior baked in as if it were spec.

## 8. Definition of done (every screen, no exceptions)
- `flutter analyze` run in every changed package/app, zero errors — paste the actual terminal output, not a summary.
- Do not run `flutter run` until analyze is clean.
- State explicitly what was reused vs. newly built (the reuse scan actually happened, not skipped).
- For shared work, state the `zp_core` ownership decision, provider overrides
  or parameters used for app differences, and the result of the forbidden
  import check.
