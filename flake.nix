{
  description = "My first flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:dlaukamp/nixvim";
  };

  outputs =  { self, nixpkgs, home-manager, nixvim, ...}@ inputs: 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        vm-nixos-01 = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ]; 
        };
      };
      homeConfigurations = {
        dlkmp = home-manager.lib.homeManagerConfiguration {
          inherit pkgs; 
          extraSpecialArgs = {inherit inputs;};
          modules = [ ./home.nix ]; 
         };
      };
    };
}
