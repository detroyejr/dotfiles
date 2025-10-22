final: prev: {
  python3Packages = prev.python3Packages.override {
    overrides = pythonSelf: pythonSuper: {
      redshift-connector = pythonSuper.redshift-connector.override { doCheck = false; };
    };
  };
}
