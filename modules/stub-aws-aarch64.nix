{ pkgs, ... }: {
  config.fileSystems = if pkgs.hostPlatform.system == "aarch64-linux" then { "/boot".options = [ "noauto" ]; } else { };
}
