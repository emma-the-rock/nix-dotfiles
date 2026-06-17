{ pkgs, ... }: {
  environment.localBinInPath = true;

  users.groups.mikushare-group = {};
  
  users.groups.plugdev = {};

  users.users.emmatherock = {
    isNormalUser = true;
    description = "EmmaTheRock";
    shell = pkgs.fish;
    extraGroups = [ "plugdev" "networkmanager" "wheel" "video" "mikushare-group" "render" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8vfwM5g9RJXqHtqTgNqsYg9SxSm+UMvFqTjBoAsLJ6 emmatherock@MAIN-PC"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpTslcK0yQ6k+h8foNl17wVRyJUfEGzq7f1h3014WNB s21 plus"
    ];
  };

  users.users.mikushare = {
    isNormalUser = true;
    description = "Acceso remoto Mikufanclub";
    group = "mikushare-group";
    createHome = false;
  };
}
