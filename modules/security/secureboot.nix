{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot.loader.limine = {
    secureBoot = {
      enable = true;
    };
  };
}
