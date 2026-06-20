{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obsidian
    (discord.override {
      # withOpenASAR = true; # can do this here too
      withVencord = true;
    })
    chatterino7
    telegram-desktop
    localsend
    kdePackages.kalk
    kdePackages.partitionmanager
  ];
}
