final: prev: {
  bookorbit = prev.bookorbit.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "3.8.0";

      src = prev.fetchFromGitHub {
        owner = "bookorbit";
        repo = "bookorbit";
        tag = "v${finalAttrs.version}";
        hash = "sha256-dz/ctTLvI99mi9O9ABKFjDU4xF/Q0CiUAPecw+oz6zc=";
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
        hash = "sha256-N9c6l+ub+1NobtsCK3WSOlKyw7ol5e9RC4DWY9lubR0=";
      };

      buildPhase = ''
        runHook preBuild

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
