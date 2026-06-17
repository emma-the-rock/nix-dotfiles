{
  description = "NixOS configuration for my homelab";

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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, chaotic, apple-fonts, lanzaboote, home-manager, sidra, vscode-server, ... }@inputs: {
    nixosConfigurations = {
      miku-homelab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit apple-fonts inputs; };
        modules = [
          ./hosts/miku-homelab
	        lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          vscode-server.nixosModules.default
          chaotic.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.emmatherock = import ./home/emmatherock/home.nix;
          }
        ];
      };
    };
  };
}
