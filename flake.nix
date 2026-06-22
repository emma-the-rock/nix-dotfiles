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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    llm-agents.url = "github:numtide/llm-agents.nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, chaotic, apple-fonts, home-manager, sidra, vscode-server, nix-vscode-extensions, ... }@inputs: {
    nixosConfigurations = {
      miku-homelab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit apple-fonts inputs; };
        modules = [
          ./hosts/miku-homelab
          home-manager.nixosModules.home-manager
          vscode-server.nixosModules.default
          chaotic.nixosModules.default
          {
            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.emmatherock = import ./home/emmatherock/home.nix;
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
