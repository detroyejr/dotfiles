final: prev: {
  lutris = prev.lutris.override {
    # Intercept buildFHSEnv to modify target packages
    buildFHSEnv =
      args:
      prev.buildFHSEnv (
        args
        // {
          multiPkgs =
            envPkgs:
            let
              # Fetch original package list
              originalPkgs = args.multiPkgs envPkgs;

              # Disable tests for openldap
              customLdap = envPkgs.openldap.overrideAttrs (_: {
                doCheck = false;
              });
            in
            # Replace broken openldap with the custom one
            builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
        }
      );
  };
}
