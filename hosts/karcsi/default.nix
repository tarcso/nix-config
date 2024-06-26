{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/optional/quietboot.nix
    ../common/optional/gnome.nix

    ../common/users/landskrona
  ];

  networking.hostName = "karcsi";
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  hardware.opengl.enable = true;

  powerManagement.powertop.enable = true;

  services.xserver.libinput = {
    enable = true;
    touchpad.tapping = true;
  };

  services.xserver.autoRepeatInterval = 150;
  services.xserver.autoRepeatDelay = 150;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    neofetch
    firefox
    jdk21
    prettierd
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
