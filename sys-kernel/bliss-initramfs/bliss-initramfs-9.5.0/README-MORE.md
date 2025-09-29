### Required Kernel Options for ZFS

- Linux Kernel

  `ZLIB_INFLATE` / `ZLIB_DEFLATE` can be compiled as a module but must be declared
  in the modules section in settings.json.
  * If you don't compile these modules (or load them), you will get an
    "unknown symbol" error when zfs is attempted to be used at boot.
  * `ZLIB_DEFLATE` cannot be told to be compiled in directly. You need to look
    at the `ZLIB_DEFLATE` dependencies (Do a search inside of menuconfig), and
    make sure that one of the conditions are all set to be built in.

This is an effort to collect all required dependencies (and attempting to document
any hidden ones) needed for you to compile a minimal kernel that supports booting
your rootfs on ZFS. Usually the generic kernels from distributions work because
they have enough things compiled in that all of the dependencies are already
taken into account.

If you find any more, email me so I can include them in this list.

### Required Kernel Options for Initramfs Support

  ```
  General setup --->
  > [*] Initial RAM filesystem and RAM disk (initramfs/initrd) support
    () Initramfs source file(s)
  ```

### Other

  * All other drivers required to see your PATA/SATA drives (or USB devices)
    need to be compiled in or you can compile them as a module and declare
    them in the modules section in settings.json.
