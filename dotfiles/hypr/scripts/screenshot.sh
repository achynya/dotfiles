#!/usr/bin/env bash

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

# --- Usage ---
usage() {
  echo "Usage: $0 [full|area] [--clipboard]"
  exit 1
}

# --- Parse Arguments ---
MODE="$1"
CLIPBOARD=0
if [ -z "$MODE" ]; then
  usage
fi

if [ "$2" = "--clipboard" ]; then
  CLIPBOARD=1
fi

case "$MODE" in
  full|area) ;;
  *) usage ;;
esac

# --- Get Next Filename for mode ---
get_next_filename() {
  PREFIX="$1"
  LAST_NUM=$(find "$SAVE_DIR" -type f -name "${PREFIX}[0-9]*.png" \
    | sed -E "s|.*/${PREFIX}([0-9]+)\.png|\1|" | sort -n | tail -n 1)

  if [ -z "$LAST_NUM" ]; then
    NEXT_NUM=1
  else
    NEXT_NUM=$((LAST_NUM + 1))
  fi

  echo "$SAVE_DIR/${PREFIX}${NEXT_NUM}.png"
}

FILENAME=$(get_next_filename "$MODE")

# --- Wayland Section ---
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  # Auto-detect monitor
  ACTIVE_OUTPUT=$(swaymsg -t get_outputs 2>/dev/null | jq -r '.[] | select(.focused==true).name')
  if [ -z "$ACTIVE_OUTPUT" ]; then
    ACTIVE_OUTPUT=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused==true).name')
  fi

  case "$MODE" in
    full)
      if [ -n "$ACTIVE_OUTPUT" ]; then
        grim -o "$ACTIVE_OUTPUT" "$FILENAME"
      else
        grim "$FILENAME"
      fi
      ;;
    area)
      grim -g "$(slurp)" "$FILENAME"
      ;;
  esac

  # Copy to clipboard if requested
  if [ "$CLIPBOARD" -eq 1 ]; then
    wl-copy < "$FILENAME"
    notify-send "Screenshot copied to clipboard" "$FILENAME"
    rm "$FILENAME"  # Optional: don't save to disk if clipboard-only
    exit 0
  fi

# --- X11 Section ---
else
  case "$MODE" in
    full)
      GEOMETRY=$(xrandr | grep -oP "^DP[^ ]+ connected.*?\K[0-9]+x[0-9]+\+[0-9]+\+[0-9]+")
      if [ -n "$GEOMETRY" ]; then
        scrot -a "$GEOMETRY" "$FILENAME"
      else
        scrot "$FILENAME"
      fi
      ;;
    area)
      scrot -s "$FILENAME"
      ;;
  esac

  # Clipboard on X11 (requires xclip or xsel)
  if [ "$CLIPBOARD" -eq 1 ]; then
    if command -v xclip >/dev/null 2>&1; then
      xclip -selection clipboard -t image/png -i "$FILENAME"
    elif command -v xsel >/dev/null 2>&1; then
      xsel --clipboard --input --mime-type=image/png < "$FILENAME"
    else
      notify-send "Clipboard failed" "xclip or xsel not found"
      exit 1
    fi
    notify-send "Screenshot copied to clipboard" "$FILENAME"
    rm "$FILENAME"
    exit 0
  fi
fi

# --- Final Notification ---
if [ -f "$FILENAME" ]; then
  notify-send "Screenshot saved" "$FILENAME"
else
  notify-send "Screenshot failed" "Could not create: $FILENAME"
fi
