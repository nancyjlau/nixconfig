{ config, pkgs, ... }:
{
  imports = [ 
    <home-manager/nix-darwin>
  ];

  environment.systemPackages = with pkgs; [
    neovim
    curl
    git
    python3
    file
    virtualenv
    python312Packages.cmake
    cacert
    docker_27
    tree
    poetry
  ];

    homebrew = {
    enable = true;
    # onActivation.cleanup = "uninstall";

    taps = [];
    brews = [ "libiconv" "git-lfs"]; 
    casks = [];
  };

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
	  ocaml
	  ihaskell
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
        loginExtra = ''
          if [ -f ~/.hushlogin ]; then
            rm ~/.hushlogin
          fi
        '';
        initExtra = ''
          # ASCII art greeting
          cat << 'EOF'
        へ  ♡  ╱|、
     ૮ - ՛)   (` - 7
      /⁻ ៸|   |、՛〵
  乀(ˍ,ل  ل   じしˍ,)ノ
EOF

          export PATH="/etc/profiles/per-user/rose/bin:/opt/homebrew/bin:$PATH"
          if [ -e '/etc/profiles/per-user/rose/etc/profile.d/hm-session-vars.sh' ]; then
            . '/etc/profiles/per-user/rose/etc/profile.d/hm-session-vars.sh'
          fi

          # Add Rust/Cargo environment
          if [ -f "$HOME/.cargo/env" ]; then
             . "$HOME/.cargo/env"
          fi
        '';
      };
    };
  };

  security.pki.certificates = [];
  environment.variables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/cert.pem";
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  environment.darwinConfig = "$HOME/.config/nix-darwin/configuration.nix";
  environment.shells = with pkgs; [ nushell ];
  system.stateVersion = 5;
}
