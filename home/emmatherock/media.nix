{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    spotify
    cider-2
    haruna
    vlc
    carla
    qpwgraph
    inputs.sidra.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
