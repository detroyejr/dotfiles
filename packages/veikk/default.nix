let
  pname = "viekk";
  version = "1.2.5-14";
in
final: prev: {
  veikkDriver = prev.stdenv.mkDerivation {
    inherit pname version;
    src = prev.fetchurl {
      url = "https://veikk.com/image/catalog/Software/vktablet-${version}-x86_64_deb.zip";
      hash = "sha256-RbAxXVvyl6BJq4vILZz7uDMTI9KPfw08i9lTOYj7RFA=";
    };
    buildInputs = with prev; [
      autoPatchelfHook
      dbus
      dpkg
      fontconfig
      freetype
      gcc
      glib
      libGL
      libusb1
      libz
      makeShellWrapper
      stdenv.cc.cc
      unzip
      xorg.libX11
      xorg.libXi
    ];
    dontWrapQtApps = true;
    unpackPhase = ''
      mkdir $out
      unzip $src
      dpkg -x vktablet-${version}-x86_64.deb unpacked
      ls unpacked
      cp -r unpacked/* $out/
    '';
    installPhase = ''
      mkdir $out/bin
      wrapProgram $out/usr/lib/vktablet/vktablet \
        --set QT_XKB_CONFIG_ROOT "${prev.xkeyboard_config}/share/X11/xkb" \
        --set QTCOMPOSE "${prev.xorg.libX11.out}/share/X11/locale" \
        --set QT_QPA_PLATFORM "xcb"
      install -D $out/usr/lib/vktablet/vktablet $out/bin
    '';
  };
  veikk = prev.makeDesktopItem {
    name = "VKTablet";
    exec = "${final.veikkDriver}/bin/vktablet";
    icon = "${final.veikkDriver}/usr/lib/vktablet/vktablet.png";
    desktopName = "VKTablet";
  };
}
