{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/profiles/desktop.nix
    ../../modules/profiles/server.nix
    ../../modules/services/samba.nix
    ../../modules/system/nix-ld.nix
    ../../modules/system/packages.nix
  ];

  age.secrets.miku-homelab-wg.file = ../../secrets/miku-homelab-wg.age;

  myPackages.extra = with pkgs; [
    rocmPackages.rocm-smi
    btrfs-progs
    distrobox
    steam-run
  ];

  myNetworking = {
    hostName = "miku-homelab";
    useNetworkManager = true;
    staticIp = {
      interface = "enp6s0";
      address = "10.1.1.21";
      prefixLength = 24;
      gateway = "10.1.1.1";
      nameservers = [ "1.1.1.1" "8.8.8.8" ];
    };
    extraUdpPorts = [ 80 443 4242 49983 24800 26900 60977 ];
    extraTcpPorts = [ 80 443 4242 49983 24800 26900 60977 ];
    sshAllowUsers = [ "emmatherock" ];
    wireguard = {
      enable = true;
      ips = [ "10.20.0.2/24" ];
      privateKeyFile = config.age.secrets.miku-homelab-wg.path;
      peers = [
        {
          publicKey = "BKs9VlsIEM1np6wHeVFL4NfbS1l69xnwins6Q12ByAM=";
          allowedIPs = [ "10.20.0.1/32" ];
          endpoint = "vps.external.mikufanclub.lat:51822";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  myUsers = {
    admins.emmatherock = {
      description = "EmmaTheRock";
      shell = pkgs.fish;
      extraGroups = [ "plugdev" "networkmanager" "wheel" "video" "mikushare-group" "render" ];
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8vfwM5g9RJXqHtqTgNqsYg9SxSm+UMvFqTjBoAsLJ6 emmatherock@MAIN-PC"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpTslcK0yQ6k+h8foNl17wVRyJUfEGzq7f1h3014WNB s21 plus"
      ];
    };
    serviceUsers.mikushare = {
      description = "Acceso remoto Mikufanclub";
      group = "mikushare-group";
      createHome = false;
    };
    extraGroups = [ "mikushare-group" "plugdev" ];
  };

  myContainers = {
    enable = true;
    storageDriver = "btrfs";
    globalNetwork = "homelab_net";
    composeStacks = {
      tools = {
        path = "/mnt/containers/tools";
        after = [ "network-online.target" "tailscaled.service" ];
      };
      arrs = {
        path = "/mnt/containers/arrs";
        after = [ "docker-compose-tools.service" "local-fs.target" ];
      };
      gameservers = {
        path = "/mnt/containers/gameserver";
        after = [ "docker-compose-tools.service" ];
      };
    };
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;
      limine = {
        enable = true;
        maxGenerations = 5;
      };
    };
    plymouth.enable = true;
    initrd.kernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "quiet" "splash" "boot.shell_on_fail" "loglevel=3" "iommu=pt" ];
  };

  time.timeZone = "America/Argentina/Buenos_Aires";
  i18n.defaultLocale = "es_AR.UTF-8";

  services.hardware.deepcool-digital-linux.enable = true;

  services.udev.extraRules = ''
    # Intel RAPL energy usage file
    ACTION=="add", SUBSYSTEM=="powercap", KERNEL=="intel-rapl:0", RUN+="${pkgs.coreutils}/bin/chmod 444 /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj"

    # DeepCool HID raw devices
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3633", MODE="0666"

    # CH510 MESH DIGITAL
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="34d3", ATTRS{idProduct}=="1100", MODE="0666"
    # Elgato 4K X (all speed modes)
    SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="009b", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="009c", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="009d", MODE="0666", GROUP="plugdev"

    # Elgato 4K S (all speed modes)
    SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="00af", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="00ae", MODE="0666", GROUP="plugdev"

    # nvtop
    SUBSYSTEM=="drm", KERNEL=="card*", SUBSYSTEMS=="pci", DRIVERS=="amdgpu", RUN+="/bin/sh -c 'chmod -R g+r /sys/class/drm/%k/device/'"
  '';

  systemd.services.tailscale-udp-gro = {
    description = "Configurar UDP GRO para Tailscale";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K enp6s0 rx-udp-gro-forwarding on rx-gro-list on";
      RemainAfterExit = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  system.stateVersion = "25.11";
}
