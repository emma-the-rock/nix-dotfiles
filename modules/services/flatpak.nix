{ inputs, pkgs, ... }:

{
  services.flatpak = {
    enable = true;

    # TEMPORARY: pin Flatpak itself to 1.16.6 via nixpkgs-flatpak (see flake.nix).
    # Flatpak >=1.18.0 leaks the NixOS host environment into the sandbox and breaks
    # glycin-svg icon loading (e.g. OpenDeck). Remove once
    # https://github.com/flatpak/flatpak/issues/6721 lands in nixpkgs.
    package = inputs.nixpkgs-flatpak.legacyPackages.${pkgs.system}.flatpak;

    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      "com.obsproject.Studio"
      "com.obsproject.Studio.Plugin.OBSVkCapture"
      "com.obsproject.Studio.Plugin.VerticalCanvas"
      "com.obsproject.Studio.Plugin.AitumMultistream"
      "com.obsproject.Studio.Plugin.CompositeBlur"
      "com.obsproject.Studio.Plugin.OBSPWVideo"
      "org.freedesktop.Platform.VulkanLayer.OBSVkCapture//25.08"
      "com.valvesoftware.Steam"
      "me.amankhanna.opendeck"
    ];
  };
}
