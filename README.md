# NixOS Configuration
 
Personal NixOS configuration for **miku-homelab**, built with Flakes and Home Manager.
 
## Features
 
- NixOS Flakes
- Home Manager integration
- KDE Plasma 6
- Secure Boot with Lanzaboote
- Steam and gaming configuration
- PipeWire audio stack with per-app routing (Discord, mic, music, VBAN send, misc)
- Docker / container services
- Flatpak support
- Deskflow (keyboard/mouse sharing across machines)
- nix-ld for running unpatched dynamic binaries
- VS Code Server
- Agent tooling configuration (AGENTS.md / agents.nix)
- Declarative user environment
## Repository Layout
 
```text
.
├── AGENTS.md
├── flake.nix
├── flake.lock
├── README.md
├── TODO.md
├── .gitignore
│
├── .vscode/
│   └── mcp.json
│
├── hosts/
│   └── miku-homelab/
│       ├── default.nix
│       └── hardware-configuration.nix
│
├── modules/
│   ├── desktop/
│   │   ├── firefox.nix
│   │   └── plasma.nix
│   │
│   ├── nixos/
│   │
│   ├── security/
│   │   └── secureboot.nix
│   │
│   ├── services/
│   │   ├── containers.nix
│   │   ├── flatpak.nix
│   │   ├── maintenance.nix
│   │   └── vscode-server.nix
│   │
│   └── system/
│       ├── audio.nix
│       ├── fonts.nix
│       ├── gaming.nix
│       ├── graphics.nix
│       ├── networking.nix
│       ├── nix-ld.nix
│       ├── packages.nix
│       ├── shells.nix
│       └── users.nix
│
└── home/
    └── emmatherock/
        ├── home.nix
        ├── agents.nix
        ├── audio.nix
        ├── deskflow.nix
        ├── desktop-apps.nix
        ├── gaming.nix
        ├── git.nix
        ├── media.nix
        ├── packages.nix
        ├── shell.nix
        ├── vscode.nix
        └── pipewire/
            ├── 10-discord.conf
            ├── 10-mic.conf
            ├── 10-misc.conf
            ├── 10-music.conf
            └── 10-vban-send.conf
```
 
## Applying Configuration
 
Test a configuration without switching:
 
```bash
sudo nixos-rebuild test --flake .#miku-homelab
```
 
Apply permanently:
 
```bash
sudo nixos-rebuild switch --flake .#miku-homelab
```
 
Update flake inputs:
 
```bash
nix flake update
```
 
## Home Manager
 
Home Manager is integrated as a NixOS module.
 
User configuration is located in:
 
```text
home/emmatherock/
```
 
Desktop applications, development tools, gaming utilities, shell configuration, editor configuration, per-app PipeWire routing, and Deskflow are managed there.
 
## Design Principles
 
- System configuration lives under `modules/system`.
- Desktop-specific configuration lives under `modules/desktop`.
- User applications and preferences belong in Home Manager whenever possible.
- Drivers, hardware, networking, audio services, and boot configuration remain managed by NixOS.
- Each module should have a single responsibility.
- Changes should be incremental and easy to review.
## Rebuilding
 
After modifying the configuration:
 
```bash
sudo nixos-rebuild test --flake .#miku-homelab
```
 
If everything works:
 
```bash
sudo nixos-rebuild switch --flake .#miku-homelab
```
 
## License
 
This repository is provided as-is for personal use and reference.