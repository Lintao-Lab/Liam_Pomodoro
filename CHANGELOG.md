# Changelog

## Unreleased

- Browser launchers take a free local port on first run and remember it, instead of assuming `8788` is free. A different port would also look like a new install to the browser, so the remembered port keeps settings and records intact.
- The launcher's server serves `index.html` only; the rest of the repository is no longer readable over HTTP.
- Terminal bridge finds the Pomodoro tab on any local port, not only `8788`.

## 0.1.0 — 2026-10-23

First public release.

- macOS desktop app (universal `.dmg`, ad-hoc signed, not notarised) with system notifications.
- Browser version: a single `index.html` with no dependencies.
- Focus, short-break and long-break sessions with an ink progress ring.
- FREE and CONTINUOUS flows.
- Start, pause, reset, skip, and Space-bar control.
- Round tracking and cycle-complete long break.
- Chime and optional system notifications.
- Focus records with notes, day navigation and daily totals.
- Configurable durations, cycle length, chime and notifications.
- macOS terminal control for the browser version (`start`, `pause`, `skip`, `reset`, `status`).
- macOS and Windows browser launchers.
