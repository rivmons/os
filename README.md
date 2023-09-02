### TODO
- implement filesystem routines based on fat 12
- write stage 2 and implement gdt with protected mode
-> update Makefile

### improvements
- change to disk image
  - must get drive geometry using bios interrupt to read from disk (see osdev disk access)
  - min boot image size is 16MB (32768 clusters), change if=floppy on qemu

