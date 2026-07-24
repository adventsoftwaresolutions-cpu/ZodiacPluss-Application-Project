# CORE.md — zp_core Shared Package Architecture Guide

This document is the architecture source of truth for `zp_core`, the same way `skill.md` is for `zp_expert`. It applies to **every** file added to `zp_core`, not to a specific feature. If a future feature needs an exception to something here, that exception gets written into this file — it does not live only in someone's head or in a chat log.

---

# Purpose

`zp_core` is not an app. It has no home screen, no routes, no login flow. It exists to hold logic and UI that both `zp_expert` and `zp_client` need, so a fix written once doesn't get re-written, re-tested, and re-diverged twice.

Every file that goes into `zp_core` must justify why it doesn't belong in one specific app.

---

# Hard rule: when something does NOT belong in zp_core

Before moving or adding anything to `zp_core`, it must pass all three:

1. **Both apps actually use it** — today, or on the current roadmap. Not "might be useful someday."
2. **The behavior is identical or near-identical** in both apps. If expert and client need meaningfully different behavior, that difference must be expressible via constructor parameters or provider overrides — not `if (isExpert)` branching buried inside the shared widget.
3. **No dependency on anything app-specific** — no expert-only model, no client-only route, no app-specific provider.

If a feature exists in both apps but diverges a lot, don't force one shared widget. Split it: put the genuinely common parts (models, base repository interface, low-level widgets) in `zp_core`, and let each app compose its own screen-level behavior on top of them.

---

# Tech stack (must not diverge from zp_expert / zp_client)

- Flutter (Material 3)
- Riverpod only — no Provider package, no GetX, no Bloc
- Repository pattern — abstract interface + stub/local implementation until backend is wired
- Backend target: Node.js API. Do not let Supabase-specific types leak into repository interfaces or models — if Supabase is used for a specific concern (e.g. auth/session), keep those types inside the concrete implementation only

---

# Package boundary — the rule that matters most

`zp_core` **never** imports anything from `zp_expert` or `zp_client`. Not a model, not a constant, not a single import. Dependency direction is one-way:

```
zp_expert  ─┐
             ├──> zp_core
zp_client  ─┘
```

Before adding any file to `zp_core`, grep it for `zp_expert` / `zp_client` imports. If one exists, the file is not actually shared yet — either strip the dependency or leave the file where it is.

---

# Public API discipline

`zp_core` exposes a single entry point. Nothing inside `lib/src/` is imported directly by consuming apps.

```
zp_core/
  lib/
    zp_core.dart          <- the only file consuming apps import from
    src/
      ...
```

`zp_core.dart` is a barrel file:

```dart
export 'src/features/example_feature/data/models/example_model.dart';
export 'src/features/example_feature/data/repository/example_repository.dart';
export 'src/features/example_feature/data/provider/example_provider.dart';
export 'src/features/example_feature/presentation/example_view.dart';
export 'src/shared/theme/app_colors.dart';
export 'src/shared/widgets/shared_button.dart';
```

If both apps need it, export it. If only one app needs it, it doesn't belong in `zp_core`.

---

# Folder structure (canonical)

Same layered discipline as `skill.md`, applied at the package level — nested `models/`, `repository/`, `provider/` subfolders, not flat files. This is deliberate: nothing should need re-learning when moving between an app feature and a shared feature.

```
zp_core/
  lib/
    zp_core.dart
    src/
      features/
        feature_name/
          data/
            models/
              feature_name_model.dart
            repository/
              feature_name_repository.dart       (abstract)
              stub_feature_name_repository.dart
            provider/
              feature_name_provider.dart
          presentation/
            widgets/
              widget_one.dart
              widget_two.dart
            feature_name_view.dart               <- content only, see rule below
      shared/
        theme/
          app_colors.dart
          app_text_styles.dart
          app_spacing.dart
        widgets/
          shared_button.dart
          shimmer_loader.dart
        constants/
          app_assets.dart
        utils/
        services/
          api_client.dart
  assets/
    icons/
    animations/
  pubspec.yaml
```

---

# The rule that will break things if ignored: zp_core owns content, never routes

`feature_name_view.dart` is a plain content widget. It is **not** a `Scaffold`, it does not know its own route path, and it does not own an `AppBar` unless that app bar is genuinely pixel-identical in both apps — assume it isn't unless verified.

`zp_core` exports:

```dart
class FeatureNameView extends ConsumerWidget { ... }   // returns content only
```

Each app's router wraps it:

```dart
GoRoute(
  path: AppRoutes.featureName,
  builder: (context, state) => Scaffold(
    appBar: ExpertHeader(...),   // app-specific
    body: const FeatureNameView(),
  ),
)
```

Routing, navigation, and screen chrome are always app-level decisions. The first time `zp_core` owns a route and one app needs a slightly different header or back-button behavior, someone will "temporarily" hack a role check into the shared widget — that's how shared packages rot. Don't let that be the first exception.

---

# Handling behavioral differences between expert and client

In order of preference:

1. **Constructor parameters** — pass in whatever differs (labels, visibility flags, callbacks) from the app-level screen. Cheapest option; keeps `zp_core` dumb.
2. **Provider override** — if the difference is data/logic, not just UI: define one repository interface with the full superset of methods, and let each app's `ProviderScope` override which concrete implementation is wired in.
3. **Composition, not conditionals** — if the divergence is structural (e.g. one app needs an entire extra section), that section is a separate widget passed in as a slot/child, not an `if (role == Role.expert)` inside the shared widget's `build()`.

What not to do: no `enum UserRole` checks inside a `zp_core` widget's `build()`. `zp_core` widgets should not know what "expert" or "client" means at all — the app layer decides what to pass in. The moment a shared widget needs a third role, role-check branching becomes unmaintainable; parameters and composition don't have that failure mode.

---

# Data layer rules (same discipline as skill.md, restated for zp_core)

- **Models** — plain Dart classes, include `fromJson`/`toJson` even if unused today, no raw `Map` crossing into presentation.
- **Repository** — abstract interface + `Stub*Repository` implementation with hardcoded/local data until backend is live. Methods return `Future<T>`.
- **Provider** — Riverpod only. Widgets never call repositories directly.
- **Layer order** — Model → Repository → Provider → Widgets → View, same as skill.md. Do not skip layers.

---

# Theming

New shared tokens (colors, text styles, spacing) are defined once in `zp_core/src/shared/theme/` and consumed by both apps via `Theme.of(context).colorScheme` (wired to zp_core's theme data) or directly via `AppColors` / `AppTextStyles` exported from `zp_core.dart`. Do not redefine a color or text style locally in an app if `zp_core` already has it.

This document does **not** decide the migration of `zp_expert`'s existing `lib/theme/**` into `zp_core` — that requires diffing the existing tokens against `zp_client`'s theme first to check for divergence, and should be its own deliberate task, not a silent side effect of an unrelated feature.

---

# Assets

Declare assets in `zp_core/pubspec.yaml` under `flutter: assets:`. Consuming apps reference them as `packages/zp_core/assets/icons/...` — never copy asset files into each app individually. `app_assets.dart` (the constants file) lives in `zp_core/src/shared/constants/`, and both apps import their asset path constants from there. If `app_assets.dart` already exists separately inside `zp_expert`, that's a divergence to resolve during migration — don't add a third copy.

---

# Naming convention (identical to skill.md — no new rules invented)

```
feature_name_model.dart
feature_name_repository.dart
stub_feature_name_repository.dart
feature_name_provider.dart
feature_name_view.dart

widget_one.dart
widget_two.dart
```

Widgets: PascalCase. Private widgets: `_Header`, `_ActionButton`. Variables: camelCase.

---

# Migrating an existing feature into zp_core — checklist

1. Grep every file being moved for app-specific imports (models, providers, theme constants, route names). Every hit must be resolved before the file moves.
2. Diff behavior between apps if an equivalent already exists on both sides — don't assume identical, check.
3. Define the repository interface with the full superset of methods either app needs, even if only one app currently uses some of them.
4. Strip the `Scaffold`/`AppBar`/route out of the moved view — it becomes a content-only widget per the routing rule above.
5. Re-wire each app's router to build its own `Scaffold` around the imported `FeatureNameView`.
6. Add `zp_core` as a path dependency in both apps' `pubspec.yaml` if not already present; run `flutter pub get` in both.
7. `flutter analyze` clean in `zp_core` AND in both consuming apps before calling the migration done — a clean `zp_core` with a broken `zp_expert` build is not done.

---

# Definition of done (every zp_core feature/file, no exceptions)

- `flutter analyze` run inside `zp_core/`, zero errors — paste actual terminal output, not a summary.
- Confirmed no import of `zp_expert`/`zp_client` anywhere in the changed files (grep check, not a guess).
- Confirmed role-specific differences are handled via inputs (parameters/composition/provider override), not internal conditionals.
- Exported from `zp_core.dart` if consuming apps need it.
- State explicitly what was moved from an existing app vs. newly written for zp_core.
