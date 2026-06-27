{ pkgs, lib, ... }:

let
  pipewireDir = ./pipewire;

  pipewireFiles =
    lib.filterAttrs
      (name: type: type == "regular" && lib.hasSuffix ".conf" name)
      (builtins.readDir pipewireDir);

  pipewireConfigFiles =
    lib.mapAttrs'
      (name: _:
        lib.nameValuePair
          "pipewire/pipewire.conf.d/${name}"
          { source = pipewireDir + "/${name}"; }
      )
      pipewireFiles;
in
{
  xdg.configFile = pipewireConfigFiles;

  systemd.user.services.carla = {
    Unit = {
      Description = "Carla Audio Host";
      After = [
        "pipewire.service"
        "pipewire-pulse.service"
      ];
    };

    Service = {
      Type = "simple";
      Environment = [
        "DISPLAY=:0"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
      ExecStart = "${pkgs.steam-run}/bin/steam-run ${pkgs.carla}/bin/carla --nogui /mnt/ssd/conf/patchbay.carxp";
      Restart = "always";
      RestartSec = 3;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
