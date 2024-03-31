{ pkgs, ... }:
{
  imports = [
    ./ranger.nix
    ./tmux.nix
  ];

  home.packages = with pkgs; [
    ncdu
    jq
    htop
  ];
}
