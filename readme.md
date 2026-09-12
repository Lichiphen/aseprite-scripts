<div align="center">

<h1>Aseprite Scripts</h1>
<p><strong>A maintained fork with enhanced PSD and PNG export workflows</strong></p>
<p>
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-6e9bd2.svg"></a>
  <a href="psd/readme.md"><img alt="PSD Exporters" src="https://img.shields.io/badge/PSD-3%20Exporters-b07ac4.svg"></a>
  <a href="https://x.com/Lichiphen"><img alt="Maintainer: Lichiphen" src="https://img.shields.io/badge/Maintainer-Lichiphen-63b7af.svg"></a>
</p>
<p>
  <a href="psd/readme.md">PSD Exporters</a> ·
  <a href="#installation">Installation</a> ·
  <a href="#fork-changelog">Fork Changelog</a> ·
  <a href="#contact">Contact</a>
</p>

</div>

> [!NOTE]
> This fork preserves the original work from [Tsukina-7mochi/aseprite-scripts](https://github.com/Tsukina-7mochi/aseprite-scripts) and adds two clearly named PSD exporter variants maintained by Lichiphen.

## Featured: PSD Exporters

The modified exporters preserve Unicode layer names for CLIP STUDIO PAINT, handle Aseprite files edited with Pixquare more safely, and export frames as separately numbered PSD files.

| Version | Best for | Main behavior |
| --- | --- | --- |
| Original Export as PSD | Keeping the upstream workflow | Original behavior, preserved unchanged |
| All Frames — Numbered PSD | Exporting an entire animation | Writes every frame as a numbered PSD |
| Selected Frames — Numbered PSD | Exporting only chosen frames | Checkbox selection and automatic duplicate suffixes |

### [Open the PSD guide, downloads, usage, and credits →](psd/readme.md)

## Selected Frames — Numbered PNG

Export checked frames as individual transparent PNGs. All frames start checked; uncheck any to omit them. Includes Select All, Clear All, original frame numbering, and duplicate filename protection.

[Download and usage guide](png/readme.md)

## Other Scripts

- [Export as ico, cur, ani](icon-and-cursor): Export Windows icons and static or animated cursors.
- [LCD Pixel Filter](lcd-pixel-filter/readme.md): Apply an LCD-style pixel effect.
- [Smooth Filter](smooth-filter/readme.md): Apply a smoothing filter.

## Installation

Aseprite scripts are distributed as `.lua` files.

1. In Aseprite, open `File` → `Scripts` → `Open Scripts Folder`.
2. Place the downloaded `.lua` file in that folder.
3. Reload the scripts folder or restart Aseprite.
4. Open the script from `File` → `Scripts`.

The three PSD exporters have different filenames, so they can be installed side by side.

## Fork Changelog

### 2026-09-12 — Selected PNG export

- Added a standalone PNG exporter using the selected-frame PSD checkbox workflow.
- Added real Aseprite rendering tests and a download/usage guide.

### 2026-08-31 — Public fork release

- Published the original PSD exporter and two modified variants side by side.
- Added direct downloads, variant descriptions, credits, and license notices to the [PSD guide](psd/readme.md).
- Added separate support contacts for the modified variants and the original project.

### Base compatibility changes

- Added Unicode layer-name data to prevent garbled names when PSD files are opened in CLIP STUDIO PAINT.
- Improved handling of reference layers, cel bounds, preview frames, and empty images for Aseprite files edited with Pixquare.
- Implemented these initial compatibility fixes with assistance from Claude Code.

### Numbered export changes

- Added an exporter that writes every frame as a separately numbered PSD.
- Added an exporter that writes only checked frames and avoids overwriting existing files.
- Implemented these export workflow changes with assistance from OpenAI Codex.

## Credits and License

The original project is Copyright © 2020 Tsukina-7mochi. Modifications are Copyright © 2026 Lichiphen.

All versions are distributed under the [MIT License](LICENSE). The original source, authorship, and license notices remain available in this fork.

## Contact

For the modified PSD exporter variants:

- [GitHub Issues](https://github.com/Lichiphen/aseprite-scripts/issues)
- X: [@Lichiphen](https://x.com/Lichiphen)

For the original project:

- [Upstream GitHub Issues](https://github.com/Tsukina-7mochi/aseprite-scripts/issues)
- X: [@Tsukina_7mochi](https://x.com/Tsukina_7mochi)

