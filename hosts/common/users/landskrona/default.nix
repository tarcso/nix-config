{ config, pkgs, ... }:
let
  ifGroupExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = true;
  users.users.landskrona = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ ifGroupExists [
      "network"
      "wireshark"
      "docker"
    ];
    packages = [ pkgs.home-manager ];
  };

  home-manager.users.landskrona = import ../../../../home/landskrona/${config.networking.hostName}.nix;
}
