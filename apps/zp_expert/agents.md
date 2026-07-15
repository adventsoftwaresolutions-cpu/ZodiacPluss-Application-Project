# AGENTS.md — zp_expert Screen Builder (Figma → Flutter)

Scope: building or extending a screen inside `lib/features/**` in `zp_expert`, from a Figma screenshot.

**This file does not restate skill.md. skill.md is the architecture source of truth — folder structure, repository pattern, theming, naming, state management. Read it in full before touching code. This file only adds what skill.md doesn't cover: the Figma-to-code workflow itself.**

## ⚠ Open conflict — resolve before relying on this
skill.md specifies flat files under `data/`:
```
data/
    feature_model.dart
    feature_repository.dart
    feature_provider.dart
```
The wallet feature (already built in zp_expert) uses subfolders instead:
```
data/
    models/
    repository/
    providers/
```
Until this is reconciled, **follow skill.md as written (flat files)** for any new screen — it's the stated source of truth. Do not silently match wallet's pattern, and do not silently "fix" wallet to match skill.md. Flag the mismatch and ask Adii which one is correct, then update skill.md itself so this stops recurring.

## 0. Read before writing any code, in this order
1. `skill.md` — full architecture. Do not re-derive or contradict it.
2. `lib/theme/**` — colors, typography, spacing tokens (skill.md: "colors from Theme.of(context).colorScheme or shared AppColors, never redefine inside features").
3. `lib/shared/widgets/` and `constants/app_assets.dart` — existing shared widgets and assets.
4. Sibling `lib/features/*/widgets/` — search for a widget that already does what this screen needs. skill.md says "avoid duplicated widgets" — this is how you actually enforce that: search before you build. If something close exists, reuse or extend it, don't fork a near-duplicate.
5. `lib/navigation/router.dart` — existing route naming and shell structure (not covered by skill.md).

If any of these don't answer something you need, stop and ask. Do not assume.

## 1. Repository stub — naming convention (extends skill.md's migration strategy)
skill.md says the repository "currently returns local data" and later swaps to Supabase/Node without UI changes. Concretely:
- Interface: `XRepository` (abstract), methods return `Future<T>` per skill.md.
- Current implementation: `StubXRepository implements XRepository`, hardcoded data.
- Models: include `fromJson`/`toJson` even though unused today, so the shape already matches the eventual API and the later swap is a one-line provider change.

## 2. Widget extraction — concrete threshold (sharpens skill.md's "keep widgets small")
If a `build()` method would exceed ~40 lines or mixes more than one visual concern, extract a widget. `feature.dart` stays composition-only, per skill.md.

## 3. Routing (not in skill.md)
Register every screen in `lib/navigation/router.dart` using `GoRoute`, consistent with the existing shell structure. Route paths as named constants, never inline literals repeated across files.

## 4. Assets (not in skill.md)
Icons and animations referenced only via `lib/shared/constants/app_assets.dart`. New asset in the Figma export not yet registered → add the constant, state exactly which file needs to be dropped into `assets/icons/`. Don't invent a path.

## 5. Reused components (zp_expert-specific, not in skill.md)
Header chat/notification icons → `zp_expert/widgets/header_action_button.dart`. Wire it in only if the Figma header actually shows those icons — don't force it onto every screen.

## 6. Ambiguity protocol (Figma-specific, not in skill.md)
If the screenshot doesn't show one of: empty state, loading state, error state, or a tap target's destination — ask before inventing one. Silent guessing here is how different screens end up with inconsistent invented behavior baked in as if it were spec.

## 7. Definition of done (every screen, no exceptions)
- `flutter analyze` run, zero errors — paste the actual terminal output, not a summary.
- Do not run `flutter run` until analyze is clean.
- State explicitly what was reused vs. newly built (§0.4 reuse scan actually happened, not skipped).