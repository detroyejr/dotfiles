final: prev: {
  calibre = prev.calibre.overrideAttrs {
    doCheck = false;
    installCheckPhase = "";
  };

  python314 = prev.python314.override {
    packageOverrides = python-self: python-super: {
      pyopenjtalk-plus = python-super.pyopenjtalk-plus.overridePythonAttrs {
        doCheck = false;
      };
    };
  };
}
