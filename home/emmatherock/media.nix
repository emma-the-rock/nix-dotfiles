{ pkgs, ... }:
{
  home.packages = with pkgs; [
    spotify
    cider-2
    haruna
    vlc
    carla
    qpwgraph
  ];
}
