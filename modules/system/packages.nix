{ lib, pkgs, config, ... }:

let
  cfg = config.myPackages;
in
{
  options.myPackages = {
    extra = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra packages to install on this host, beyond the core set.";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      git
      wget
      curl
      ethtool
      fish
      tmux
    ] ++ cfg.extra;
  };
}
