#!/bin/bash
# Liam Pomodoro launcher — double-click to start the local server (if needed) and open the app.
# Serving over http://127.0.0.1 (instead of file://) is what allows browser
# notification permission to be granted; file:// pages cannot receive it.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"
URL="http://127.0.0.1:8788/"

if ! curl -s --max-time 1 -o /dev/null "$URL"; then
  cd "$ROOT" || exit 1
  nohup python3 -m http.server 8788 --bind 127.0.0.1 >/dev/null 2>&1 &
  for i in $(seq 1 25); do
    curl -s --max-time 1 -o /dev/null "$URL" && break
    sleep 0.2
  done
fi

open "$URL"
