final: prev: {
  browse = prev.rustPlatform.buildRustPackage {
    pname = "browse";
    version = "0.1.5";

    src = prev.fetchFromGitHub {
      owner = "anomalyco";
      repo = "browse";
      tag = "v0.1.5";
      hash = "sha256-BIzCe/atioMcWg+UvuXeEpijh6CHIXe5tPpR5L0JYcU=";
    };

    sourceRoot = "source/rust";
    cargoHash = "sha256-IDAIKwDYSnNjqS6bUV7b+vS4wjYa1UNOGChIhYK/MHA=";
    cargoBuildFlags = [
      "--package"
      "browse"
      "--bin"
      "browse"
    ];

    # One integration test attempts to execute an installed package binary,
    # which the Nix sandbox does not allow.
    doCheck = false;

    installPhase = ''
      runHook preInstall

      install -Dm755 \
        "target/${prev.stdenv.hostPlatform.rust.cargoShortTarget}/release/browse" \
        "$out/bin/browse"
      install -Dm644 ../LICENSE "$out/share/licenses/browse/LICENSE"

      runHook postInstall
    '';

    meta = {
      description = "Browser automation CLI and MCP server for your real browser";
      homepage = "https://github.com/anomalyco/browse";
      license = final.lib.licenses.mit;
      mainProgram = "browse";
      platforms = final.lib.platforms.linux;
    };
  };
}
