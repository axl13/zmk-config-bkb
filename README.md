## Layout for [BastardKB](https://bastardkb.com) boards (and other 3x5+2)

The layout has coverage of near 100% of all the keys present on a standard 100% ANSI keyboard in the span of 6 layers and 4 thumb keys - the main exceptions being AltGr, RCtrl, RGui - without using Layer Taps or Mod Taps except on the NumPad Layer. This is done by using Tri Layers and thumb combos.

The base layer is [Aptmak](https://github.com/Apsu/aptmak), with V, Q, and Z, on combos as an adaptation to allow support on 30 key (23332) layouts like [Hummingbird](https://github.com/PJE66/hummingbird), [Batreeq](https://github.com/AlaaSaadAbdo/battoota#batreeq), [Rommana](https://github.com/AlaaSaadAbdo/Rommana), or [Luna](https://github.com/mindhatch/keyboards#%E3%83%AB%E3%83%8A-luna), with minimal modifications.

## Keymap (generated with Caksoylar's [keymap-drawer](https://github.com/caksoylar/keymap-drawer))

### [34 key (3x5+2)](./assets/split34_keymap_zmk.yaml)
![34 key layout (generated with Caksoylar's keymap-drawer)](./assets/split34_keymap_zmk.svg)

### [30 key (23332+2)](./assets/split30_keymap.yaml)
![30 key layout (generated with Caksoylar's keymap-drawer)](./assets/split30_keymap.svg)

## Skeletyl Studio

The Skeletyl build enables ZMK Studio over USB on the left half. Connect the left
Nice!Nano to the computer and open [zmk.studio](https://zmk.studio/) in Chrome or
Edge. To unlock editing, hold the Function layer key and press the key at the
left-hand F position (it sends F20 on the right half). Studio can change key
bindings and includes one reserved `Extra` layer for experimentation.

The `P` key is a plain `P` press; it no longer sends apostrophe on a double tap.

Studio saves runtime keymap changes in the keyboard's settings. Once you start
using Studio, changes to the `.keymap` source will not replace those saved
bindings unless you choose **Restore Stock Settings** in Studio.
