{ pkgs, modulesPath, ... }: {
  boot.initrd.kernelModules = [
    "ena"
    "ixgbevf"
    "nvme"
  ];
  systemd.services.fetch-ec2-metadata = {
    wantedBy = [ "multi-user.target" ];
    before = [ "apply-ec2-data.service" ];
    script = pkgs.callPackage (modulesPath + "/virtualisation/ec2-metadata-fetcher.nix") {
      targetRoot = "/";
      wgetExtraOptions = "";
    };
    serviceConfig.Type = "oneshot";
  };
}
