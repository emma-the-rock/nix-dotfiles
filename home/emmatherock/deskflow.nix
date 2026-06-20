{ pkgs, ... }:

{
  home.packages = with pkgs; [
    deskflow
  ];

  systemd.user.services.deskflow = {
    Unit = {
      Description = "Deskflow Client Daemon";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Environment = "DISPLAY=:0";
      ExecStart = "${pkgs.deskflow}/bin/deskflow-core client miku-homelab.ts.emmatherock.online";
      Restart = "always";
      RestartSec = 3;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}