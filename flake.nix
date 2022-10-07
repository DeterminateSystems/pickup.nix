{
  inputs = {
    nix-netboot-serve = {
      url = "github:DeterminateSystems/nix-netboot-serve";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nix-netboot-serve
    }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      nixosModules = {
        hook = ./modules/hook.nix;

        stub-aws-aarch64 = ./modules/stub-aws-aarch64.nix;
      };
    };
}

