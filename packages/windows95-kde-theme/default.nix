final: prev: {
  windows95-kde-theme = prev.stdenvNoCC.mkDerivation {
    pname = "windows95-kde-theme";
    version = "1.0";

    src = prev.fetchFromGitHub {
      owner = "fakemanoan";
      repo = "Windows-Classic-Dark-KDE";
      rev = "103a1a5d77ec361d7aafe4f27e9925e59eafb327";
      hash = "sha256-0wG91leNHpwpg8+/j+jm3SKFXMqwGx9hxocys8NoNOA=";
    };

    iconSrc = prev.fetchFromGitHub {
      owner = "grassmunk";
      repo = "Chicago95";
      rev = "5da19b8b1e2a886ebf6628403023d5fac3acc3ee";
      hash = "sha256-8d9wrgoUwKvlEUJXF8E8tP0iNJlkWjbO4E5X0ZViZ8Y=";
    };

    nativeBuildInputs = [ prev.gzip ];
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      themeDir="$out/share/aurorae/themes/Windows95"
      lookAndFeelDir="$out/share/plasma/look-and-feel/org.kde.windows95.desktop"
      mkdir -p \
        "$themeDir" \
        "$lookAndFeelDir/contents" \
        "$out/share/color-schemes" \
        "$out/share/icons"

      install -m644 ${./Windows95.colors} "$out/share/color-schemes/Windows95.colors"
      install -m644 ${./metadata.desktop} "$themeDir/metadata.desktop"
      install -m644 ${./windows95rc} "$themeDir/Windows95rc"
      install -m644 ${./look-and-feel-metadata.json} "$lookAndFeelDir/metadata.json"
      install -m644 ${./defaults} "$lookAndFeelDir/contents/defaults"

      cp -r "$iconSrc/Icons/Chicago95" "$out/share/icons/Chicago95"

      for asset in close maximize minimize restore; do
        install -m644 "$src/aurorae/themes/windows-classic/$asset.svgz" "$themeDir/$asset.svgz"
      done

      # Recolor the upstream active title-bar gradient to the classic Win95 blue.
      gzip -dc "$src/aurorae/themes/windows-classic/decoration.svgz" \
        | sed \
          -e 's/stop-color:#000000/stop-color:#000080/g' \
          -e 's/stop-color:#1b1b1b/stop-color:#1084d0/g' \
        | gzip -n > "$themeDir/decoration.svgz"

      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "Windows 95-style KDE global theme, icons, and Aurorae window decoration";
      homepage = "https://github.com/grassmunk/Chicago95";
      license = with licenses; [
        gpl3
        gpl3Plus
        mit
      ];
      platforms = platforms.linux;
    };
  };
}
