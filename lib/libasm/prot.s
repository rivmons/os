[bits 16]                                  ; still need to assemble for 16-bit mode

to_protected:
  cli                                      ; turn off interrupts and ivt
  lgdt [gdt_descriptor]                    ; load gdt descriptor

  mov eax, cr0                             ; set first bit of control register, cr0,
  or eax, 0x1                                ; to make switch to 32-bit pm
  mov cr0, eax
  jmp code_segment:protected_mode_init     ; need to flush cache of instructions + jmp to 32-pm

[bits 32]                                  ; now in 32-bit protected mode!

protected_mode_init:
  mov ax, data_segment                     ; update segment registers based on gdt definition
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000                         ; update stack pos
  mov esp, ebp

  call pm                                  ; call label in main boot file