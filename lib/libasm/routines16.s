print_16:																	; params: bx
	mov ah, 0x0e														; 0x10 function 15/0xe
	mov al, [bx]														; mov byte at mem of bx into al
	int 0x10																; teletype output
	inc bx																	; increment memory address in al by 1
	cmp byte [bx], 0												; check if char at inc mem is null byte
	jne print_16															; if not null byte cont, else return
	ret

print_hex_16:															; params: dx
	mov ah, 0x0e														; 0x10 function 15/0xe
	mov bx, hex_out_16											; mov mem of pre-defined template for hex op
	mov ecx, len_hex_16												; and pre-defined length into registers
	sub ecx, 2															; sub len by 2 due to string suffix
	call loop_hex_16												; call loop sub-fn that handles logic
	ret		
loop_hex_16:
	push dx																	; push param dx to preserve inp
	and dx, 0x0f 														; bitwise and to get lsb of hex number
	mov al, dl															; put lsb into al, reg for 0x10
	add al, 0x30														; algorithm for hex to ascii:
	cmp al, 0x39															; if 0-9 then add 0x30
	jg lh1_16																	; else jump to l1
lh2_16:	mov byte [hex_out_16 + ecx], al			; input byte at [template mem + altered length]
	dec ecx																	; dec ecx -> shift input byte in string to left
	pop dx																	; get preserved curr iter hex number
	shr dx, 4																; shift hex number right 4 bits (erase lsb)
	cmp ecx, 1															; check if len 1 -> don't want to overwrite '0x'
	jne loop_hex_16														; if not loop again
	mov bx, hex_out_16												; else put constructed hex string into bx param
	call print_16															; and call print fn
	ret
lh1_16:	add al, 0x27											; alt loop for hex a-e: add 0x27
	jmp lh2_16

hex_out_16 db "0x0000",0
len_hex_16 equ $ - hex_out_16