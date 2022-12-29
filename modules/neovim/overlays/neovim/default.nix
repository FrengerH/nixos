self: super:

with super;

let
  cmp = pkgs.writeText "cmp.lua" (builtins.readFile ./config/cmp.lua);
  colorizer = pkgs.writeText "colorizer.lua" (builtins.readFile ./config/colorizer.lua);
  colorscheme = pkgs.writeText "colorscheme.lua" (builtins.readFile ./config/colorscheme.lua);
  debug = pkgs.writeText "debug.lua" (builtins.readFile ./config/debug.lua);
  gitsigns = pkgs.writeText "gitsigns.lua" (builtins.readFile ./config/gitsigns.lua);
  keymaps = pkgs.writeText "keymaps.lua" (builtins.readFile ./config/keymaps.lua);
  lightline = pkgs.writeText "lightline.lua" (builtins.readFile ./config/lightline.lua);
  lsp = pkgs.writeText "lsp.lua" (builtins.readFile ./config/lsp.lua);
  options = pkgs.writeText "options.lua" (builtins.readFile ./config/options.lua);
  telescope = pkgs.writeText "telescope.lua" (builtins.readFile ./config/telescope.lua);
  treesitter = pkgs.writeText "treesitter.lua" (builtins.readFile ./config/treesitter.lua);
in
  {
    neovim = super.neovim.override {
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = ''
          :set termguicolors
          luafile ${cmp}
          luafile ${colorizer}
          luafile ${colorscheme}
          luafile ${debug}
          luafile ${gitsigns}
          luafile ${keymaps}
          luafile ${lightline}
          luafile ${lsp}
          luafile ${options}
          luafile ${telescope}
          luafile ${treesitter}
        '';

        packages.nix = with pkgs.vimPlugins; {
          start = [
            # Git
            vim-fugitive
            gitsigns-nvim

            # Syntax
            vim-nix
            vim-markdown

            # Line
            lightline-vim

            # Telescope
            plenary-nvim
            telescope-nvim
            telescope-fzf-native-nvim

            # Theme
            dracula-vim
            tokyonight-nvim
            catppuccin-nvim

            # Comments
            vim-commentary

            # Lsp
            nvim-lspconfig

            # Completion
            nvim-cmp
            cmp-nvim-lsp
            cmp-buffer
            cmp-path
            cmp-cmdline
            cmp-nvim-lua
            cmp_luasnip
            luasnip

            # Treesitter
            # nvim-treesitter.withPlugins (plugins: with plugins; [
            #   all
            # ])
            nvim-treesitter.withAllGrammars
            nvim-treesitter-textobjects


            # Colors
            nvim-colorizer-lua

            # Dap
            nvim-dap
            nvim-dap-ui

            # Undo tree
            undotree

            # Harpoon
            harpoon
          ];
        };
      };
    };
  }

