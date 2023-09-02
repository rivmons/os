[bits 16]                                 ; initially loaded in 16-bit real mode
[org 0x7c00]                              ; set location counter to memory where boot sector loaded

jmp short start                           ; jmp to entry -> skip fat headers
nop

; bpb for fat12
bdb_oem: db "MSWIN4.1"
bdb_bytesPerSector: dw 512
bdb_sectorsPerCluster: db 1
bdb_reservedSectors: dw 1
bdb_numFATS: db 2
bdb_rootDirEntries: dw 224
bdb_totalSectors: dw 2880
bdb_mediaType: db 0xf0
bdb_sectorsPerFAT: dw 9
bdb_sectorsPerTrack: dw 18
bdb_numHeads: dw 2
bdb_numHiddenSectors: dd 0
bdb_numLargeSectors: dd 0

; ebr for fat12
ebr_driveNum: db 0
ebr_ntFlag: db 0
ebr_signature: db 0x29
ebr_volumeID: db 0x6, 0x9, 0x6, 0x9
ebr_volumeLabel: db "rivaaj     "
ebr_systemIdentifier: db "FAT12   "

reboot:                                    ; reboot routine
  mov ah, 0x0                              ; wait until keypress
  int 0x16
  jmp 0xffff:0                             ; use jmp to reboot

disk_error:
  mov bx, derror16_msg
  call print_16
  jmp $

start:                                     ; entry
  cld                                      ; clear direction flag
  stc

  xor ax, ax 														   ; clean register + set segment registers
  mov ds, ax
  mov es, ax

  mov ss, ax                               ; set stack (grows downward)
  mov sp, 0x7c00                           ; set stack ptr to beginning of boot sector address

  mov [ebr_driveNum], dl                   ; set drive num in fat header using bios loaded num
  mov cl, 1                                ; set num sectors to read
  mov ax, 1                                ; set lba address
  mov bx, 0x7e00                           ; buffer to read into
  call disk_read
  
  jmp $ 

%include "routines16.s"  
%include "disk16.s"              

times 510-($-$$) db 0											; fill rest of machine code to up to 510th byte
dw 0xaa55																	; magic word - 0xaa55 at last 2 bytes of sector -> boot sector
