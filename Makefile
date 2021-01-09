SHELL = /usr/bin/env bash

NIXPKGS_PATH ?= ~/nixpkgs

BASE_ID ?= com.example.nix-remarkable
QT_SETTINGS_PATH ?= ./.systemdir
QT_SDK_PATH = $(QT_SETTINGS_PATH)/QtProject/qtcreator

SDKTOOL ?= sdktool
MKDIR ?= mkdir -p
QTCREATOR ?= qtcreator

-include project.mk

all: add-compiler add-debugger add-qt-version add-device add-qt-kit

clean: rm-qt-kit rm-device rm-qt-version rm-compiler rm-debugger

# remarkable-toolchain is broken, hence the NIXPKGS_ALLOW_BROKEN=1
shell:
	NIXPKGS_ALLOW_BROKEN=1 nix-shell -I nixpkgs=$(shell realpath $(NIXPKGS_PATH))

# Execute the following commands from within a functioning shell

# https://doc.qt.io/qtcreator/creator-targets.html
# https://embeddeduse.com/2020/11/21/cross-compiling-qt-embedded-applications-with-qtcreator-and-cmake/
# https://code.qt.io/cgit/yocto/meta-boot2qt.git/tree/meta-boot2qt/files/configure-qtcreator.sh

$(realpath $(QT_SETTINGS_PATH)):
	$(MKDIR) $@

qtcreator: $(realpath $(QT_SETTINGS_PATH))
	$(QTCREATOR) \
		-notour \
		-installsettingspath $(realpath $(QT_SETTINGS_PATH)) \
		-theme dark

# Add to QtCreatorQtVersions in qtversion.xml
add-qt-version:
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) addQt \
		--id "SDK.$(BASE_ID).qt" \
		--name "Qt %{Qt:Version} (reMarkable toolchain $(TOOLCHAIN_VERSION))" \
		--qmake $(TOOLCHAIN_SDK_PATH)/usr/bin/qmake \
		--type "Qt4ProjectManager.QtVersion.Desktop" \
		--abis arm-linux-generic-elf-32bit
	
rm-qt-version:
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) rmQt --id $(BASE_ID).qt

# Add to QtCreatorToolChains in toolchains.xml
add-compiler:
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) addTC \
		--id "ProjectExplorer.ToolChain.Gcc:$(BASE_ID).gcc" \
		--language 1 \
		--name "GCC (C, reMarkable toolchain $(TOOLCHAIN_VERSION))" \
		--path $(GNUEABI_PATH)/arm-oe-linux-gnueabi-gcc \
		--abi arm-linux-generic-elf-32bit
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) addTC \
		--id "ProjectExplorer.ToolChain.Gcc:$(BASE_ID).g++" \
		--language 2 \
		--name "GCC (C++, reMarkable toolchain $(TOOLCHAIN_VERSION))" \
		--path $(GNUEABI_PATH)/arm-oe-linux-gnueabi-gcc \
		--abi arm-linux-generic-elf-32bit

rm-compiler:
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) rmTC --id "ProjectExplorer.ToolChain.Gcc:$(BASE_ID).gcc"
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) rmTC --id "ProjectExplorer.ToolChain.Gcc:$(BASE_ID).g++"

# Add to QtCreatorDebuggers in debuggers.xml
add-debugger:
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) addDebugger \
		--id $(BASE_ID).gdb \
		--name "GDB (reMarkable toolchain $(TOOLCHAIN_VERSION))" \
		--engine 1 \
		--binary $(GNUEABI_PATH)/arm-oe-linux-gnueabi-gdb \
		--abis arm-linux-generic-elf-32bit

rm-debugger:
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) rmDebugger --id $(BASE_ID).gdb

# Add to QtCreatorProfiles in profiles.xml
# See https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html
add-qt-kit:
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) addKit \
		--id $(BASE_ID).kit \
		--name "Profile (reMarkable toolchain $(TOOLCHAIN_VERSION))" \
		--debuggerid $(BASE_ID).gdb \
		--devicetype "GenericLinuxOsType" \
		--sysroot "$(TOOLCHAIN_SDK_PATH)" \
		--Ctoolchain "ProjectExplorer.ToolChain.Gcc:$(BASE_ID).gcc" \
		--Cxxtoolchain "ProjectExplorer.ToolChain.Gcc:$(BASE_ID).g++" \
		--qt "SDK.$(BASE_ID).qt"

rm-qt-kit:
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) rmKit --id $(BASE_ID).kit

add-device:
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) addDev \
		--id $(BASE_ID).dev \
		--name "reMarkable (over USB)" \
		--type 0 \
		--authentication 1 \
		--host 10.11.99.1 \
		--origin 0 \
		--osType GenericLinuxOsType \
		--sshPort 22 \
		--timeout 10 \
		--uname root

rm-device:
	$(SDKTOOL) --sdkpath=$(QT_SDK_PATH) rmDev --id $(BASE_ID).dev

.PHONY: all clean shell \
	add-qt-version rm-qt-version \
	add-compiler rm-compiler \
	add-debugger rm-debugger \
	add-qt-kit rm-qt-kit
