{ config, pkgs, ... }: {
  networking = {
    hostName = "miku-homelab";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedUDPPorts = [ config.services.tailscale.port 4242 49983 24800 26900 ];
      allowedTCPPorts = [ 22 4242 49983 24800 26900 ];
    };
    useDHCP = false;
    interfaces.enp6s0.ipv4.addresses = [{
      address = "10.1.1.21";
      prefixLength = 24;
    }];
    defaultGateway = "10.1.1.1";
    
    # DNS rápidos para que la resolución de nombres sea instantánea
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowUsers = [ "emmatherock" ];
    };
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "vfs objects" = "acl_xattr";
        "map acl inherit" = "yes";
        "store dos attributes" = "yes";
      };
      mikufanclub = {
        path = "/mnt/data/mikufanclub";
        writable = "yes";
        "valid users" = "mikushare emmatherock";
        "force group" = "mikushare-group";
        "create mask" = "0660";
        "directory mask" = "0770";
      };
      data-private = {
        path = "/mnt/data";
        writable = "yes";
        "valid users" = "emmatherock";
        "browseable" = "yes";
      };
    };
  };

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
}
