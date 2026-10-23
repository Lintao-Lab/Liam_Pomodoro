#!/bin/bash
# Liam Pomodoro launcher — double-click to open the browser version.
# serve.py picks a free port on first run and remembers it, then opens the page.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v python3 >/dev/null 2>&1; then
  PYTHON=python3
elif command -v python >/dev/null 2>&1; then
  PYTHON=python
else
  echo "Liam Pomodoro needs Python 3. Run: xcode-select --install" >&2
  osascript -e 'display alert "Python 3 is required" message "Install the Xcode Command Line Tools with: xcode-select --install"' >/dev/null 2>&1
  exit 1
fi

nohup "$PYTHON" "$DIR/serve.py" "$@" >"${TMPDIR:-/tmp}/liam-pomodoro-serve.log" 2>&1 &
