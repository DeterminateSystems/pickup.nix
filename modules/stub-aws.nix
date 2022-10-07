{ pkgs, ... }: {
  boot.initrd.kernelModules = [
    "ena"
    "ixgbevf"
    "nvme"
  ];
}
