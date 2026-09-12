# Selected Frames — Numbered PNG

[Download the Lua script](https://raw.githubusercontent.com/Lichiphen/aseprite-scripts/master/png/Export%20selected%20frames%20as%20numbered%20PNG.lua)

Exports each checked frame of the open Aseprite sprite as a separate PNG.
The checkbox workflow follows this fork's selected-frame PSD exporter.

## Usage

1. Download the Lua file and place it in Aseprite's `File > Scripts > Open Scripts Folder`.
2. Reload scripts or restart Aseprite.
3. Open your sprite and run `File > Scripts > Export selected frames as numbered PNG`.
4. Choose a base filename and output folder.
5. All frames start checked. Uncheck any frames to omit, or use `Select All` / `Clear All`.
6. Click `Export`.

For example, checking frames 1 and 3 with the base `walk.png` produces `walk_001.png` and `walk_003.png`. Original frame numbers are preserved. Existing files are preserved by adding `_2`, `_3`, etc.

Each PNG contains the rendered visible layers at the original canvas size, including transparency. PNGs are flattened images. Source layers, active frame, selection, and undo history are unchanged. Empty frames produce transparent PNGs. No checked frames or Cancel produces no output.

The script is standalone and can coexist with all PSD exporters. Tested with the installed Aseprite desktop build. For very long animations, the checkbox grid may exceed the available screen height; batch mode supports frame selection without the dialog.

## Batch mode

```sh
aseprite -b animation.aseprite --script-param filename=output/walk.png --script-param frames=1,3 --script "Export selected frames as numbered PNG.lua"
```

Omit `frames` (or use `frames=all`) to export every frame. The output directory must exist. Invalid frame lists stop before writing. An export failure reports the number of completed files; files already written are retained.

## Validation

Run from the repository root with a fresh, empty output folder:

```sh
aseprite -b --script-param root=. --script-param testout=path/to/empty-test-folder --script png/tests/export_test.lua
```

Tests use real Aseprite rendering and PNG encoding with a simulated dialog to exercise checkbox defaults, Select All, Clear All, individual deselection, Cancel, empty selections, invalid frame lists, duplicate filenames, RGBA pixels, canvas bounds, hidden layers, and source preservation. This does not replace a visual UI check.

Rendering uses Aseprite's [Image API](https://aseprite.org/api/image#imagedrawsprite).

## Credits

Checkbox workflow adapted from this fork's PSD exporter, based on work by Tsukina-7mochi. PNG exporter modifications Copyright (c) 2026 Lichiphen, implemented with OpenAI Codex assistance. Distributed under the repository's [MIT License](../LICENSE).
