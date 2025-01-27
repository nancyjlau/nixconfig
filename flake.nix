{
  description = "nix darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs, home-manager }: {
    darwinConfigurations."meowbook" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ 
        ./configuration.nix
        home-manager.darwinModules.home-manager
      ];
    };
  };
}
