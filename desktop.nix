{pkgs, apple-fonts, vscode-server, inputs, ... }: 
{
  hardware.graphics = {
  enable = true;
  enable32Bit = true;
  extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    plasma-login-manager.enable = true;
    sddm = { enable = true; wayland.enable = true; };
    autoLogin = { enable = true; user = "emmatherock"; };
  };
  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.login.enableKwallet = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.vscode-server.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts noto-fonts-cjk-sans noto-fonts-color-emoji
    nerd-fonts.fira-code nerd-fonts.jetbrains-mono
    apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro
    apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-mono
    apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.ny
  ];

  environment.systemPackages = with pkgs; [
    # --- Base y Terminal ---
    vim
    git
    wget
    curl
    fastfetch
    (btop.override { cudaSupport = false; rocmSupport = true; })
    nvtopPackages.full
    ethtool
    zsh
    fish
    starship
    gemini-cli
    rocmPackages.rocm-smi

    # --- Herramientas de Sistema ---
    btrfs-progs
    kdePackages.partitionmanager
    kdePackages.kalk
    tailscale
    distrobox
    steam-run
    localsend
    inputs.lan-mouse.packages.${pkgs.stdenv.hostPlatform.system}.default
    deskflow
      
    # --- Trabajo y Notas ---
    (vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      jnoortheen.nix-ide
      ms-python.python
      vscode-extensions.ms-dotnettools.csharp
      vscode-extensions.ms-vscode.cpptools
      vscode-extensions.golang.go
      vscode-extensions.rust-lang.rust-analyzer
      vscode-extensions.Google.gemini-cli-vscode-ide-companion
      vscode-extensions.ms-azuretools.vscode-containers
      ms-vscode-remote.remote-ssh
      vscode-extensions.coolbear.systemd-unit-file
      ];
    })
    obsidian

    # --- Multimedia y Comunicación ---
    (discord.override {
      # withOpenASAR = true; # can do this here too
      withVencord = true;
    })
    spotify
    chatterino7
    plex-desktop
    cider-2
    inputs.sidra.packages.${pkgs.stdenv.hostPlatform.system}.default
    telegram-desktop

    # --- Audio y Video ---
    carla
    haruna
    qpwgraph
    pipewire
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vkcapture
        obs-composite-blur
        obs-aitum-multistream
        obs-vertical-canvas
      ];
    })
    vlc

    # --- Gaming ---
    faugus-launcher
    plezy
    protonplus
    protontricks
    proton-authenticator
    mangohud
    gamemode
    cemu
  ];

  programs = {
    firefox.enable = true;
    fish.enable = true;
    starship.enable = true;
    steam = { enable = true; remotePlay.openFirewall = true; };
  };
}
