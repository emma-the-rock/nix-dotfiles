{ lib, ... }:

{
  # Lanzaboote reemplaza al systemd-boot estándar
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
