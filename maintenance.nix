{ pkgs, ... }:

{
  # Optimización automática del storage (une archivos idénticos)
  nix.settings.auto-optimise-store = true;

  # Garbage Collector automático
  nix.gc = {
    automatic = true;
    dates = "weekly"; # Se ejecuta cada semana
    options = "--delete-older-than 14d"; # Borra lo que tenga más de 2 semanas
  };

  # Opcional: Limpieza de logs de Systemd para que no crezcan infinito
  services.journald.extraConfig = "SystemMaxUse=500M";
}
