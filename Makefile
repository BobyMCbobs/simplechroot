PREFIX = /usr
COMPLETIONDIR = $(PREFIX)/share/bash-completion/completions

all: help

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin $(DESTDIR)$(COMPLETIONDIR) $(DESTDIR)/usr/share/metainfo/
	@cp -p simplechroot $(DESTDIR)$(PREFIX)/bin
	@cp -p simplechroot.completion $(DESTDIR)$(COMPLETIONDIR)/simplechroot
	@cp -p support/shared-resources/simplechroot.appdata.xml $(DESTDIR)/usr/share/metainfo/
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/simplechroot
	@chmod 755 $(DESTDIR)$(COMPLETIONDIR)/simplechroot

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/simplechroot $(DESTDIR)$(PREFIX)/share/bash-completion/completions/simplechroot

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
	@mv ./simplechroot.AppDir/usr/share/metainfo/simplechroot.appdata.xml ./simplechroot.AppDir/usr/share/metainfo/com.bobymcbobs.simplechroot.appdata.xml
	@mv ./simplechroot.AppDir/simplechroot.desktop ./simplechroot.AppDir/com.bobymcbobs.simplechroot.desktop
	@chmod +x simplechroot.AppDir/AppRun
	@sed -i -e "s#<id>simplechroot.desktop</id>#<id>com.bobymcbobs.simplechroot.desktop</id>#g" ./simplechroot.AppDir/usr/share/metainfo/com.bobymcbobs.simplechroot.appdata.xml
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
