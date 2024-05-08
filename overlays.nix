final: prev: {
  fprintd = prev.fprintd.overrideAttrs {
    mesonCheckFlags = [
      "--no-suite"
      "fprintd:TestPamFprintd"
    ];
  };
  python3Packages.gdal = prev.python3Packages.gdal.overridePythonAttrs {
    doCheck = false;
  };

}
