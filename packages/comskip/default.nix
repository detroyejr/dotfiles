let
  pname = "comskip";
  version = "0.83-unstable-2024-06-07";
in
final: prev: {

  # Needed to build comskip.
  argtable2 = final.stdenv.mkDerivation rec {
    pname = "argtable2";
    version = "2.13";

    src = final.fetchFromGitHub {
      owner = "jonathanmarvens";
      repo = pname;
      tag = "v${version}";
      hash = "sha256-K6++QVvpcPR+BYxbDRZ24sY0+PgIaQ3t1ktt3zZGh6Q=";
    };

    ctype-patch = final.writeTextFile {
      name = "ctype-patch.patch";
      text = ''
        From 2807d6bc04baefe0d309337ddd70f8b2cfa56eb7 Mon Sep 17 00:00:00 2001
        From: Leon Schumacher <leonsch@protonmail.com>
        Date: Sun, 29 Dec 2024 19:47:27 +0100
        Subject: [PATCH] arg_int.c: include ctype.h

        ---
         src/arg_int.c | 1 +
         1 file changed, 1 insertion(+)

        diff --git a/src/arg_int.c b/src/arg_int.c
        index 29c20e5..f805244 100644
        --- a/src/arg_int.c
        +++ b/src/arg_int.c
        @@ -26,6 +26,7 @@ USA.
         
         /* #ifdef HAVE_STDLIB_H */
         #include <stdlib.h>
        +#include <ctype.h>
         /* #endif */
         
         #include "argtable2.h"
        -- 
        2.47.0
      '';
    };

    patches = [
      # fixes some implicit function declarations
      ctype-patch
    ];

    enableParallelBuilding = true;

    meta = {
      description = "An ANSI C command line parser";
      homepage = "https://argtable.sourceforge.io";
    };
  };
  comskip = final.stdenv.mkDerivation rec {
    inherit pname version;

    src = final.fetchFromGitHub {
      owner = "erikkaashoek";
      repo = pname;
      rev = "2ef86841cd84df66fe0e674f300ee49cef6e097a";
      hash = "sha256-4ef/YZpaiSp3VeSiU6mRR38GjkrzxboI0/VXQ5QQiUM=";
    };

    nativeBuildInputs = with final; [
      autoreconfHook
      pkg-config
    ];

    buildInputs = with final; [
      argtable2
      ffmpeg_6-headless
    ];

    enableParallelBuilding = true;

    meta = {
      description = "A free commercial detector";
      homepage = "https://github.com/erikkaashoek/Comskip";
      mainProgram = pname;
    };
  };
}
