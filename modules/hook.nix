{ config, pkgs, ... }:
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
  environment.etc."pickup/kernelmodules".source = modulesClosure;

  boot.postBootCommands = ''
    PATH=${pkgs.nix}/bin /nix/.nix-netboot-serve-db/register
  '';
}
