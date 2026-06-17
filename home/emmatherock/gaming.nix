{ pkgs, ... }:
{
  home.packages = with pkgs; [
    faugus-launcher
    plezy
    protonplus
    protontricks
    proton-authenticator
    mangohud
    cemu
  ];
}
