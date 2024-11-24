{ config, pkgs, ... }:
{
  imports = [ 
    <home-manager/nix-darwin>
  ];

  # Your existing system packages
  environment.systemPackages = with pkgs; [
    neovim
    curl
    git
    python3
    file
    virtualenv
    python312Packages.cmake
  ];

  # Make sure shell paths include the user profile
  environment.profiles = [
    "/etc/profiles/per-user/rose"
  ];

  users.users.rose = {
    name = "rose";
    home = "/Users/rose";
  };

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.rose = { pkgs, ... }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        username = "rose";
        homeDirectory = "/Users/rose";
        # Set session path to include the user profile
        sessionPath = [ "/etc/profiles/per-user/rose/bin" ];
        packages = with pkgs; [
          atool
          httpie
          binwalk
          pwntools
          nushell
          tmux
        ];
        stateVersion = "24.05";
      };
      
      programs.home-manager.enable = true;
      
      # Configure zsh to load the environment
      programs.zsh = {
        enable = true;
        initExtra = ''
          export PATH="/etc/profiles/per-user/rose/bin:$PATH"
          if [ -e '/etc/profiles/per-user/rose/etc/profile.d/hm-session-vars.sh' ]; then
            . '/etc/profiles/per-user/rose/etc/profile.d/hm-session-vars.sh'
          fi
        '';
      };
    };
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  environment.darwinConfig = "$HOME/.config/nix-darwin/configuration.nix";
  environment.shells = with pkgs; [ nushell ];
  system.stateVersion = 5;
}
