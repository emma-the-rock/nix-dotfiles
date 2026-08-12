{ lib, pkgs, config, ... }:

let
  cfg = config.myUsers;

  adminOpts = { ... }: {
    options = {
      description = lib.mkOption {
        type = lib.types.str;
        description = "Human-readable description (full name) for this user.";
      };
      shell = lib.mkOption {
        type = lib.types.package;
        default = pkgs.bash;
        description = "Login shell package for this user.";
      };
      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Extra groups this user belongs to.";
      };
      authorizedKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "OpenSSH public keys authorized to log in as this user.";
      };
    };
  };

  serviceUserOpts = { ... }: {
    options = {
      description = lib.mkOption {
        type = lib.types.str;
        description = "Human-readable description for this service user.";
      };
      group = lib.mkOption {
        type = lib.types.str;
        description = "Primary group for this service user.";
      };
      createHome = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to create a home directory for this service user.";
      };
    };
  };
in
{
  options.myUsers = {
    admins = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule adminOpts);
      default = { };
      description = "Admin users with interactive shell access.";
    };

    serviceUsers = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule serviceUserOpts);
      default = { };
      description = "Service users without administrative privileges, used for things like file shares.";
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra system groups to create, beyond the ones implied by admins/serviceUsers.";
    };
  };

  config = {
    environment.localBinInPath = true;

    users.groups = lib.genAttrs cfg.extraGroups (_: { });

    users.users = lib.mapAttrs
      (_: admin: {
        isNormalUser = true;
        inherit (admin) description shell extraGroups;
        openssh.authorizedKeys.keys = admin.authorizedKeys;
      })
      cfg.admins
    // lib.mapAttrs
      (_: svc: {
        isSystemUser = true;
        inherit (svc) description group createHome;
      })
      cfg.serviceUsers;
  };
}
