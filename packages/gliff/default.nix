final: prev: {
  gliff = prev.rustPlatform.buildRustPackage {
    pname = "gliff";
    version = "0.4.2";

    src = prev.fetchFromGitHub {
      owner = "omacom";
      repo = "gliff";
      rev = "v0.4.2";
      hash = "sha256-SUvnAxmXyBqPrtgBfEp06/KHlO0m2OtaP+lVaFgK04M=";
    };

    cargoHash = "sha256-kEzavuUNIq5/ov5HM+Ai/mv2J/v4chJ9GzmA19KWfr4=";
    cargoBuildFlags = [ "--workspace" ];

    nativeBuildInputs = with prev; [
      makeWrapper
      nasm
      pkg-config
    ];

    buildInputs = with prev; [
      dbus
      gtk4
      hicolor-icon-theme
      libadwaita
      libdrm
      libva
      libxkbcommon
      mesa
      mesa-libgbm
      openssh
      vulkan-loader
      wayland
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 target/release/gliff "$out/bin/gliff"
      install -Dm755 target/release/gliff-server "$out/bin/gliff-server"
      install -Dm755 target/release/gliff-probe "$out/bin/gliff-probe"
      install -Dm644 LICENSE "$out/share/licenses/gliff/LICENSE"
      install -Dm644 NOTICE "$out/share/licenses/gliff/NOTICE"
      install -Dm644 pkgbuild/gliff.desktop \
        "$out/share/applications/gliff.desktop"
      install -Dm644 pkgbuild/gliff.svg \
        "$out/share/icons/hicolor/scalable/apps/gliff.svg"
      install -Dm644 README.md "$out/share/doc/gliff/README.md"
      install -Dm644 docs/hardware-quirks.md \
        "$out/share/doc/gliff/hardware-quirks.md"

      wrapProgram "$out/bin/gliff" \
        --prefix PATH : "${prev.openssh}/bin"

      runHook postInstall
    '';

    meta = {
      description = "Hyprland remote desktop over SSH";
      homepage = "https://github.com/omacom/gliff";
      license = with prev.lib.licenses; [
        mit
        bsd2
      ];
      mainProgram = "gliff";
      platforms = [ "x86_64-linux" ];
    };
  };
}
