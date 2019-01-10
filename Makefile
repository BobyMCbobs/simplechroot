PREFIX ?= /usr
COMPLETIONDIR ?= $(PREFIX)/share/bash-completion/completions

all: help

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(COMPLETIONDIR)
	@cp -p simplechroot $(DESTDIR)$(PREFIX)/bin
	@cp -p simplechroot.completion $(DESTDIR)$(COMPLETIONDIR)/simplechroot
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/simplechroot
	@chmod 755 $(DESTDIR)$(COMPLETIONDIR)/simplechroot

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/simplechroot $(DESTDIR)$(COMPLETIONDIR)/simplechroot

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
	ARCH=x86_64 ./tools/appimagetool-x86_64.AppImage simplechroot.AppDir

prep-snap: build-zip
	mkdir -p snap-build
	mv zip-build/simplechroot.zip snap-build/.
	rm -rf zip-build
	cp support/snap/snapcraft.yaml snap-build

build-snap:
	cd snap-build && snapcraft cleanbuild

build-snap-docker:
	docker run -it --rm -v "$(shell pwd)":/build -w /build snapcore/snapcraft bash -c "(apt update && snapcraft) || bash"

build-zip:
	@mkdir -p zip-build/simplechroot
	@make DESTDIR=zip-build/simplechroot install
	@cd zip-build/simplechroot && zip -r ../simplechroot.zip .

clean:
	@rm -rf deb-build simplechroot.AppDir simplechroot-x86_64.AppImage zip-build snap-build parts prime stage simplechroot_*_*.snap

help:
	@echo "Read 'README.md' for info on building."
