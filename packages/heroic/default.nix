final: prev: {
  heroic = prev.symlinkJoin {
    name = "heroic-wrapped";
    paths = [ prev.heroic ];
    buildInputs = [ prev.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/heroic \
        --set XDG_CONFIG_HOME "/home/detroyejr/.config"
    '';
  };
}
