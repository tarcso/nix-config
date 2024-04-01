{ pkgs, ... }:
{
  imports = [
    ./ranger.nix
    ./tmux.nix
    ./gpg.nix
  ];

  home.packages = with pkgs; [
    ncdu
    jq
    htop
  ];
}
