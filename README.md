# Pomodoro for macOS

A small native SwiftUI Pomodoro timer for macOS.

## Features

- Focus, short break, and long break modes
- Start, pause, reset, and skip controls
- Configurable session durations
- Configurable long-break cadence
- Optional auto-start and completion sound
- Local reports for today, the week, totals, and streaks
- Achievement tracking based on completed focus sessions

## Run from source

```sh
swift run Pomodoro
```

## Build a macOS app bundle

```sh
chmod +x scripts/build_app.sh
./scripts/build_app.sh
```

The app bundle is created at:

```text
build/Pomodoro.app
```

## Project structure

```text
Sources/PomodoroApp
├── App                 # SwiftUI app entry point and app-level scenes
├── Core
│   ├── Domain          # Models, statistics, achievements, and scheduling rules
│   └── Services        # Runtime abstractions such as ticking and feedback
├── Data
│   └── Persistence     # UserDefaults-backed storage
├── DesignSystem        # Shared theme and reusable UI components
└── Features
    ├── Achievements    # Achievement UI
    ├── Reports         # Report UI
    ├── Settings        # Settings UI
    ├── Shell           # Main navigation/shell
    └── Timer           # Timer state controller
```
