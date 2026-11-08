#!/usr/bin/env bash
# Render the Skeletyl keymap diagram from config/skeletyl_v2.keymap.
#
# Outputs (all committed to the repo):
#   assets/skeletyl_v2_keymap.yaml   keymap-drawer intermediate
#   assets/skeletyl_v2_keymap.svg    shown in README
#   assets/skeletyl_v2_keymap.png    2x raster
#   assets/skeletyl_v2_keymap.pdf    printable, A4 portrait, one page
#
# Requirements: python3, and Google Chrome or Chromium (for PNG/PDF).
# keymap-drawer is installed into .venv on first run.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

KEYMAP=config/skeletyl_v2.keymap
CFG=assets/keymap_drawer_config.yaml
OUT=assets/skeletyl_v2_keymap
LAYOUT='{qmk_keyboard: bastardkb/skeletyl, layout_name: LAYOUT_split_3x5_3}'

# --- keymap-drawer -----------------------------------------------------------
if command -v keymap >/dev/null 2>&1; then
  KD=keymap
else
  if [ ! -x .venv/bin/keymap ]; then
    echo "Installing keymap-drawer into .venv ..."
    python3 -m venv .venv
    .venv/bin/pip install -q --disable-pip-version-check keymap-drawer
  fi
  KD=.venv/bin/keymap
fi

"$KD" -c "$CFG" parse -z "$KEYMAP" -o "$OUT.yaml"
python3 - "$OUT.yaml" "$LAYOUT" <<'EOF'
import re, sys
path, layout = sys.argv[1], sys.argv[2]
s = open(path).read()
s = re.sub(r"^layout: .*$", "layout: " + layout, s, count=1, flags=re.M)
open(path, "w").write(s)
EOF
"$KD" -c "$CFG" draw "$OUT.yaml" -o "$OUT.svg" 2> >(grep -v WARNING >&2)

# --- PNG + printable PDF via headless Chrome ---------------------------------
CHROME=""
for c in \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium" \
  google-chrome google-chrome-stable chromium chromium-browser; do
  if [ -x "$c" ] || command -v "$c" >/dev/null 2>&1; then CHROME="$c"; break; fi
done
if [ -z "$CHROME" ]; then
  echo "WARNING: Chrome/Chromium not found; only the SVG was regenerated." >&2
  exit 0
fi

read -r W H < <(python3 -c "import re;s=open('$OUT.svg').read(500);m=re.search(r'width=\"(\d+)\" height=\"(\d+)\"',s);print(m[1],m[2])")

"$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 \
  --window-size="$W,$H" --screenshot="$ROOT/$OUT.png" "file://$ROOT/$OUT.svg" 2>/dev/null

DATE="$(git log -1 --format=%cs -- "$KEYMAP" 2>/dev/null || date +%F)"
SHA="$(git log -1 --format=%h -- "$KEYMAP" 2>/dev/null || echo local)"
PRINT_HTML="$(mktemp -t skeletyl_print).html"
cat > "$PRINT_HTML" <<EOF
<!doctype html><html><head><meta charset="utf-8"><style>
  @page { size: A4 portrait; margin: 10mm; }
  html, body { margin: 0; background: #fff; }
  body { font: 9pt -apple-system, Helvetica, Arial, sans-serif; color: #444; }
  img { display: block; width: 100%; max-height: 265mm; object-fit: contain; }
  p { margin: 2mm 0 0; text-align: right; }
</style></head><body>
  <img src="file://$ROOT/$OUT.svg">
  <p>Keymap $SHA · $DATE</p>
</body></html>
EOF
"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$ROOT/$OUT.pdf" "file://$PRINT_HTML" 2>/dev/null
rm -f "$PRINT_HTML"

echo "Rendered: $OUT.{yaml,svg,png,pdf}"
