# SKILL.md

# ZP Client Development Guide

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
