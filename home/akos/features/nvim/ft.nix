{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-nix
    {
      plugin = nvim-treesitter.withAllGrammars;
      type = "lua";
      config = /* lua */ ''
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
        }
      '';
    }
  ];
}
