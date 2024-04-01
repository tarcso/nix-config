{ config, ... }:
let
  palette = config.colorscheme.palette;
in
{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "fzf" "last-working-dir" ];
    };
  };

  programs.powerline-go = {
    enable = true;
    modules = [ "ssh" "nix-shell" "cwd" "root" ];
    modulesRight = [ "exit" "perms" "git" "jobs" ];
  };

  programs.fzf = {
    enable = true;
    colors = {
      fg = "#${palette.base05}";
      "fg+" = "#${palette.base06}";
      bg = "#${palette.base00}";
      "bg+" = "#${palette.base01}";
    };
  };
}
