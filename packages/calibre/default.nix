prev: final: {
  calibre = prev.calibre.overrideAttrs {
    dontUsePytestCheck = "please dont";
  };
}
