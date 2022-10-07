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
        hook = {
          imports = [
            ({ config, pkgs, ... }:
              let
                kernel-name = config.boot.kernelPackages.kernel.name or "kernel";
                modulesTree = config.system.modulesTree.override { name = kernel-name + "-modules"; };
                firmware = config.hardware.firmware;
                modulesClosure = pkgs.makeModulesClosure {
                  rootModules = [
                    "crypto_aes"
                    "crypto_cbc"
                    "dm-crypt"
                    "scsi-mod"
                    "sd-mod"
                    "virtio-pci"
                    "virtio-scsi"
                  ] ++ config.boot.initrd.kernelModules;
                  kernel = modulesTree;
                  firmware = firmware;
                  allowMissing = false;
                };
              in
              {
                config.environment.etc."pickup/kernelmodules".source = modulesClosure;
              }
            )
            nix-netboot-serve.nixosModules.register-nix-store
          ];
        };

        stub-aws-aarch64 = { pkgs, ... }: {
          config.fileSystems = if pkgs.hostPlatform.system == "aarch64-linux" then { "/boot".options = [ "noauto" ]; } else { };
        };
      };
    };
}

