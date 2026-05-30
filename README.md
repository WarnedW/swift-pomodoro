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
