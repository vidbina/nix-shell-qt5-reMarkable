{ pkgs ? import <nixpkgs> { } }:
let
  qt = pkgs.qt514;
in
pkgs.mkShell {

  buildInputs = with pkgs; [
    qtcreator
    remarkable-toolchain
  ];

  # https://remarkablewiki.com/devel/qt_creator#toolchain
  TOOLCHAIN_SDK_PATH = "${pkgs.remarkable-toolchain}/sysroots/x86_64-oesdk-linux";
  TOOLCHAIN_VERSION = pkgs.remarkable-toolchain.version;

  GNUEABI_PATH = "${pkgs.remarkable-toolchain}/sysroots/x86_64-oesdk-linux/usr/bin/arm-oe-linux-gnueabi";

  SDKTOOL = "${pkgs.qtcreator}/libexec/qtcreator/sdktool";

  QT_SCALE_FACTOR = 1;
  QT_AUTO_SCREEN_SCALE_FACTOR = 0;
  QT_SCREEN_SCALE_FACTORS = 2;

  shellHook = ''
    export HOME=$PWD/.homedir
    export PATH=${pkgs.qtcreator}/libexec/qtcreator:$PATH

    alias qtc="qtcreator -theme dark -notour -installsettingspath $PWD/.systemdir"

    source .bashrc
  '';
}
