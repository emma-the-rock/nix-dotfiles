{ pkgs, ... }:
{
  home.packages = [
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vkcapture
        obs-composite-blur
        obs-aitum-multistream
        obs-vertical-canvas
      ];
    })
  ];
}
