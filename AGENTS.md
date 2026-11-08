# Agent instructions for zmk-config-bkb

ZMK config for BastardKB boards. The board in daily use is the **Skeletyl v2**
(`config/skeletyl_v2.keymap`), used as a travel keyboard by someone whose main
keyboard is a **Kinesis Advantage**. Other boards in `build.yaml` are legacy;
don't change them unless asked.

## Rule: every layout change ships with a fresh printable diagram

Whenever you change anything that affects what a key does, including

- `config/skeletyl_v2.keymap` (layers, combos, behaviors, hold-taps)
- `config/west.yml` modules that add behaviors used in the keymap
- `assets/keymap_drawer_config.yaml` (labels)

you **must**, in the same commit:

1. Run `scripts/draw_keymap.sh`. It regenerates
   `assets/skeletyl_v2_keymap.{yaml,svg,png,pdf}`; the PDF is the printable,
   one-page A4 version.
2. Open the PNG and check it: every layer present, combos drawn between the
   right keys, no raw ZMK names (e.g. `LBKT`, `&studio_unlock`) where a
   symbol is expected. If a raw name shows, add it to
   `assets/keymap_drawer_config.yaml` and re-run.
3. Update the combo table and any affected text in `README.md`.
4. Commit keymap, assets and README together, then push.
5. Check that the GitHub Actions build for that commit succeeds. Don't report
   the change as done before it does.

Never hand-edit the files in `assets/skeletyl_v2_keymap.*`; always regenerate.

## Design rules for this keymap (keep them when editing)

- **Kinesis muscle memory first.** Every symbol sits on the same finger and
  hand as on a Kinesis Advantage. Combos are placed where the Kinesis key is
  (e.g. `=` at Q+W = top-left corner, `\` at O+P = right of P).
- **Opposite-hand Shift.** Shifted characters come from holding Shift on the
  other hand (A for right-hand keys, `;` for left-hand keys). Combos send the
  unshifted key so this works.
- **Home-row mods are positional** (`bhm_l` / `bhm_r` with
  `hold-trigger-key-positions`): a mod only holds when the next key is on the
  other hand or a thumb.
- **Layers live on thumbs, never on letters.** Symbols = hold Esc or Tab,
  Function = hold Enter.
- **Combos:** two adjacent keys on the same row only. No vertical combos, no
  thumb+thumb on the same hand. Check the pair isn't a common bigram; if it
  is (e.g. `op`, `./`), add `require-prior-idle-ms = <150>`.
- Shifted number symbols sit directly above their digits on the Symbols layer.

Key positions (for `key-positions` / `hold-trigger-key-positions`):

```
 0  1  2  3  4      5  6  7  8  9
10 11 12 13 14     15 16 17 18 19
20 21 22 23 24     25 26 27 28 29
      30 31 32     33 34 35
```

## Practical notes

- The host is macOS with a US layout (`€` = Option+Shift+2).
- ZMK Studio is enabled on the left half. Keymaps saved in Studio override
  the compiled keymap until **Restore Stock Settings** (or the
  `settings_reset` firmware) is used. Remind the user when a change doesn't
  seem to take effect.
- Firmware artifacts come from the `build` workflow; the left half
  (`skeletyl_v2_left`) carries the keymap.
- Sentence case comes from the `zmk-sentence-case` module, pinned by commit
  in `config/west.yml`.
