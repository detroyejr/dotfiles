{ inputs, system }:
final: _prev: {
  opencode = inputs.opencode.packages.${system}.default.overrideAttrs (old: {
    node_modules = old.node_modules.overrideAttrs (_: {
      # The opencode dev branch has a stale node_modules hash for this platform.
      outputHash =
        if system == "x86_64-linux" then
          "sha256-XDsJgdNpOpzns1jHohcpsRx2UR5fRlNMuhdv+bXyH6M="
        else
          "sha256-OA9iROWVfx+zS4xs+J3QfMyDqBifoCe9kmJcz8H4ssI=";
    });
  });

  opencode-desktop =
    (inputs.opencode.packages.${system}.opencode-desktop.override { opencode = final.opencode; })
    .overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [ ./patches/opencode-pr-60683.patch ];
        postPatch = old.postPatch + ''
          substituteInPlace packages/desktop/script/build.ts \
            --replace-fail \
              'const cli = path.resolve(dir, "../cli/dist")' \
              'const cli = process.env.OPENCODE_CLI_DIST ?? path.resolve(dir, "../cli/dist")'
        '';
      });
}
