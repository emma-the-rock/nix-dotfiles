{
  programs.fish.enable = true;
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    presets = [
      "pastel-powerline"
    ];
  };
}
