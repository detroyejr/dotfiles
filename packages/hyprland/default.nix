let
  custom_splash = ./Splashes.hpp;
  waybarRev = "c15ec02ede4343592a59eb5c2ff4443c9c045f7c";
  waybarCavaSrc = builtins.fetchTarball {
    url = "https://github.com/LukashonakV/cava/archive/0.10.7.tar.gz";
    sha256 = "014sfgcfyvwxxx6sqa63mvvj2v2nfpcca0byllrdl7kky3ba6k6f";
  };
in
final: prev: {
  hyprland = prev.hyprland.overrideAttrs (oldAttrs: {
    prePatch = ''
      cp  ${custom_splash} ./src/helpers/Splashes.hpp
    '';
  });

  # Pin Waybar past 0.15.0 for Hyprland's Lua dispatch protocol support.
  waybar = prev.waybar.overrideAttrs (args: {
    version = "unstable-2026-10-19";
    src = prev.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = waybarRev;
      hash = "sha256-mBDWjeeIuFfDZQuBxHu+EpbJ+GMbbSxpRz0WVM2N+ZI=";
    };
    postUnpack = ''
      pushd "$sourceRoot"
      cp -R --no-preserve=mode,ownership ${waybarCavaSrc} subprojects/cava-0.10.7
      patchShebangs .
      popd
    '';
    buildInputs = args.buildInputs ++ [ prev.catch2 ];
    doInstallCheck = false;
    doCheck = false;
  });
}
