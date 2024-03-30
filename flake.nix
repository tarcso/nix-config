{
  description = "akosnad's NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    });
  in {
    inherit lib;

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    overlays = import ./overlays {inherit inputs outputs; };

    packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
    formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

    nixosConfigurations = {
      athena = lib.nixosSystem {
        modules = [ ./hosts/athena ];
        specialArgs = { inherit inputs outputs; };
      };
    };

    homeConfigurations = {
      "akos@athena" = lib.homeManagerConfiguration {
        modules = [ ./home/akos/athena.nix ];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
      };
    };
  };
}
