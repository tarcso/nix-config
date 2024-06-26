{ outputs, config, lib, ... }:
let
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;
  # pubKey = host: ../../${host}/ssh_host_ed25519_key.pub;
in
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports anywhere
      GatewayPorts = "clientspecified";
    };

    hostKeys = [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  # programs.ssh = {
  #   knownHosts = builtins.mapAttrs
  #     (name: _: {
  #       publicKeyFile = pubKey name;
  #       extraHostNames =
  #         (lib.optional (name == hostName) "localhost");
  #     })
  #     hosts;
  # };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;
}
