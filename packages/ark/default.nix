final: prev: {
  ark-posit =
    let
      pname = "ark";
      version = "0.1.207";
    in
    prev.rustPlatform.buildRustPackage {
      inherit pname version;
      src = prev.fetchFromGitHub {
        owner = "posit-dev";
        repo = pname;
        tag = version;
        hash = "sha256-Pk3zOOzM+Ibd94CfBkg+QtHvUnlC6ne5yhjP4HeRN2w=";
      };

      cargoHash = "sha256-I+4ZVLUDPyAPx2Qbv6MtDfgzKrAoYSP/u85lHTV8Ckg=";
      doCheck = false;
      buildInputs = [
        prev.libcxx
        prev.libgcc
      ];

      nativeBuildInputs = [
        prev.autoPatchelfHook
        prev.rustPlatform.bindgenHook
      ];
    };
}
