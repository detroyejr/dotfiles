final: prev: {
  bookorbit = prev.bookorbit.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "3.9.0";

      src = prev.fetchFromGitHub {
        owner = "bookorbit";
        repo = "bookorbit";
        tag = "v${finalAttrs.version}";
        hash = "sha256-/2jJhPyLU/d6bROqk0jkXge7zkP1Yi4xATcWzASYqx4=";
      };

      pnpmWorkspaces = [
        "client..."
        "server..."
        "@bookorbit/read-aloud-worker"
      ];

      pnpmDeps = prev.fetchPnpmDeps {
        inherit (finalAttrs)
          pname
          version
          src
          pnpmWorkspaces
          ;
        pnpm = prev.pnpm_11;
        fetcherVersion = 4;
        hash = "sha256-RTiVPjE4AazlVnKV3UCnUy6oER8QQTZqaL+0hcsTkyU=";
      };

      buildPhase = ''
        runHook preBuild

        # @swc/core >= 1.16 ships its native addon as a self-loading ELF carrier
        # with a zstd payload that cannot initialize its cache in the Nix sandbox.
        # Replace the carrier with its decoded raw addon before building.
        find node_modules -name 'swc.*.node' -exec node -e '
          const fs = require("node:fs"), z = require("node:zlib");
          const signature = Buffer.from("SWCNZSTD\x01\x00\x60\x00", "latin1");
          for (const p of process.argv.slice(1)) {
            const b = fs.readFileSync(p);
            const i = b.indexOf(signature);
            if (i < 0) continue;
            const frameLen = Number(b.readBigUInt64LE(i + 16));
            const raw = z.zstdDecompressSync(b.subarray(i + 96, i + 96 + frameLen));
            fs.chmodSync(p, 0o644);
            fs.writeFileSync(p, raw);
          }
        ' {} +

        # ora's spinner hangs in the non-TTY sandbox without CI set.
        export CI=1
        pnpm --filter client run build-only
        pnpm --filter server run build

        pnpm --filter @bookorbit/types build

        export ONNXRUNTIME_NODE_INSTALL="skip"
        pnpm --filter @bookorbit/read-aloud-worker build

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/lib

        pnpm --filter server \
             --config.inject-workspace-packages=true \
             --prod \
             deploy $out/lib/bookorbit

        cp -r client/dist $out/lib/bookorbit/public
        cp -r server/src/db/migrations $out/lib/bookorbit/migrations
        cp -r koreader-plugin $out/lib/bookorbit/koreader-plugin

        makeWrapper ${prev.nodejs}/bin/node $out/bin/bookorbit \
          --run "cd $out/lib/bookorbit" \
          --set NODE_ENV production \
          --set APP_VERSION ${finalAttrs.version} \
          --add-flags "$out/lib/bookorbit/dist/main.js"

        makeWrapper ${prev.nodejs}/bin/node $out/bin/bookorbit-migrate \
          --set NODE_ENV production \
          --add-flags "$out/lib/bookorbit/dist/scripts/migrate.js"

        pnpm --filter @bookorbit/read-aloud-worker \
             --config.inject-workspace-packages=true \
             --prod \
             deploy $out/lib/bookorbit-read-aloud-worker

        makeWrapper ${prev.nodejs}/bin/node $out/bin/bookorbit-read-aloud-worker \
          --run "cd $out/lib/bookorbit-read-aloud-worker" \
          --set NODE_ENV production \
          --add-flags "$out/lib/bookorbit-read-aloud-worker/dist/main.js"

        runHook postInstall
      '';

      postInstall = ''
        rm -rf "$out/lib/bookorbit-read-aloud-worker/node_modules/onnxruntime-node/bin/napi-v6/win32"
        rm -rf ${
          final.lib.concatStringsSep " " (
            (final.lib.optional (
              !final.stdenv.hostPlatform.isx86_64
            ) "$out/lib/bookorbit-read-aloud-worker/node_modules/onnxruntime-node/bin/napi-v6/*/x64")
            ++ (final.lib.optional (
              !final.stdenv.hostPlatform.isAarch64
            ) "$out/lib/bookorbit-read-aloud-worker/node_modules/onnxruntime-node/bin/napi-v6/*/arm64")
            ++ (final.lib.optional (
              !final.stdenv.hostPlatform.isDarwin
            ) "$out/lib/bookorbit-read-aloud-worker/node_modules/onnxruntime-node/bin/napi-v6/darwin")
            ++ (final.lib.optional (
              !final.stdenv.hostPlatform.isLinux
            ) "$out/lib/bookorbit-read-aloud-worker/node_modules/onnxruntime-node/bin/napi-v6/linux")
          )
        }
      '';
    }
  );
}
