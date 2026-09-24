final: prev: {
  discord = prev.symlinkJoin {
    name = "discord-wrapped";
    paths = [ prev.discord ];
    buildInputs = [ prev.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/discord \
        --run 'export XDG_CONFIG_HOME="$HOME/.config"'
    '';
  };
}
