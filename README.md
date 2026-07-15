# st (personal build)

A patched build of [suckless st](https://st.suckless.org/) 0.9.3, themed with
Tokyo Night and JetBrainsMono Nerd Font to match my Alacritty setup. st is a
lightweight terminal emulator for X. It has no runtime configuration file; its
behaviour is compiled in from `config.h`.

## Features

On top of stock st, this build applies these patches:

| Patch | What it adds |
|-------|--------------|
| **scrollback** (+ mouse, + altscreen) | 10,000-line history buffer. Scroll with the bare mouse wheel or `Shift+PageUp`/`PageDown`. |
| **ligatures** | Programming ligatures via HarfBuzz (`->`, `=>`, `!=`, `>=`, `===`, and so on). |
| **boxdraw** | Box-drawing and Braille glyphs drawn by st itself, so TUI borders line up without gaps (btop, lazygit, tmux). |
| **alpha** | Background transparency (`alpha = 0.95`; needs a running compositor). |
| **undercurl** | Colored and curly underlines for editor diagnostics and spellcheck. |
| **font2** | Fallback fonts for glyphs the main font lacks (Noto Color Emoji, Noto Sans CJK). |
| **anysize** | Resizes to any pixel size, so no empty border gap when tiled or maximized. |
| **a desktop entry** | Installs `st.desktop` so st shows up in your application launcher. |

Appearance: Tokyo Night palette, `JetBrainsMono Nerd Font` at point size 15, 6px
padding, and a default size of 100x30.

## Keybindings

### Scrolling
| Key or gesture | Action |
|----------------|--------|
| Mouse wheel | Scroll history on the normal screen; passed to the program on the alt screen |
| `Shift`+`PageUp` / `PageDown` | Scroll history by about a page |

### General
| Key | Action |
|-----|--------|
| `Ctrl`+`Shift`+`C` / `V` | Copy or paste clipboard |
| `Shift`+`Insert` | Paste primary selection |
| Middle click | Paste primary selection |
| `Ctrl`+`Shift`+`Y` | Paste primary selection |
| `Ctrl`+`Shift`+`PageUp` / `PageDown` | Increase or decrease font size |
| `Ctrl`+`Shift`+`Home` | Reset font size |
| `Ctrl`+`Shift`+`Num_Lock` | Toggle numlock (application keypad) |

Hold `Alt` while dragging to select rectangular text.

## Requirements

- Xlib headers (`libx11-dev`), `libxft-dev`
- `fontconfig`, `freetype2`
- `harfbuzz` for ligatures (`libharfbuzz-dev`)
- A compositor such as `picom` for background transparency
- **JetBrainsMono Nerd Font** installed
  ([download](https://www.nerdfonts.com/font-downloads)), or change the `font`
  line in `config.h`

On Debian, Fedora, Arch, or openSUSE you can install the build dependencies with
the bundled script:

```sh
./install-deps.sh
```

It detects the package manager and installs everything except the font.

## Build and install

```sh
make                # build ./st in place
sudo make install   # install to /usr/local (binary, man page, terminfo, .desktop)
```

`make install` also compiles the terminfo entry, which carries the undercurl
capability that the system's stock `st-256color` does not have.

If you run `./st` without installing, register the terminfo entry once so
programs recognise `TERM=st-256color`:

```sh
tic -sx st.info
```

## Configuration

All configuration lives in `config.h`: theme, font, geometry, and keybindings.
`config.def.h` holds the patched upstream defaults, and `config.h` is where my
changes live. Rebuild with `make` after editing `config.h`. To start over from
the patched defaults, run `rm config.h && make`.

## Notes

Transparency only shows when a compositor is running. Without one, the
background is opaque.

The terminal supports undercurl, but applications have to emit it. In Neovim,
enable undercurl in your terminal or colorscheme setup.

Scrollback uses a fixed ring buffer, so lines are clipped rather than reflowed
when the window is resized. The buffer size is set by `HISTSIZE` in `st.c`.

## Credits

- <https://st.suckless.org>
- <https://st.suckless.org/patches>
- <https://github.com/folke/tokyonight.nvim>

