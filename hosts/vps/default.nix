{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/profiles/server.nix
  ];

  # PLACEHOLDER: secrets/vps-wg.age does not exist yet. It has to be created
  # (same way as secrets/miku-homelab-wg.age) once this host is installed and
  # its own WireGuard private key has been generated.
  age.secrets.vps-wg.file = ../../secrets/vps-wg.age;

  myNetworking = {
    hostName = "vps";
    useNetworkManager = false;
    staticIp = {
      interface = "eth0";
      address = "23.175.41.196";
      prefixLength = 27;
      gateway = "23.175.41.225";
      nameservers = [ "1.1.1.1" "1.0.0.1" ];
    };
    extraTcpPorts = [ 80 443 ];
    extraUdpPorts = [ 51822 ];
    sshAllowUsers = [ "emmatherock" ];
    wireguard = {
      enable = true;
      ips = [ "10.20.0.1/24" ];
      privateKeyFile = config.age.secrets.vps-wg.path;
      listenPort = 51822;
      peers = [
        {
          publicKey = "bqxDHQNxOSFpTo3We9ujC2WljtaRBgiNEewW+Rlu10k=";
          allowedIPs = [ "10.20.0.2/32" ];
        }
      ];
    };
  };

  myUsers = {
    admins.emmatherock = {
      description = "EmmaTheRock";
      extraGroups = [ "wheel" ];
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8vfwM5g9RJXqHtqTgNqsYg9SxSm+UMvFqTjBoAsLJ6 emmatherock@MAIN-PC"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpTslcK0yQ6k+h8foNl17wVRyJUfEGzq7f1h3014WNB s21 plus"
      ];
    };
  };

  myContainers = {
    enable = true;
    composeStacks.core = {
      path = "/opt/containers/core";
      after = [ "network-online.target" ];
    };
  };

  # PLACEHOLDER: adjust once the real VPS image/provider is known (BIOS vs
  # UEFI, actual boot device). Assumes a generic BIOS-booted image for now.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
