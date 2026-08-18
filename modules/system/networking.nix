{ config, lib, ... }:

let
  cfg = config.myNetworking;

  wireguardPeerOpts = { ... }: {
    options = {
      publicKey = lib.mkOption {
        type = lib.types.str;
        description = "Public key of the remote WireGuard peer.";
      };
      allowedIPs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "IP ranges routed through this peer.";
      };
      endpoint = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Endpoint (host:port) of the remote peer, if it has a stable address.";
      };
      persistentKeepalive = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Interval in seconds for sending keepalive packets to this peer.";
      };
    };
  };
in
{
  options.myNetworking = {
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The system hostname.";
    };

    useNetworkManager = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable NetworkManager to manage network interfaces.";
    };

    useNetworkd = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to configure the static IP via systemd-networkd instead of the classic scripted networking backend. Needed for reliable onlink default routes.";
    };

    staticIp = lib.mkOption {
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          interface = lib.mkOption {
            type = lib.types.str;
            description = "Network interface to assign the static address to.";
          };
          address = lib.mkOption {
            type = lib.types.str;
            description = "Static IPv4 address for the interface.";
          };
          prefixLength = lib.mkOption {
            type = lib.types.int;
            description = "IPv4 prefix length for the static address.";
          };
          gateway = lib.mkOption {
            type = lib.types.str;
            description = "Default gateway address.";
          };
          nameservers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "1.1.1.1" "8.8.8.8" ];
            description = "DNS nameservers to use.";
          };
          onlinkGateway = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether the gateway lies outside the interface's subnet, requiring the onlink flag on the default route.";
          };
        };
      });
      default = null;
      description = "Static IPv4 configuration for this host. Leave null to rely on DHCP or NetworkManager.";
    };

    extraUdpPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [ ];
      description = "Additional UDP ports to open in the firewall, beyond the Tailscale port.";
    };

    extraTcpPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [ ];
      description = "Additional TCP ports to open in the firewall, beyond SSH.";
    };

    sshAllowUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Usernames allowed to log in over SSH. Empty means no restriction is applied.";
    };

    wireguard = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure a WireGuard interface named wg-<hostName> on this host.";
      };
      ips = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "IP addresses (with prefix length) assigned to the local WireGuard interface.";
      };
      privateKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Path to the file containing this host's WireGuard private key.";
      };
      listenPort = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = null;
        description = "UDP port for the WireGuard interface to listen on. Leave null to auto-select, which is fine for hosts that only initiate connections outward.";
      };
      peers = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule wireguardPeerOpts);
        default = [ ];
        description = "WireGuard peers this host connects to.";
      };
    };
  };

  config = lib.mkMerge [
    {
      networking = lib.mkMerge [
        {
          hostName = cfg.hostName;
          networkmanager.enable = cfg.useNetworkManager;
          firewall = {
            enable = true;
            allowedUDPPorts = [ config.services.tailscale.port ] ++ cfg.extraUdpPorts;
            allowedTCPPorts = [ 22 ] ++ cfg.extraTcpPorts;
          };
        }
        (lib.mkIf (cfg.staticIp != null && !cfg.useNetworkd) {
          useDHCP = false;
          interfaces.${cfg.staticIp.interface}.ipv4.addresses = [{
            address = cfg.staticIp.address;
            prefixLength = cfg.staticIp.prefixLength;
          }];
          nameservers = cfg.staticIp.nameservers;
        })
        (lib.mkIf (cfg.staticIp != null && !cfg.useNetworkd && !cfg.staticIp.onlinkGateway) {
          defaultGateway = cfg.staticIp.gateway;
        })
        (lib.mkIf cfg.wireguard.enable {
          wireguard.interfaces."wg-${cfg.hostName}" = {
            ips = cfg.wireguard.ips;
            privateKeyFile = cfg.wireguard.privateKeyFile;
            listenPort = cfg.wireguard.listenPort;
            peers = map (peer: {
              inherit (peer) publicKey allowedIPs;
            } // lib.optionalAttrs (peer.endpoint != null) {
              inherit (peer) endpoint;
            } // lib.optionalAttrs (peer.persistentKeepalive != null) {
              inherit (peer) persistentKeepalive;
            }) cfg.wireguard.peers;
          };
        })
      ];

      services.tailscale.enable = true;

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
        } // lib.optionalAttrs (cfg.sshAllowUsers != [ ]) {
          AllowUsers = cfg.sshAllowUsers;
        };
      };
    }

    (lib.mkIf (cfg.staticIp != null && cfg.useNetworkd) {
      networking.useDHCP = false;
      systemd.network.enable = true;
      services.resolved.enable = true;

      systemd.network.networks."10-${cfg.staticIp.interface}" = {
        matchConfig.Name = cfg.staticIp.interface;
        address = [ "${cfg.staticIp.address}/${toString cfg.staticIp.prefixLength}" ];
        dns = cfg.staticIp.nameservers;
        routes = [
          ({
            routeConfig = {
              Gateway = cfg.staticIp.gateway;
            } // lib.optionalAttrs cfg.staticIp.onlinkGateway {
              GatewayOnLink = true;
            };
          })
        ];
        networkConfig = {
          DHCP = "no";
        };
        linkConfig.RequiredForOnline = "routable";
      };
    })
  ];
}
