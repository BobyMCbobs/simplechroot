PREFIX ?= /usr

all: help

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@cp -p simplechroot $(DESTDIR)$(PREFIX)/bin
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/simplechroot

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/simplechroot

prep-deb:
	@mkdir -p deb-build/simplechroot
	@cp -p -r support/debian deb-build/simplechroot/debian
	@mkdir deb-build/simplechroot/debian/simplechroot
	@make DESTDIR=deb-build/simplechroot/debian/simplechroot install

deb-pkg: prep-deb
	@cd deb-build/simplechroot/debian && dedeb-build -b

deb-src: prep-deb
	@cd deb-build/simplechroot/debian && dedeb-build -S

prep-appimage:
	@if [ -x "./tools/appimagetool-x86_64.AppImage" ]; then echo "appimagetool is already downloaded."; exit 1; fi;
	@mkdir -p tools
	cd tools && wget https://github.com/AppImage/AppImageKit/releases/download/10/appimagetool-x86_64.AppImage && chmod +x appimagetool-x86_64.AppImage

build-appimage:
	@if [ ! -x "./tools/appimagetool-x86_64.AppImage" ]; then echo "Please run 'make prep-appimage'."; exit 1; fi;
	make DESTDIR=simplechroot.AppDir install
	@mkdir -p simplechroot.AppDir/usr/share/icons/hicolor/256x256/apps
	@cp ./support/AppImage/AppRun ./simplechroot.AppDir
	@cp ./support/shared-resources/simplechroot.desktop ./simplechroot.AppDir
	@cp ./support/AppImage/simplechroot.png ./simplechroot.AppDir
	@cp ./support/AppImage/simplechroot.png simplechroot.AppDir/usr/share/icons/hicolor/256x256/apps
	@chmod +x simplechroot.AppDir/AppRun
	ARCH=x86_64 ./tools/appimagetool-x86_64.AppImage -n simplechroot.AppDir

build-zip:
	@mkdir -p zip-build/simplechroot
	@make DESTDIR=zip-build/simplechroot install
	@cd zip-build/simplechroot && zip -r ../simplechroot.zip .

clean:
	@rm -rf deb-build simplechroot.AppDir simplechroot-x86_64.AppImage zip-build

help:
	@echo "Read 'README.md' for info on building."

