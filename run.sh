#!/usr/bin/env bash
# Launch Picture Time in a locked-down Chrome kiosk window.
#
#   ./run.sh            kiosk mode (full-screen, no tabs, no address bar)
#   ./run.sh --window   normal app window (handy for testing)
#
# To quit kiosk mode: tap the 🔒 in the slideshow, answer the question, then press Alt+F4.
set -euo pipefail

PORT="${PORT:-8765}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE="${XDG_CONFIG_HOME:-$HOME/.config}/picture-time-browser"
URL="http://127.0.0.1:${PORT}/"

BROWSER=""
for b in google-chrome google-chrome-stable chromium chromium-browser brave-browser microsoft-edge; do
  if command -v "$b" >/dev/null 2>&1; then BROWSER="$b"; break; fi
done
if [[ -z "$BROWSER" ]]; then
  echo "No Chrome/Chromium-based browser found. Open $DIR/index.html in any browser instead." >&2
  exit 1
fi

# Serve the folder on localhost only (needed for full-screen keyboard lock + wake lock).
SERVER_PID=""
if ! (exec 3<>/dev/tcp/127.0.0.1/"$PORT") 2>/dev/null; then
  python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$DIR" >/dev/null 2>&1 &
  SERVER_PID=$!
  trap '[[ -n "$SERVER_PID" ]] && kill "$SERVER_PID" 2>/dev/null' EXIT
  for _ in $(seq 1 50); do
    (exec 3<>/dev/tcp/127.0.0.1/"$PORT") 2>/dev/null && break
    sleep 0.1
  done
fi

MODE=(--kiosk)
[[ "${1:-}" == "--window" ]] && MODE=(--app="$URL" --start-maximized)

# A separate profile means this window has no bookmarks, extensions, history or
# signed-in accounts, and closing it doesn't touch your normal browser.
"$BROWSER" \
  --user-data-dir="$PROFILE" \
  --no-first-run --no-default-browser-check \
  --disable-translate --disable-features=Translate,TranslateUI \
  --disable-pinch --overscroll-history-navigation=0 \
  --disable-session-crashed-bubble --hide-crash-restore-bubble \
  --noerrdialogs --disable-infobars \
  "${MODE[@]}" "$URL"
