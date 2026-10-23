# Liam Pomodoro

[![version](https://img.shields.io/badge/version-0.1.0-141414)](CHANGELOG.md)
[![licence](https://img.shields.io/badge/licence-MIT-141414)](LICENSE)

A Pomodoro timer with an ivory-and-black editorial look. The same interface runs as a macOS app or as a single HTML file in any browser. No account, no network requests, no data leaves your machine.

![Liam Pomodoro](screenshot.png)

## Install (macOS)

Download the latest universal `.dmg` from [Releases](https://github.com/Lintao-Lab/Liam_Pomodoro/releases/latest), open it, and drag **Liam Pomodoro** to Applications.

The build is ad-hoc signed but not notarised. On first launch, right-click **Liam Pomodoro** in Applications and choose **Open** (once only). After that it launches normally. Requires macOS 13 or later.

## Features

- **macOS app** — a real window with system notifications, no server and no browser tab.
- Three session types — focus, short break and long break — with a thin ink progress ring.
- Two flows: **FREE** waits for you after each session; **CONTINUOUS** chains focus and breaks automatically.
- Start, pause, reset and skip; Space starts and pauses; the title bar shows the live countdown.
- Round tracking — a "ROUND x OF n" label and a row of dots, ending with "CYCLE COMPLETE — LONG BREAK".
- End-of-session chime (Web Audio, no audio files) and optional persistent system notifications, including while the window is hidden.
- **Records** — every completed focus session is logged with its start time and duration, plus an inline note; browse days, see daily totals, delete entries.
- **Settings** — focus, short-break and long-break lengths, rounds per cycle, chime and notifications; saved locally.
- Today's count comes from the records using local dates, so midnight is correct in any time zone.
- Terminal control on macOS (browser version): `start`, `pause`, `skip`, `reset`, `status`.
- No account and no network requests.

## Run from source

- **macOS app** — `npm install && npm start`.
- **Browser, macOS** — double-click `launchers/macos.command`.
- **Browser, Windows** — double-click `launchers/windows.vbs`.
- **Any browser** — open `index.html`.

The browser launchers start a tiny local server and open it. It takes a free port on `127.0.0.1` the first time you run it and remembers that port afterwards, so a port already in use on your machine cannot break the launcher, and your settings and records stay put. Opening `index.html` directly works for everything except system notifications: browsers refuse notification permission on `file://` pages.

Both launchers need Python 3: `xcode-select --install` on macOS, [python.org](https://www.python.org/downloads/) on Windows.

## Browser launchers

The macOS app has its own installer. The browser version has none; to put a launcher somewhere else, ask an AI agent:

> Create a Liam Pomodoro launcher at `<location>` using `<path-to-repo>/launchers/macos.command`.

Agent notes:

- **macOS** — write a small executable `.command` file at the requested location that `exec`s the repo's `launchers/macos.command`, and keep the executable bit. Do not copy `index.html` or `launchers/serve.py`; the launcher resolves them relative to the repository.
- **Windows** — create a shortcut at the requested location whose target is `wscript.exe "<repo>\launchers\windows.vbs"`.

## Terminal control (macOS, browser version)

```sh
./terminal/pomodoro           # toggle start / pause (default)
./terminal/pomodoro start     # start
./terminal/pomodoro pause     # pause
./terminal/pomodoro skip      # next session
./terminal/pomodoro reset     # reset the current session
./terminal/pomodoro status    # e.g. FOCUS 24:31 · RUNNING · TODAY 2
```

This controls the timer tab in Safari or Chrome, not the desktop app. The tab must be open, and the browser must allow JavaScript from Apple Events (Safari: Develop ▸ Allow JavaScript from Apple Events; Chrome: View ▸ Developer). The first run also asks macOS to let your terminal control the browser.

To install it as a command:

```sh
echo "alias pomodoro='$(pwd)/terminal/pomodoro'" >> ~/.zshrc
```

## Data

Everything stays local. The browser version stores settings and records in `localStorage`; the macOS app stores them in `~/Library/Application Support/Liam Pomodoro`. No data is sent anywhere.

## Version

0.1.0 — see [CHANGELOG.md](CHANGELOG.md).

## Licence

[MIT](LICENSE)
