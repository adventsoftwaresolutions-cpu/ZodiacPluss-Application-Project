# CLIENT.md — ZP Client Development Guide & Feature Builder

This document is the architecture, coding standard, and build-workflow source of truth for `zp_client`. It is the client-side counterpart to `zp_expert`'s `skill.md` + `agents.md`, combined into a single file. Every new feature — hand-written or built by an AI agent from a Figma screenshot — follows this document.

**Read this file in full before writing any code.** For code that could be shared with `zp_expert`, also read `../../packages/zp_core/core.md` in full — do not re-derive or contradict it.

---

# Tech Stack

Frontend
- Flutter (Material 3)
- Riverpod
- Repository Pattern

Backend (Current/Future)
- Local Repository (Current)
- Supabase (Upcoming)
- Node.js API (Upcoming)

Architecture
- Feature-first architecture
- Clean separation between UI and Data
- Responsive UI
- Reusable widgets

---

# Folder Structure

## Data layout (canonical)

Use the nested data layout below for every new feature. Models live in `models/`, repositories in `repository/`, Riverpod providers in `provider/`. Every feature follows this structure.

```
apps/zp_client/lib/
    features/
        feature_name/
            feature.dart
            data/
                models/
                    feature_model.dart
                repository/
                    feature_repository.dart
                provider/
                    feature_provider.dart
            widgets/
                widget_one.dart
                widget_two.dart
```

Example

```
faq/
    faq.dart
    data/
        models/
            faq_model.dart
        repository/
            faq_repository.dart
        provider/
            faq_provider.dart
    widgets/
        faq_header.dart
        faq_item.dart
        faq_list.dart
```

---

# Shared Code and `zp_core`

`zp_client` is an application. `zp_core` is the shared package used by `zp_client` and `zp_expert`. Before creating a feature, model, repository, provider, widget, theme token, or asset, decide where it belongs.

## Put code in `zp_core` only when all three are true

1. Both `zp_client` and `zp_expert` use it now or it is on the current roadmap.
2. Its behaviour is identical or nearly identical in both apps.
3. It has no dependency on client-only or expert-only models, routes, providers, API clients, themes, or user-role checks.

If any condition is false, keep the code in `zp_client`.

When a feature is partly shared, split it instead of forcing it into one role-aware widget:

- Shared models, repository interfaces, generic providers, low-level widgets, and content-only views → `zp_core`.
- Client API implementations, routes, `Scaffold`/app bars, navigation, role-specific copy, and client-only composition → `zp_client`.

`zp_core` must never import `zp_client` or `zp_expert`. Dependency direction is always one-way:

```
zp_client  ─┐
             ├──> zp_core
zp_expert  ─┘
```

## Ownership decision — before writing any code

- Client-only work belongs in `apps/zp_client/lib/**`.
- Common client/expert behaviour belongs in `packages/zp_core/lib/**` only when it passes the three conditions above.
- For a mixed feature, put only the common layers in `zp_core`; keep routes, scaffolds, navigation, client API clients, and client-specific composition in `zp_client`.
- Do not add app imports, app role checks, or direct `lib/src/**` imports to shared code.
- If ownership is unclear, inspect `zp_expert` before deciding. Do not create a second copy of a potentially shared component — check whether expert already built it and it should move to `zp_core` instead.

## How to create a shared feature

1. Read `../../packages/zp_core/core.md` in full; it is the source of truth for shared-package work.
2. Confirm the feature passes the three conditions above and compare any existing client/expert implementations before moving code.
3. Build the shared layers in this order:

   ```
   Model → Repository interface → Provider → Widgets → content-only view
   ```

4. Place the feature under `packages/zp_core/lib/src/features/feature_name/` using the same nested `data/models`, `data/repository`, `data/provider`, and `presentation/widgets` layout.
5. Export every consumer-facing type from `packages/zp_core/lib/zp_core.dart`. Apps import only `package:zp_core/zp_core.dart`, never `lib/src/**`.
6. Provide client-specific data/logic through Riverpod provider overrides; wrap shared content views in `zp_client`'s own route and `Scaffold`.
7. Add shared assets to `zp_core/pubspec.yaml`; reference them as `packages/zp_core/assets/...`.

## Handling client/expert differences

Use these options in order:

1. Constructor parameters for labels, callbacks, flags, and small UI changes.
2. Riverpod provider overrides for app-specific data and logic.
3. Composition slots/children for structural differences.

Never add `isClient`, `isExpert`, `ClientRole`, `ExpertRole`, or role branching inside `zp_core` widgets. The app decides role-specific behaviour before calling the shared widget.

## Shared-feature verification

For every new or migrated shared feature:

- Run `flutter analyze` in `packages/zp_core`, `apps/zp_client`, and `apps/zp_expert`.
- Search changed `zp_core` files for `zp_client` and `zp_expert` imports.
- State what was moved into `zp_core`, what remains app-specific, and how behavioural differences are supplied.

---

# Read before writing any code, in this order

1. This document — full architecture. Do not re-derive or contradict it.
2. `../../packages/zp_core/core.md` — if the work could be shared.
3. `lib/theme/**` — colors, typography, and spacing tokens.
4. `lib/shared/widgets/`, `lib/shared/constants/`, and `packages/zp_core/lib/` — search for an existing shared component or asset before building a new one.
5. Sibling `lib/features/*/widgets/` — reuse or extend close matches rather than creating near-duplicates.
6. `lib/navigation/router.dart` — existing route naming and shell structure.

If any of these don't answer something you need, stop and ask. Do not assume.

---

# Responsibilities

## feature.dart

Only responsible for assembling widgets. No business logic. No API calls. No local data.

```
GradientPage(
    child: Column(
        children: [
            Header(),
            Body(),
        ],
    ),
)
```

## data/

Contains all business logic.

**Model** — represents application data. Never use raw Maps inside UI.

**Repository** — responsible for fetching data. Currently returns local data; later swaps to:

```
Supabase
↓
Node.js API
↓
Repository
↓
Riverpod
↓
UI
```

The UI should never know where data comes from. Concretely:
- Interface: `XRepository` (abstract), methods return `Future<T>`.
- Current implementation: `StubXRepository implements XRepository`, hardcoded data.
- Models include `fromJson`/`toJson` even though unused today, so the shape already matches the eventual API and the later backend swap is a one-line provider change.

## Provider

Riverpod providers only. The UI consumes providers. The provider communicates with repositories. Widgets never communicate directly with repositories.

## widgets/

Contains reusable widgets. Each widget should have a single responsibility. Avoid large widget files.

If a `build()` method would exceed ~40 lines or mixes more than one visual concern, extract a widget. `feature.dart` stays composition-only.

---

# UI Guidelines

Use `Theme.of(context).colorScheme`.

Do not hardcode colors unless required by the design.

Avoid hardcoded font families.

Responsive layouts only. Use `MediaQuery`/`LayoutBuilder` when necessary.

Prefer const constructors.

Avoid duplicated widgets.

Use `StatelessWidget` whenever possible.

---

# Animations

Prefer custom animations instead of default Material widgets when the design requires it.

Examples: Custom Expansion, Custom Cards, Custom Buttons.

---

# Naming Convention

Files

```
faq_model.dart
faq_provider.dart
faq_repository.dart

faq_header.dart
faq_item.dart
faq_list.dart
```

Widgets — PascalCase

```
FaqHeader
FaqItem
FaqList
```

Private widgets

```
_Header
_ActionButton
```

Variables — camelCase. Constants — lowerCamelCase or `static const`.

---

# Theme

Colors should come from `Theme.of(context).colorScheme` or shared `AppColors`. Do not redefine colors inside features. Tokens shared with `zp_expert` live in `zp_core`, not duplicated locally.

---

# Shared Components

Widgets shared only within `zp_client` belong inside `lib/shared/widgets/` (e.g. `gradient_page.dart`). Feature-specific widgets remain inside their feature folder.

Widgets shared with `zp_expert` belong in `zp_core`, not here — see **Shared Code and zp_core** above.

---

# State Management

Riverpod only. No Provider package. No GetX. No Bloc.

---

# Routing

Register every screen in `lib/navigation/router.dart` using `GoRoute`, consistent with the existing shell structure. Route paths as named constants, never inline literals repeated across files.

Shared `zp_core` views never own a route, `Scaffold`, or client app bar. The client route wraps the shared content in client-specific screen chrome.

---

# Assets

Client-only assets are referenced through `lib/shared/constants/app_assets.dart`. Shared assets belong in `zp_core`, are declared in `zp_core/pubspec.yaml`, and are referenced as `packages/zp_core/assets/...`. Do not copy a shared asset into both apps.

---

# Backend Migration Strategy

Current

```
Local Variables
↓
Repository
↓
Provider
↓
UI
```

Future

```
Supabase
↓
Node.js API
↓
Repository
↓
Riverpod
↓
UI
```

No UI changes should be required when switching backend.

---

# Reused components

> Note: `zp_expert`'s agents.md pointed at a specific known file (`header_action_button.dart`) for header icon reuse. I don't have visibility into `zp_client`'s current widget tree to know if an equivalent exists or what it's named — don't assume it does. Verify against the actual codebase before building a new one.

Before building a new header, notification, or action-button style widget, check `lib/shared/widgets/` and sibling feature folders for an existing close match. Reuse or extend it rather than forking a near-duplicate. Wire it in only if the Figma screen actually needs it — don't force a shared component onto every screen.

---

# Ambiguity protocol

If the screenshot doesn't show one of: empty state, loading state, error state, or a tap target's destination — ask before inventing one. Silent guessing here is how different screens end up with inconsistent invented behavior baked in as if it were spec.

---

# Code Quality

Always write production-ready code. Avoid unnecessary comments. Use meaningful names. Keep widgets small. Separate UI and business logic. Follow DRY principles. Use null safety. Avoid magic numbers. Prefer composition over large widgets.

---

# Development Workflow

Every feature should be built in this order:

```
Model
↓
Repository
↓
Provider
↓
Widgets
↓
feature.dart
```

Do not skip layers.

---

# Definition of done (every feature/screen, no exceptions)

- `flutter analyze` run in every changed package/app, zero errors — paste the actual terminal output, not a summary.
- Do not run `flutter run` until analyze is clean.
- State explicitly what was reused vs. newly built (confirm the reuse scan in §"Read before writing any code" actually happened, not skipped).
- For shared work: state the `zp_core` ownership decision, the provider overrides or parameters used for app differences, and the result of the forbidden-import check (`zp_client`/`zp_expert` grep on changed `zp_core` files).

---

# Goal

The project should remain scalable, maintainable, and backend-independent while following a consistent architecture across all features, in both `zp_client` and `zp_expert`.
