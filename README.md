# simplechroot
Chroot with ease

### Features
- Setup a chroot and chroot in in a single command

### Usage
```bash
# chroot into an already mounted root partition
simplechroot -d /mnt/rootPartiton

# chroot into an umounted root partition (using it's node name)
simplechroot -d /dev/sda2

# mount the boot node and chroot (on if there is a boot partition)
simplechroot -d /dev/sda2 -b /dev/sda1  
``` 

| Arg | Description |
| - | - |
| -d | Mounted root partiton path or devfs node (i.e: /mnt/p, /dev/sda2, /dev/nvme0n1p2) |
| -b | Boot partition devfs node (i.e: /dev/sda1, /dev/nvme0n1p1) |

### License
Copyright 2018 Caleb Woodbine.  
This project is licensed under the GPL-3.0 and is free software.  
This program comes with absolutely no warranty.  
