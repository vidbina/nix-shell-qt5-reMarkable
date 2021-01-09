# Nix shell ❄️🐚 for reMarkable toolchain

A template nix shell to provide a declarative development environment for
reMarkable hacking including the reMarkable-toolchain and Qt.

## Usage

```bash
nix-shell --pure -I nixpkgs=/path/to/nixpkgs
```

<!-- TODO: Add example of GitHub nixpkgs endpoint -->

> :warning: Use absolute paths when defining `nixpkgs`

## Variables

The Makefile will rely on the presence of the following vavriables:

- `TOOLCHAIN_SDK_PATH`, path to the Open Embedded SDK artefacts for
  cross-compilation, usually located in a subdirectory ending in
  `sysroots/$(ARCH)-oesdk-linux`
- `TOOLCHAIN_VERSION`, version of the toolchain
- `GNUEABI_PATH`, path to the GNUEAB resources like the GCC compilers and
  debugger

# Issues

## sdktool: DEBUG: Adding key QtVersion.0/isAutodetected which already exists.

This happens when using the sdktool with the key-value pair `isAutodetected
"bool:true"` or `isAutodetected "bool:false"` passed to the `sdktool addQt`
command as demonstrated in the following snippet:

```bash
sdktool addQt \
	--id "SDK.$(BASE_ID).qt" \
	--name "Qt %{Qt:Version} (reMarkable toolchain $(TOOLCHAIN_VERSION))" \
	--qmake $(TOOLCHAIN_SDK_PATH)/usr/bin/qmake \
	--type "Qt4ProjectManager.QtVersion.Desktop" \
	--abis arm-linux-generic-elf-32bit \
  isAutodetected bool:false
```

From the looks of the [source][git-qtcreator-isautodetected], this error is due
to the "isAutodetected" key being hardcoded to "true" and thus not settable
from sdktool.

[sdktool-bug]: https://bugreports.qt.io/browse/QTCREATORBUG-12707
[sdktool-example]: https://code.qt.io/cgit/yocto/meta-boot2qt.git/tree/meta-boot2qt/files/configure-qtcreator.sh

[git-qtcreator]: https://code.qt.io/cgit/qt-creator/qt-creator.git/about/
[git-qtcreator-isautodetected]: https://code.qt.io/cgit/qt-creator/qt-creator.git/tree/src/tools/sdktool/addqtoperation.cpp?h=4.11#n306

[arm-abi]: https://stackoverflow.com/questions/8060174/what-are-the-purposes-of-the-arm-abi-and-eabi
