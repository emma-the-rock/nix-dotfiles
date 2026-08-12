{ lib, pkgs, config, ... }:

let
  cfg = config.myContainers;

  composeStackOpts = { ... }: {
    options = {
      path = lib.mkOption {
        type = lib.types.path;
        description = "Directory containing the docker-compose.yml for this stack.";
      };
      after = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Extra systemd units this stack's compose service should start after and want, beyond docker.service.";
      };
    };
  };

  mkComposeService = name: stack: {
    name = "docker-compose-${name}";
    value = {
      description = "Docker Compose stack: ${name}";
      after = [ "docker.service" ] ++ lib.optional (cfg.globalNetwork != null) "init-docker-networks.service" ++ stack.after;
      wants = [ "docker.service" ] ++ lib.optional (cfg.globalNetwork != null) "init-docker-networks.service" ++ stack.after;
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = stack.path;
        ExecStart = "${pkgs.docker}/bin/docker compose up -d --remove-orphans";
        ExecStop = "${pkgs.docker}/bin/docker compose down";
      };
    };
  };
in
{
  options.myContainers = {
    enable = lib.mkEnableOption "Docker/Podman container support and Docker Compose stacks";

    storageDriver = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "aufs" "btrfs" "devicemapper" "overlay" "overlay2" "zfs" ]);
      default = null;
      description = "Docker storage driver to use. Leave null to let Docker choose.";
    };

    globalNetwork = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Name of a shared Docker network to create on boot, for compose stacks to join. Leave null to skip.";
    };

    composeStacks = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule composeStackOpts);
      default = { };
      description = "Docker Compose stacks to run as systemd services, each producing a docker-compose-<name> unit.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      docker = {
        enable = true;
        storageDriver = cfg.storageDriver;
        daemon.settings = {
          dns = [ "1.1.1.1" "8.8.8.8" ];
        };
      };
    };

    systemd.services =
      lib.optionalAttrs (cfg.globalNetwork != null) {
        init-docker-networks = {
          description = "Create the ${cfg.globalNetwork} Docker network if it doesn't exist";
          after = [ "docker.service" ];
          requires = [ "docker.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.docker}/bin/docker network inspect ${cfg.globalNetwork} >/dev/null 2>&1 || ${pkgs.docker}/bin/docker network create ${cfg.globalNetwork}'";
          };
        };
      }
      // lib.mapAttrs' mkComposeService cfg.composeStacks;
  };
}
