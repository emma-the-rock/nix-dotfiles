{ pkgs, ... }:
{
  xdg.configFile = {
    "pipewire/pipewire.conf.d/10-discord.conf".source = ./pipewire/10-discord.conf;
    "pipewire/pipewire.conf.d/10-mic.conf".source = ./pipewire/10-mic.conf;
    "pipewire/pipewire.conf.d/10-misc.conf".source = ./pipewire/10-misc.conf;
    "pipewire/pipewire.conf.d/10-music.conf".source = ./pipewire/10-music.conf;
    "pipewire/pipewire.conf.d/10-vban-send.conf".source = ./pipewire/10-vban-send.conf;
  };
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
