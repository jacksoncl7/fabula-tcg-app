## Overview
This project is an open-source utility application for Fábula TCG, built with Flutter.

## Architecture
- Follow a Feature-First structure.
- Use Riverpod for state management.
- Ensure that game logic (e.g., resource increment rules) remains isolated in immutable controllers/notifiers.

## Important Business Rules
- Turn 1 = 2 Max Resources. Default increment = +2 resources per turn, up to a maximum of 10.
- Restore = Current Resources reset to Max Resources.

## Coding Standards
- Use strict linting according to `flutter_lints`.
- Add unit tests for all resource management logic.
