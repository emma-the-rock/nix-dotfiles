{ ... }:

{
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  services.journald.extraConfig = "SystemMaxUse=500M";
}
