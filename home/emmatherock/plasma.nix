{ config, pkgs, ... }:
{
  home.packages = [ pkgs.bibata-cursors pkgs.breeze-enhanced ];
  
  programs.plasma = {
    enable = true;

    shortcuts = {

      # Atajos personalizados para scripts propios (net.local.*)
      "services/net.local.switch-obs-2.desktop"._launch = "F13";
      "services/net.local.switch-obs-3.desktop"._launch = "Meta+Ctrl+F8";
      "services/net.local.switch-obs-4.desktop"._launch = "Meta+Ctrl+F9";
      "services/net.local.switch-obs-5.desktop"._launch = "F15";
      "services/net.local.switch-obs-6.desktop"._launch = "Meta+Ctrl+F10";
      "services/net.local.switch-obs.desktop"._launch = "F14";
      "services/net.local.volctl-10.desktop"._launch = "F23";
      "services/net.local.volctl-11.desktop"._launch = "F20";
      "services/net.local.volctl-12.desktop"._launch = "F21";
      "services/net.local.volctl-7.desktop"._launch = "F18";
      "services/net.local.volctl-8.desktop"._launch = "F19";
      "services/net.local.volctl-9.desktop"._launch = "F22";
      "services/net.local.warudo-client-2.desktop"._launch = "F16";
      "services/net.local.warudo-client.desktop"._launch = "Meta+Ctrl+F7";
      "services/net.local.wpctl.desktop"._launch = "Alt+F18";
    };

    configFile = {

      kdeglobals.General.XftAntialias = true;
      kdeglobals.General.XftHintStyle = "hintslight";
      kdeglobals.General.XftSubPixel = "vbgr";
      kdeglobals.General.accentColorFromWallpaper = true;
      kdeglobals.General.fixed = "SFMono Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
      kdeglobals.General.font = "SF Pro,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
      kdeglobals.General.menuFont = "SF Pro,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
      kdeglobals.General.smallestReadableFont = "SF Pro,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
      kdeglobals.General.toolBarFont = "SF Pro,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
      kdeglobals.WM.activeBackground = "39,44,49";
      kdeglobals.WM.activeBlend = "252,252,252";
      kdeglobals.WM.activeFont = "SF Pro,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
      kdeglobals.WM.activeForeground = "252,252,252";
      kdeglobals.WM.inactiveBackground = "32,36,40";
      kdeglobals.WM.inactiveBlend = "161,169,177";
      kdeglobals.WM.inactiveForeground = "161,169,177";

      kiorc.Confirmations.ConfirmDelete = true;

      # Wallpaper del lockscreen: reemplazá esta ruta o usá config.home.homeDirectory
      kscreenlockerrc."Greeter/Wallpaper/org.kde.image/General".Image = "${config.home.homeDirectory}/Imágenes/image.png";
      kscreenlockerrc."Greeter/Wallpaper/org.kde.image/General".PreviewImage = "${config.home.homeDirectory}/Imágenes/image.png";

      kwinrc.Windows.PerOutputVirtualDesktops = true;
      kwinrc.Xwayland.Scale = 1;
      kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "XIA";
      kwinrc."org.kde.kdecoration2".ButtonsOnRight = "SHME";
      kwinrc."org.kde.kdecoration2".theme = "BreezeEnhanced";

      kxkbrc.Layout.Options = "fkeys:basic_13-24";
      kxkbrc.Layout.ResetOldOptions = true;

      plasma-localerc.Formats.LANG = "es_AR.UTF-8";
    };

    window-rules = [
      {
        description = "Warudo Editor";
        match = {
          window-class = "steam_app_2079120";
          title = { value = "Warudo Editor"; type = "substring"; };
          machine = "localhost";
          window-types = [ "normal" ];
        };
        apply = {
          maximizehoriz = true;
          maximizevert = true;
        };
      }
      {
        description = "Warudo (cualquier versión)";
        match = {
          window-class = "steam_app_2079120";
          title = { value = "^Warudo [0-9]+\\.[0-9]+\\.[0-9]+$"; type = "regex"; };
        };
        apply = {
          fullscreen = true;
        };
      }
    ];
  };

  # .desktop entries para los scripts que llaman los shortcuts de arriba.
  # rc2nix no captura esto — sin esto, los atajos no van a encontrar nada que ejecutar.
  xdg.desktopEntries = {
    "net.local.switch-obs" = {
      name = "Overlay Scene 1";
      exec = ''switch-obs "Overlay Scene 1"'';
      type = "Application";
    };
    "net.local.switch-obs-2" = {
      name = "Game Scene - Left";
      exec = ''switch-obs "Game Scene - Left"'';
      type = "Application";
    };
    "net.local.switch-obs-3" = {
      name = "Game Scene - Right";
      exec = ''switch-obs "Game Scene - Right"'';
      type = "Application";
    };
    "net.local.switch-obs-4" = {
      name = "Overlay Scene 2";
      exec = ''switch-obs "Overlay Scene 2"'';
      type = "Application";
    };
    "net.local.switch-obs-5" = {
      name = "Brb Scene";
      exec = ''switch-obs "Brb Scene"'';
      type = "Application";
    };
    "net.local.switch-obs-6" = {
      name = "Chatting Scene";
      exec = ''switch-obs "Chatting Scene"'';
      type = "Application";
    };

    "net.local.volctl-7" = {
      name = "music-chain -1";
      exec = "volctl music-chain -1";
      type = "Application";
    };
    "net.local.volctl-8" = {
      name = "music-chain +1";
      exec = "volctl music-chain +1";
      type = "Application";
    };
    "net.local.volctl-9" = {
      name = "discord-chain -1";
      exec = "volctl discord-chain -1";
      type = "Application";
    };
    "net.local.volctl-10" = {
      name = "discord-chain +1";
      exec = "volctl discord-chain +1";
      type = "Application";
    };
    "net.local.volctl-11" = {
      name = "misc-chain -1";
      exec = "volctl misc-chain -1";
      type = "Application";
    };
    "net.local.volctl-12" = {
      name = "misc-chain +1";
      exec = "volctl misc-chain +1";
      type = "Application";
    };

    "net.local.warudo-client" = {
      name = "Warudo: lolping";
      exec = "warudo-client --action lolping";
      type = "Application";
    };
    "net.local.warudo-client-2" = {
      name = "Warudo: calibrate";
      exec = "warudo-client --action calibrate";
      type = "Application";
    };

    "net.local.wpctl" = {
      name = "Mic Toggle";
      exec = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      type = "Application";
    };
  };

}
