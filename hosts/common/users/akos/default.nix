{ config, pkgs, ... }:
let
  ifGroupExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  # TODO: use nix-sops for secret management and disable user mutability
  users.mutableUsers = true;
  users.users.akos = {
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
  };

  home-manager.users.akos = import ../../../../home/akos/${config.networking.hostName}.nix;
}
