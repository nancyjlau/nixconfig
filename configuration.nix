{ config, pkgs, ... }:
{
  imports = [
    <home-manager/nix-darwin>
  ];

  environment.systemPackages = with pkgs; [
    neovim
    nil
    ripgrep
    fd
    htop
    fzf
    vimPlugins.nvim-tree-lua
    vimPlugins.nvim-web-devicons
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
    jdt-language-server
    haskell-language-server
    clang-tools
    rust-analyzer
    gopls
    lima
    minicom
  ];

  homebrew = {
    enable = true;
    # onActivation.cleanup = "uninstall";
    taps = [];
    brews = [ "libiconv" "git-lfs" "gradle" "aria2"];
    casks = [ "ghidra" "xquartz"];
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
          gnupg
          ocaml
          ihaskell
          atool
          httpie
          binwalk
          pwntools
          nushell
          tmux
          python312Packages.matplotlib
          python312Packages.ipykernel
          openjdk
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
          export PATH="/etc/profiles/per-user/rose/bin:/opt/homebrew/bin:$HOME/utils/oss-cad-suite/bin:$HOME/utils/sv2v-macOS:/Applications/klayout.app/Contents/Buddy:$PATH:$HOME/utils/verible-v0.0-3899-g75c38daf-macOS/bin"
          if [ -e '/etc/profiles/per-user/rose/etc/profile.d/hm-session-vars.sh' ]; then
            . '/etc/profiles/per-user/rose/etc/profile.d/hm-session-vars.sh'
          fi

          # Add Rust/Cargo environment
          if [ -f "$HOME/.cargo/env" ]; then
             . "$HOME/.cargo/env"
          fi
        '';
      };

      # Neovim configuration
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        plugins = with pkgs.vimPlugins; [
          {
            plugin = tokyonight-nvim;
            config = "colorscheme tokyonight-night";
          }
          vim-fugitive
          nvim-autopairs
          comment-nvim
          which-key-nvim
          indent-blankline-nvim
          nvim-treesitter.withAllGrammars
          telescope-nvim
          nvim-tree-lua
          lualine-nvim
          nvim-lspconfig
          nvim-cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          luasnip
          gitsigns-nvim
        ];

        extraConfig = ''
          set number
          set relativenumber
          set shiftwidth=2
          set tabstop=2
          set expandtab
          set smartindent
          set nowrap
          set noswapfile
          set nobackup
          set undofile
          set nohlsearch
          set termguicolors
          set scrolloff=8
          set updatetime=50

          " Set leader key to space
          let mapleader = " "

          " Key mappings
          nnoremap <leader>e :NvimTreeToggle<CR>
          nnoremap <leader>ff <cmd>Telescope find_files<cr>
          nnoremap <leader>fg <cmd>Telescope live_grep<cr>
          nnoremap <leader>fb <cmd>Telescope buffers<cr>
          nnoremap <leader>h :bprevious<CR>
          nnoremap <leader>l :bnext<CR>
          nnoremap <leader>w :w<CR>

          " Plugin configurations
          lua << EOF
          -- LSP configurations
          require('lspconfig').pyright.setup{}
          require('lspconfig').ocamllsp.setup{}
          require('lspconfig').hls.setup{}
          require('lspconfig').nil_ls.setup{}
          require('lspconfig').clangd.setup{}
          require('lspconfig').rust_analyzer.setup{}

          -- Treesitter configuration
          require('nvim-treesitter.configs').setup {
            highlight = { enable = true },
          }

          -- Completion setup
          local cmp = require'cmp'
          cmp.setup({
            snippet = {
              expand = function(args)
                require('luasnip').lsp_expand(args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert(),
            mapping = {
              ['<C-n>'] = cmp.mapping.select_next_item(),
              ['<C-p>'] = cmp.mapping.select_prev_item(),
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<Tab>'] = cmp.mapping.confirm({ select = true }),
              },
            sources = {
              { name = 'nvim_lsp' },
              { name = 'buffer' },
              { name = 'path' },
              { name = 'luasnip' },
            }
          })

          -- Lualine setup
          require('lualine').setup {
            options = { theme = 'tokyonight' }
          }

          -- configure diagnostic display
          vim.diagnostic.config({
           float = {
            max_width = 50,  -- Adjust this value to your preference
            wrap = true,     -- Enable wrapping in floating windows
           },
           virtual_text = {
            prefix = '●',    -- You can change this to any character you prefer
            spacing = 4,
            },
          })

          -- Java LSP configuration
          require('lspconfig').jdtls.setup{}

          -- Autopairs setup
          require('nvim-autopairs').setup{}

          -- Comment.nvim setup
          require('Comment').setup()

          -- Which-key setup
          require('which-key').setup()

          -- nvim-tree setup
          require('nvim-tree').setup({
            sort_by = "case_sensitive",
            view = {
              width = 30,
            },
            renderer = {
              group_empty = true,
            },
          })

          -- Gitsigns setup
          require('gitsigns').setup()
          EOF
        '';
      };
    };
  };

  security.pki.certificates = [];
  environment.variables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/cert.pem";
  };

  security.pam.enableSudoTouchIdAuth = true;

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  environment.darwinConfig = "$HOME/.config/nix-darwin/configuration.nix";
  environment.shells = with pkgs; [ nushell ];
  system.stateVersion = 5;
}
