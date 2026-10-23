#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
VERSION=$(node -p "require('./package.json').version")

npx electron-builder --mac --universal --dir --publish never

SRC="dist/mac-universal/Liam Pomodoro.app"
TMP=$(mktemp -d)
STAGE=$(mktemp -d)

# The workspace may sit behind a file provider that adds FinderInfo xattrs,
# which codesign rejects. Copy without extended attributes before signing.
ditto --norsrc --noextattr "$SRC" "$TMP/Liam Pomodoro.app"
xattr -cr "$TMP/Liam Pomodoro.app"
codesign --force --deep --sign - "$TMP/Liam Pomodoro.app"
codesign --verify --deep --strict "$TMP/Liam Pomodoro.app"

ditto --norsrc --noextattr "$TMP/Liam Pomodoro.app" "$STAGE/Liam Pomodoro.app"
ln -s /Applications "$STAGE/Applications"
hdiutil create -volname "Liam Pomodoro $VERSION" -srcfolder "$STAGE" -ov -format UDZO \
  "dist/Liam-Pomodoro-$VERSION-universal.dmg"

rm -rf "$TMP" "$STAGE"
