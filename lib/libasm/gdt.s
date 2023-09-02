gdt_desc:                                 ; start of gdt descriptor

gdt_null:                                 ; null descriptor
  dd 0x0
  dd 0x0

gdt_code:                                 ; code segment descriptor
  dw 0xffff                               ; limit -> bits (0-15)
  dw 0x0                                  ; base -> bits (0-15)
  db 0x0                                  ; base -> bits (16-23)
  db 10011010b                            ; access byte
  db 11001111b                            ; limit + flags
  db 0x0                                  ; base -> bits (24-31)

gdt_data:                                 ; data segment descriptor (same as code except ab)
  dw 0xffff                               ; limit -> bits (0-15)
  dw 0x0                                  ; base -> bits (0-15)
  db 0x0                                  ; base -> bits (16-23)
  db 10010010b                            ; access byte
  db 11001111b                            ; limit + flags
  db 0x0                                  ; base -> bits (24-31)

gdt_end:                                  ; demarcate end of structure to calc size for descriptor

gdt_descriptor:
  dw gdt_end - gdt_desc - 1              ; size of gdt structure, 1 less than true size
  dd gdt_desc                            ; start address

code_segment equ gdt_code - gdt_desc     ; necessity for segment registers in protected mode
data_segment equ gdt_data - gdt_desc
