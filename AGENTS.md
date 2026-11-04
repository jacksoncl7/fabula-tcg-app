# AGENTS.md

## Overview
This repository contains the official open-source mobile companion and tournament referee utility application for **Fábula TCG**, developed with Flutter and Dart. It is designed as an offline-first tabletop digital assistant for physical gameplay, streaming, and tournament management.

---

## Technical Stack & Dependencies

The project relies on a lightweight, offline-first, pure Dart/Flutter architecture:

- **Flutter SDK**: `>= 3.22.0` | **Dart SDK**: `>= 3.4.0 < 4.0.0`
- **State Management**: `flutter_riverpod: ^2.6.1` (`StateNotifier` / pure immutable state controllers)
- **Local Persistence**: `hive: ^2.2.3`, `hive_flutter: ^1.1.0`, and `path_provider: ^2.1.4` (offline-first, zero cloud dependencies required for gameplay)
- **Device & Ergonomics**: `wakelock_plus: ^1.2.8` (keeps screen active during tabletop matches)
- **Tooling & Linting**: `flutter_lints: ^5.0.0`, strict `analysis_options.yaml`, and root `Makefile`
- **Dependency Philosophy**: Avoid code-generation dependency hell (`riverpod_generator`/`hive_generator` version solver conflicts with the Dart SDK analyzer). Prioritize pure Dart immutable models and manual `copyWith`/equality patterns unless explicitly requested.

---

## Architectural Principles

Follow **Clean Architecture** with a **Feature-First / Modular** organization:

```text
lib/
├── core/             # Cross-cutting concerns: constants, errors/exceptions, theme, utils
├── data/             # Offline persistence, datasources, local repositories
├── domain/           # Pure business logic: entities, repository interfaces, game rules
└── presentation/     # UI components, screen layouts, table ergonomics, Riverpod state
```

### Key Engineering Rules:
1. **Separation of Concerns**: Game logic must reside exclusively in pure domain models and immutable notifiers/controllers. Presentation widgets only render state and dispatch intent.
2. **Offline-First & Zero Friction**: All match operations, counter tracking, rules auditing, and history must function 100% offline without mandatory account creation or network access.
3. **Immutability**: Domain models and states must be immutable with proper equality checks (`operator ==` & `hashCode`) and `copyWith` methods.
4. **Tabletop Ergonomics**: Support table play with large high-contrast numerals legible from 1+ meter distance, 180° mirrored rotation for opponents (`RotatablePlayerZone`), haptic feedback, and a stream/webcam mode.

---

## Fábula TCG Core Business & Game Rules

All game logic implemented in the application must strictly adhere to the official Fábula TCG Rulebook:

1. **Resource Progression (Rule 1.7.2c / 1.18.10)**:
   - Turn 1 starts with 2 Max Resources.
   - Default progression: +2 Max Resources per active turn up to the standard cap of 10.
   - Non-negative integer values only (Rule 1.8.1).
2. **Inter-Turn Maneuver Resources (Rule 1.7.3)**:
   - Unspent resources from an active player's turn remain available during the opponent's turn to pay for instant Maneuvers/reactions.
3. **Restoration Phase (Rule 1.7.2b / 1.18.9)**:
   - Residual resources from the previous turn are wiped and Current Resources reset to the turn's Max Resources.
   - Untapping permanents/allies costs the standard 1 resource per ally.
4. **Territory Zone & Bases (Rules 3.1.7 – 3.1.11, 1.22.5a)**:
   - Each player has 5 bases: 4 Surroundings (5 resistance each) and 1 Center (15 resistance).
   - Base damage is persistent between turns.
   - **Exposed Center Rule**: The Center cannot be attacked or influenced as long as the player controls at least 1 original Surrounding base. Conquered enemy bases do not protect the Center.
   - **Influence Contest Formula (Rule 1.22.5a)**: A base is conquered if $\sum(\text{Attacker Influence}) > \sum(\text{Blocker Influence}) + \text{Base Resistance}$.
   - **Victory Condition**: Destroying or conquering the enemy Center results in immediate match victory (or loss via Deck Out under Rule 1.5.3a).
---

## Coding & Contribution Standards

- **Static Analysis**: Maintain 0 errors and 0 warnings on `flutter analyze`.
- **Testing**: Add unit tests for all domain rules, exceptions, and critical state transformations. All PRs must pass `flutter test` (or `make check`).
- **Formatting**: Always format code using `dart format lib test` (or `make format`).
- **Commits & Gitflow**: Follow Conventional Commits (`feat:`, `fix:`, `refactor:`, `test:`, `chore:`, `docs:`). Use isolated feature branches, rebase against `main`, and deliver via squash merges as specified in `skills/gitflow/SKILL.md`.
