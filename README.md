# Bliss Overlay
This is a Gentoo overlay providing ebuilds for bliss-initramfs.

## Installation

### Manual Installation
1. Create a new file `/etc/portage/repos.conf/bliss-overlay.conf`:
```
[bliss-overlay]
location = /var/db/repos/bliss-overlay
sync-type = git
sync-uri = https://github.com/sarahmeow86/gentoo-overlay-bliss.git
auto-sync = yes
```

2. Sync the repository:
```bash
emerge --sync bliss-overlay
```

### Using eselect-repository
```bash
eselect repository add bliss-overlay git https://github.com/sarahmeow86/gentoo-overlay-bliss.git
emerge --sync bliss-overlay
```

## Available Packages

### sys-kernel/bliss-initramfs
Generate an initramfs image for booting from Encrypted/OpenZFS.

#### USE flags:
- nvme: Adds support for NVMe drives