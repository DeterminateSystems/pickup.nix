{
  outputs = { ... }: {
    nixosModules = {
      hook = import ./modules/hook.nix;

      stub-aws = import ./modules/stub-aws.nix;
      stub-aws-aarch64 = import ./modules/stub-aws-aarch64.nix;
    };
  };
}

