final: prev: {
  plexamp = prev.symlinkJoin {
    name = "plexamp-wrapped";
    paths = [ prev.plexamp ];
    buildInputs = [ prev.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/plexamp \
        --set XDG_CONFIG_HOME "/home/detroyejr/.config"
    '';
  };
}
