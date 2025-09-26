final: prev: {
  whisper-cpp = prev.whisper-cpp.overrideAttrs (attrs: {
    src = prev.fetchFromGitHub {
      owner = "ggml-org";
      repo = "whisper.cpp";
      rev = "b175baa665bc35f97a2ca774174f07dfffb84e19";
      hash = "sha256-GtGzUNpIbS81z7SXFolT866fGfdSjdyf9R+PKlK6oYs=";
    };
  });
  custom-whisper-server = prev.stdenv.mkDerivation {
    name = "custom-whisper-server";
    version = "0.1";
    src = prev.fetchFromGitHub {
      owner = "detroyejr";
      repo = "custom-whisper-server";
      rev = "d23c4fc31c71904ee3c7202dc554ea0eb46d6ede";
      hash = "sha256-HBzUVPo+A+8RR/D1Tj+fXN+Y88tgXuQmcWd7/RiDM24=";
    };
    buildInputs = with final; [
      cmake
      httplib
      nlohmann_json
      whisper-cpp
    ];
    nativeBuildInputs = [ prev.yt-dlp ];

    installPhase = ''
      mkdir -p $out $out/bin
      cp custom-whisper-server $out/bin
      cp ${final.whisper-cpp}/bin/*.so $out/bin
    '';
  };
}
