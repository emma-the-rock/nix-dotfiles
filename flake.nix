{
  description = "NixOS con Kernel CachyOS (vía xddxdd)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    sidra ={
      url = "github:wimpysworld/sidra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lan-mouse.url = "github:feschber/lan-mouse";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, chaotic, apple-fonts, lanzaboote, lan-mouse, sidra, vscode-server, ... }@inputs: {
    nixosConfigurations = {
      miku-homelab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit apple-fonts inputs; };
        modules = [
          ./configuration.nix
	        lanzaboote.nixosModules.lanzaboote
          vscode-server.nixosModules.default
          chaotic.nixosModules.default
        ];
      };
    };
  };
  nixConfig = {
    extra-substituters = [
        "https://lan-mouse.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "lan-mouse.cachix.org-1:KlE2AEZUgkzNKM7BIzMQo8w9yJYqUpor1CAUNRY6OyM="
    ];
  };
}
