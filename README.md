# NixOS Configuration

Personal NixOS configuration for **miku-homelab**, built with Flakes and Home Manager.

## Features

- NixOS Flakes
- Home Manager integration
- KDE Plasma 6
- Secure Boot with Lanzaboote
- Steam and gaming configuration
- PipeWire audio stack
- Docker / container services
- VS Code Server
- Declarative user environment

## Repository Layout

```text
.
├── flake.nix
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
│   ├── security/
│   │   └── secureboot.nix
│   │
│   ├── services/
│   │   ├── containers.nix
│   │   ├── maintenance.nix
│   │   └── vscode-server.nix
│   │
│   └── system/
│       ├── audio.nix
│       ├── fonts.nix
│       ├── gaming.nix
│       ├── graphics.nix
│       ├── networking.nix
│       ├── packages.nix
│       ├── shells.nix
│       └── users.nix
│
└── home/
    └── emmatherock/
        ├── home.nix
        ├── packages.nix
        ├── git.nix
        ├── shell.nix
        ├── vscode.nix
        ├── obs.nix
        ├── gaming.nix
        ├── media.nix
        └── desktop-apps.nix
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

Desktop applications, development tools, gaming utilities, shell configuration, and editor configuration are managed there.

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