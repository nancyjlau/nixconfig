{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;[
      neovim
      curl
      git
      python3
      file
      virtualenv
    ];

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Use custom location for configuration.nix.
  environment.darwinConfig = "$HOME/.config/nix-darwin/configuration.nix";

  # Enable alternative shell support in nix-darwin.
  # programs.nushell.enable = true;
  environment.shells = with pkgs; [                                                nushell
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
