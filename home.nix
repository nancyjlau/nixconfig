{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  # System-level packages
  environment.systemPackages = with pkgs;[ ... ];

  # User definition
  users.users.yourname = {
    name = "Rose";
    home = "/Users/rose";
  };

  # Home Manager configuration
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.yourname = { pkgs, ... }: {
    home.packages = with pkgs; [
      atool
      httpie
      binwalk
      pwntools
      nushell
      tmux
      i3
      # other user-specific packages
    ];

    programs.bash.enable = true;
    home.stateVersion = "24.05";
  };

  # Rest of your system configuration
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  environment.darwinConfig = "$HOME/.config/nix-darwin/configuration.nix";
  environment.shells = with pkgs; [ nushell ];
  system.stateVersion = 5;
}
