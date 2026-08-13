{
  description = "NixOS configuration for my homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    sidra ={
      url = "github:wimpysworld/sidra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    llm-agents.url = "github:numtide/llm-agents.nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, apple-fonts, home-manager, plasma-manager, sidra, vscode-server, nix-vscode-extensions, agenix, ... }@inputs: {
    nixosConfigurations = {
      miku-homelab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit apple-fonts inputs; };
        modules = [
          ./hosts/miku-homelab
          home-manager.nixosModules.home-manager
          inputs.nix-flatpak.nixosModules.nix-flatpak
          vscode-server.nixosModules.default
          agenix.nixosModules.default
          {
            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
              (final: prev: {
                breeze-enhanced = final.kdePackages.callPackage ./pkgs/breeze-enhanced.nix { };
              })
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [
              plasma-manager.homeModules.plasma-manager
            ];
            home-manager.users.emmatherock = { osConfig, ... }: {
              imports = [ ./home/emmatherock/core.nix ] ++ osConfig.myHomeProfile.extraPrograms;
            };
          }
        ];
      };

      vps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/vps
          home-manager.nixosModules.home-manager
          vscode-server.nixosModules.default
          agenix.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.emmatherock = { osConfig, ... }: {
              imports = [ ./home/emmatherock/core.nix ] ++ osConfig.myHomeProfile.extraPrograms;
            };
          }
        ];
      };
    };
  };
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://cache.numtide.com"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
