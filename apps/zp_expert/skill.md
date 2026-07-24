# SKILL.md

# ZP Expert Development Guide

This document defines the architecture, coding standards, and conventions for this project. Every new feature should follow these guidelines.

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

Use the nested data layout below for every new feature. This is the single
source of truth for feature data organisation: models live in `models/`,
repositories in `repository/`, and Riverpod providers in `provider/`.

Every feature follows this structure.

```
lib/
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

---

# Shared Code and `zp_core`

`zp_expert` is an application. `zp_core` is the shared package used by
`zp_expert` and `zp_client`. Before creating a feature, model, repository,
provider, widget, theme token, or asset, decide where it belongs.

## Put code in `zp_core` only when all three are true

1. Both `zp_expert` and `zp_client` use it now or it is on the current roadmap.
2. Its behaviour is identical or nearly identical in both apps.
3. It has no dependency on expert-only or client-only models, routes,
providers, API clients, themes, or user-role checks.

If any condition is false, keep the code in `zp_expert`.

When a feature is partly shared, split it instead of forcing it into one
role-aware widget:

- Put shared models, repository interfaces, generic providers, low-level
  widgets, and content-only views in `zp_core`.
- Keep expert API implementations, routes, `Scaffold`/app bars, navigation,
  role-specific copy, and expert-only composition in `zp_expert`.

`zp_core` must never import `zp_expert` or `zp_client`. Dependency direction is
always one-way:

```
zp_expert  ─┐
             ├──> zp_core
zp_client  ─┘
```

## How to create a shared feature

1. Read `../../packages/zp_core/core.md` in full; it is the source of truth
   for shared-package work.
2. Confirm the feature passes the three conditions above and compare any
   existing expert/client implementations before moving code.
3. Build the shared layers in this order:

   ```
   Model → Repository interface → Provider → Widgets → content-only view
   ```

4. Place the feature under
   `packages/zp_core/lib/src/features/feature_name/` using the same nested
   `data/models`, `data/repository`, `data/provider`, and
   `presentation/widgets` layout.
5. Export every consumer-facing type from
   `packages/zp_core/lib/zp_core.dart`. Apps import only
   `package:zp_core/zp_core.dart`, never `lib/src/**`.
6. Let each app provide app-specific repositories through Riverpod provider
   overrides and wrap shared content views in its own route and `Scaffold`.
7. Add shared assets to `zp_core/pubspec.yaml`; consuming apps reference them
   as `packages/zp_core/assets/...`.

## Handling expert/client differences

Use these options in order:

1. Constructor parameters for labels, callbacks, flags, and small UI changes.
2. Riverpod provider overrides for app-specific data and logic.
3. Composition slots/children for structural differences.

Never add `isExpert`, `isClient`, `ExpertRole`, or client-role branching inside
`zp_core` widgets. The app decides role-specific behaviour before calling the
shared widget.

## Shared-feature verification

For every new or migrated shared feature:

- Run `flutter analyze` in `packages/zp_core`, `apps/zp_expert`, and
  `apps/zp_client`.
- Search changed `zp_core` files for `zp_expert` and `zp_client` imports.
- State what was moved into `zp_core`, what remains app-specific, and how
  behavioural differences are supplied.

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

# Responsibilities

## feature.dart

Only responsible for assembling widgets.

No business logic.

No API calls.

No local data.

Should look similar to:

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

---

## data/

Contains all business logic.

### Model

Represents application data.

Never use raw Maps inside UI.

### Repository

Responsible for fetching data.

Currently returns local data.

Later it will use:

Supabase

↓

Node.js API

↓

Repository

↓

Riverpod

↓

UI

The UI should never know where data comes from.

Repository methods should return Future<T> whenever possible to simplify backend migration.

---

## Provider

Riverpod providers only.

The UI consumes providers.

The provider communicates with repositories.

Widgets never communicate directly with repositories.

---

## widgets/

Contains reusable widgets.

Each widget should have a single responsibility.

Avoid large widget files.

---

# UI Guidelines

Use Theme.of(context).colorScheme.

Do not hardcode colors unless required by the design.

Avoid hardcoded font families.

Responsive layouts only.

Use MediaQuery/LayoutBuilder when necessary.

Prefer const constructors.

Avoid duplicated widgets.

Use StatelessWidget whenever possible.

---

# Animations

Prefer custom animations instead of default Material widgets when the design requires it.

Examples

Custom Expansion

Custom Cards

Custom Buttons

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

Widgets

PascalCase

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

Variables

camelCase

Constants

lowerCamelCase or static const

---

# Theme

Colors should come from

```
Theme.of(context).colorScheme
```

or shared AppColors.

Do not redefine colors inside features.

---

# Shared Components

Shared widgets belong inside

```
lib/shared/widgets/
```

Example

```
gradient_page.dart
```

Feature-specific widgets remain inside their feature folder.

---

# State Management

Riverpod only.

No Provider package.

No GetX.

No Bloc.

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

No UI changes should be required when switching to backend.

---

# Code Quality

Always write production-ready code.

Avoid unnecessary comments.

Use meaningful names.

Keep widgets small.

Separate UI and business logic.

Follow DRY principles.

Use null safety.

Avoid magic numbers.

Prefer composition over large widgets.

---

# Development Workflow

Every feature should be built in this order

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

# Goal

The project should remain scalable, maintainable, and backend-independent while following a consistent architecture across all features.
