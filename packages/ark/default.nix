final: prev: {
  ark-posit =
    let
      pname = "ark";
      version = "0.1.222";
    in
    prev.rustPlatform.buildRustPackage {
      inherit pname version;
      src = prev.fetchFromGitHub {
        owner = "posit-dev";
        repo = pname;
        tag = version;
        hash = "sha256-68pQyZvZageyIEbUfYpIkWuxHclc73NpN6/QKsNCXHA=";
      };

      cargoHash = "sha256-MotCHl3FEF6D5gNHhayatnAPkbbWTN7ajwF8PY3KWgs=";
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
