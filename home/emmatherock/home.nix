{
  imports = [
    ./audio.nix
    ./desktop-apps.nix
    ./deskflow.nix
    ./gaming.nix
    ./git.nix
    ./media.nix
    ./obs.nix
    ./packages.nix
    ./shell.nix
    ./vscode.nix
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
