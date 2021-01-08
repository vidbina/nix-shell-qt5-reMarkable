{ pkgs ? import <nixpkgs> { } }:
let
  qt = pkgs.qt514;
in
pkgs.mkShell {

  buildInputs = with pkgs; [
    #qt.full
    qtcreator
    remarkable-toolchain
  ];

  #nativeBuildInputs = [ qt.wrapQtAppsHook ];

  POETRY_CACHE_DIR = "./.cache/poetry";

  # https://remarkablewiki.com/devel/qt_creator#toolchain
  TOOLCHAIN_BASE_PATH = "${pkgs.remarkable-toolchain}";
  TOOLCHAIN_SDK_PATH = "${pkgs.remarkable-toolchain}/sysroots/x86_64-oesdk-linux";
  TOOLCHAIN_VERSION = pkgs.remarkable-toolchain.version;

  # TODO: TOOLCHAIN_VERSION = pkgs.remarkable-toolchain.version;
  GNUEABI_PATH = "${pkgs.remarkable-toolchain}/sysroots/x86_64-oesdk-linux/usr/bin/arm-oe-linux-gnueabi";

  SDKTOOL = "${pkgs.qtcreator}/libexec/qtcreator/sdktool";

  #QT_DEBUG_PLUGINS = 1;

  #LD_LIBRARY_PATH = with pkgs; stdenv.lib.makeLibraryPath [
  #  stdenv.cc.cc
  #  libGL
  #  zlib
  #  glib # libgthread-2.0.so
  #  xorg.libX11 # libX11-xcb.so
  #  xorg.libxcb # libxcb-shm.so
  #  xorg.xcbutilwm # libxcb-icccm.so
  #  xorg.xcbutil # libxcb-util.so
  #  xorg.xcbutilimage # libxcb-image.so
  #  xorg.xcbutilkeysyms # libxcb-keysyms.so
  #  xorg.xcbutilrenderutil # libxcb-renderutil.so
  #  xorg.xcbutilrenderutil # libxcb-renderutil.so
  #  dbus # libdbus-1.so
  #  libxkbcommon # libxkbcommon-x11.so
  #  fontconfig
  #  freetype
  #];

  #LD_DEBUG = "libs";

  shellHook = ''
    source .bashrc
  '';
}
