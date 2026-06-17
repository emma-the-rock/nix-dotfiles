{ config, lib, pkgs, apple-fonts, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./secureboot.nix
    ./maintenance.nix
    ./users.nix
    ./network.nix
    ./desktop.nix
    ./containers.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
    initrd.kernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_cachyos ;
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
  
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  system.stateVersion = "25.11";
}
