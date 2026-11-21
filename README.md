# Alnix

My whole NixOS config: a [flake-parts](https://flake.parts) flake in the
_dendritic_ style, running [niri](https://github.com/YaLTeR/niri) with the
[Noctalia](https://noctalia.dev) shell. If anyone asks for my "dotfiles", this
is it.

## Try it out

The full system (`hpLaptop`) is tied to my hardware: disk UUIDs, LUKS and
`hardware-configuration.nix`, so don't `nixos-rebuild` it on your machine. The
desktop itself is packaged separately and runs anywhere with Nix and flakes
enabled.

**Run the desktop nested in your current session.** Started from inside another
Wayland session, niri opens as a normal window:

```sh
nix run github:<owner>/Alnix#alexNiri
```

Noctalia starts automatically inside it (it's in niri's `spawn-at-startup`).
Press `Mod+Shift+/` for the hotkey overview. `Mod` is Super, or Alt when niri is
running nested as a window. `Mod+Return` opens kitty, and `Mod+D` opens the
launcher.

**Run just the shell** inside your own niri, Hyprland or Sway:

```sh
nix run github:<owner>/Alnix#alexNoctalia
```

**Borrow a feature in your own flake.** Every feature is exported as a NixOS
module:

```nix
inputs.alnix.url = "github:<owner>/Alnix";
# ...
modules = [ inputs.alnix.nixosModules.niri inputs.alnix.nixosModules.pipewire ];
```

`nixosModules.home` is configured for user `alexm`, so use it as a reference
rather than importing it directly.

## Layout

```
flake.nix            # inputs + mkFlake; loads ./modules with import-tree
modules/
├── systems.nix      # systems = [ "x86_64-linux" ]
├── hosts/
│   └── hp-laptop/   # hardware, boot, hostname, and which features this host uses
└── features/
    ├── niri.nix     # wrapped niri (alexNiri) + nixosModules.niri
    ├── noctalia.nix # wrapped Noctalia (alexNoctalia), settings from noctalia.toml
    ├── pipewire.nix # audio; sink priority HDMI > Bluetooth > speakers
    ├── packages.nix # system packages
    ├── home.nix     # home-manager setup (useGlobalPkgs, useUserPackages)
    ├── git.nix, kitty.nix, xdg.nix, ...   # home-manager features
    └── nvim/        # nvf-based Neovim; _hm/ holds plain home-manager modules
```

**How it fits together:** `import-tree` loads every `.nix` file under `modules/`
as a flake-parts module, so nothing is imported by hand. Each feature adds to a
named `flake.nixosModules.<name>`. Files that use the same name are merged,
which is how all the home-manager features end up in `nixosModules.home`. A host
lists the module names it wants. Paths with a component starting with `_` are
skipped by import-tree. Use that for files that aren't flake-parts modules (e.g.
`hardware-configuration.nix`, home-manager modules).

**Wrapped programs:** niri and Noctalia are built with
[nix-wrapper-modules](https://github.com/nix-community/nix-wrapper-modules), so
their configs are generated from Nix and live in the store. Nothing is written
to `~/.config/niri`.

## Theming

Noctalia's palette (wallpaper-generated or a chosen scheme) is pushed to:

- **kitty**, via Noctalia's built-in template. `kitty.conf` includes
  `themes/noctalia.conf`.
- **niri**, via the built-in template. The generated niri config includes
  `~/.config/niri/noctalia.kdl` (an optional include; needs niri ≥ 26.04).
- **Neovim**, via a user template (`nvim-base16.lua`) rendered to
  `~/.cache/noctalia/`, applied with base16-nvim. `:ThemeToggle` (`<leader>tt`)
  switches between it and moonfly.

Running kitty and nvim instances recolor live when the theme changes.

## Credits

Big thanks to my friend Josh Niemela for lending me his
[neovim config](https://git.argmin.dk/joshnie/.dotfiles/src/branch/main/home-manager/nvim).
The entire _nvim directory was from him. I have since added a few features
(theming) and keybinds.

## Gotchas

- **Restart Noctalia after a rebuild** that changes its settings. The running
  instance keeps its old config. `Mod+Shift+N` restarts it.
- **New files need `git add`** before the flake can see them.
- **Use one nixpkgs everywhere.** Inputs `follows` the root nixpkgs, and
  home-manager uses `useGlobalPkgs`. Mixing package sets breaks GL and
  fontconfig at runtime.
