{ pkgs, ... }: 
{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    docker = {
      enable = true;
      storageDriver = "btrfs";
      daemon.settings = {
      dns = [ "1.1.1.1" "8.8.8.8" ];
      };
    };
  };

 systemd.services = {
  init-docker-networks = {
    description = "Crear redes globales de Docker si no existen";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.docker}/bin/docker network inspect homelab_net >/dev/null 2>&1 || ${pkgs.docker}/bin/docker network create homelab_net'";
    };
  };
  docker-compose-tools = {
    description = "Stack de Docker Compose: Tools";
    after = [ "docker.service" "network-online.target" "tailscaled.service" ];
    wants = [ "docker.service" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/mnt/containers/tools";
      ExecStart = "${pkgs.docker}/bin/docker compose up -d --remove-orphans";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
    };
  };
  docker-compose-arrs = {
    description = "Stack de Docker Compose: Arrs";
    after = [ "docker.service" "docker-compose-tools.service" "local-fs.target" ];
    wants = [ "docker.service" "docker-compose-tools.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/mnt/containers/arrs";
      ExecStart = "${pkgs.docker}/bin/docker compose up -d --remove-orphans";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
    };
  };
  docker-compose-gameservers = {
    description = "Stack de Docker Compose: Gameservers";
    after = [ "docker.service" "docker-compose-tools.service" ];
    wants = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/mnt/containers/gameserver";
      ExecStart = "${pkgs.docker}/bin/docker compose up -d --remove-orphans";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
    };
  };
 };
}
