final: prev: {
  rustdesk = prev.rustdesk.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ prev.pipewire ];
  });
}
