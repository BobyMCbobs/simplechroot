# simplechroot
Chroot with ease

### Features
- Setup a chroot and chroot in in a single command
- The ability to reinstall grub easily

### Obtaining
Just get the script:
```bash
wget https://gitlab.com/BobyMCbobs/simplechroot/raw/master/simplechroot
chmod +x simplechroot
```

### Usage
```bash
# chroot into an already mounted root partition
simplechroot -d /mnt/rootPartition

# chroot into an umounted root partition (using it's node name)
simplechroot -d /dev/sda2

# mount the boot node and chroot (on if there is a boot partition)
simplechroot -d /dev/sda2 -b /dev/sda1  

# mount the boot node, chroot, and reinstall grub
simplechroot -d /dev/sda2 -b /dev/sda1 --reinstall-grub 2

# mount the boot node, chroot, and run a single command
simplechroot -d /dev/sda2 -b /dev/sda1 -c "ls -alh /bin/."
```

| Arg | Description |
| - | - |
| `-d` | Mounted root partition path or devfs node (i.e: /mnt/p, /dev/sda2, /dev/nvme0n1p2) |
| `-b` | Boot partition devfs node (i.e: /dev/sda1, /dev/nvme0n1p1) |
| `--reinstall-grub` | Reinstall grub on the given drive (requires -d and -b). For use in grub2-install use `--reinstall-grub 2` |
| `-c` | Pass a command inside the chroot environment |

### Packaging
AppImage: `make prep-appimage && make build-appimage`  
deb package: `make deb-pkg`  
deb source package: `make deb-src`  
zip package: `make build-zip`  
spec file: [support/specs/simplechroot.spec](support/specs/simplechroot.spec)

### Notes
- This has been tested:
    - Fedora 28
    - Ubuntu 18.04
    - openSUSE Leap 15

### License
Copyright 2018 Caleb Woodbine.  
This project is licensed under the GPL-3.0 and is free software.  
This program comes with absolutely no warranty.  
