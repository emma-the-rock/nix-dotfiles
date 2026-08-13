{
  imports = [
    ./git.nix
    ./shell.nix
  ];

  programs.home-manager.enable = true;
  programs.btop.enable = true;

  home.stateVersion = "25.11";
}
