final: prev:
let
  version = "0.47.1";
in
{
  immich-kiosk = prev.buildGo127Module rec {
    pname = "immich-kiosk";
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "damongolding";
      repo = "immich-kiosk";
      tag = "v${version}";
      hash = "sha256-4BwBeRIwbHgPM+6oMrLX7CzZ0SXDWcRlHXwKS8yKwmE=";
    };

    postPatch = ''
      # Delete vendor directory to regenerate it consistently across platforms
      rm -rf vendor
      # immich-kiosk bumps go at a faster cadence than nixpkgs
      sed -i -E 's/^go 1\.27\.[0-9]+$/go 1.27/' go.mod
    '';
    vendorHash = "sha256-fvbHAxxx+n4KiI6QzxvZZ81rT0IMNv6YHQ1Q0FgoCJM=";
    proxyVendor = true;

    npmDeps = prev.fetchNpmDeps {
      inherit src;
      sourceRoot = "${src.name}/frontend";
      hash = "sha256-5bHT5rBy2ToqSBfuhYLqfL3I4HDDkREEJl3/iCX/8bY=";
    };
    npmRoot = "frontend";

    nativeBuildInputs = [
      prev.nodejs
      prev.go-task
      prev.npmHooks.npmConfigHook
    ];

    # Generate templ templates during vendor hash calculation, without npm.
    overrideModAttrs = oldAttrs: {
      nativeBuildInputs = builtins.filter (drv: drv != prev.npmHooks.npmConfigHook) (
        oldAttrs.nativeBuildInputs or [ ]
      );
      preBuild = ''
        go tool templ generate
      '';
    };

    # Frontend assets are embedded into the binary via go:embed.
    preBuild = ''
      go tool templ generate
      task frontend
    '';

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${version}"
    ];

    # Tests require network access to an Immich server.
    doCheck = false;

    meta = {
      description = "Lightweight slideshow for running on kiosk devices and browsers that uses Immich as a data source";
      homepage = "https://github.com/damongolding/immich-kiosk";
      changelog = "https://github.com/damongolding/immich-kiosk/releases/tag/v${version}";
      license = final.lib.licenses.agpl3Only;
      mainProgram = "immich-kiosk";
      platforms = final.lib.platforms.linux;
    };
  };
}
