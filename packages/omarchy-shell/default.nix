final: prev:

let
  version = "unstable-2026-08-24";
  src = prev.fetchFromGitHub {
    owner = "basecamp";
    repo = "omarchy";
    rev = "quattro";
    hash = "sha256-ju17Zu9I5lIVvVULgTRvzOJmPMtmT2hre06IlNgQRKQ=";
  };
in
{
  omarchy-shell = prev.stdenv.mkDerivation {
    pname = "omarchy-quickshell";
    inherit src version;

    nativeBuildInputs = with prev; [
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/omarchy" "$out/bin" && \
        cp -r bin shell config default icon.png icon.txt logo.svg logo.txt \
          "$out/share/omarchy/"

      rm -rf \
        "$out/share/omarchy/shell/plugins/background" \
        "$out/share/omarchy/shell/plugins/menu"

        substituteInPlace $out/share/omarchy/shell/Commons/Color.qml \
          --replace-fail \
          "path: root.home + \"/.config/omarchy/shell.toml\"" \
          "path: \"/etc/xdg/CURRENT_THEME/quickshell/shell.toml\""

      find bin \
        -type f \
        -name "omarchy-*" \
        -exec sed -Ei "s,(omarchy-.*),$out/bin/\1," "{}" \; \
        && cp -r bin/* "$out/bin/"

      substituteInPlace $out/bin/omarchy-launch-shell \
        --replace-fail "quickshell"  "${prev.quickshell}/bin/qs"

      patchShebangs "$out/bin" "$out/share/omarchy/shell"

      for p in "$out"/bin/omarchy-*; do
        chmod +x "$p"
        if [[ -f "$p" && ! -L "$p" ]]; then
          wrapProgram "$p" --set OMARCHY_PATH "$out/share/omarchy"
        fi
      done

      runHook postInstall
    '';
  };
}
