# simplechroot
Chroot with ease

### Features
- Setup a chroot and chroot in in a single command
- The ability to reinstall grub easily

### Obtaining
Just get the script:
```bash
wget https://gitlab.com/BobyMCbobs/simplechroot/raw/1.1.0/simplechroot
chmod +x simplechroot
```

### Usage
```bash
# find partitions if you don't know them
simplechroot -l

# chroot into an already mounted root partition
simplechroot -r /mnt/rootPartition

# chroot into an umounted root partition (using it's node name)
simplechroot -r /dev/sda2

# mount the boot node and chroot (on if there is a boot partition)
simplechroot -r /dev/sda2 -b /dev/sda1  

# mount the boot node, chroot, and reinstall grub
simplechroot -r /dev/sda2 -b /dev/sda1 --reinstall-grub

# mount the boot node, chroot, and run a single command
simplechroot -r /dev/sda2 -b /dev/sda1 -c "ls -alh /bin/."
```

| Arg | Description |
| - | - |
| `-l` or `--list-partitions` | List partitions and LVM partition |
| `-r` or `--root` | Mounted root partition path or devfs node (i.e: /mnt/p, /dev/sda2, /dev/nvme0n1p2) |
| `-b` or `--boot` | Boot partition devfs node (i.e: /dev/sda1, /dev/nvme0n1p1) |
| `-rg` or `--reinstall-grub` | Reinstall grub on the given drive (requires -r and -b) |
| `-c` or `--command` | Pass a command inside the chroot environment |

### Packaging
AppImage: `make prep-appimage && make build-appimage`  
deb package: `make deb-pkg`  
deb source package: `make deb-src`  
zip package: `make build-zip`  
spec file: [support/specs/simplechroot.spec](support/specs/simplechroot.spec)

### Notes
- This has been tested:
    - Elementary OS 5.0
    - Fedora Workstation 28 & 29
    - openSUSE Leap 15
    - Ubuntu 18.04 & 18.10

### License
Copyright 2018 Caleb Woodbine.  
This project is licensed under the GPL-3.0 and is free software.  
This program comes with absolutely no warranty.  
