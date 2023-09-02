; convert lba to chs
; params: ax (lba address), dl (drive num)
; returns: cx (0-5: sector, 6-15: cyl), dh (head)
lba_to_chs:
	push dx																	; save
	push ax

	xor dx, dx
	div word [bdb_sectorsPerTrack]					; ax = lba / sec per track
	inc dx																	; dx = (lba % sec per track) + 1 = sector
	mov cx, dx															; cx = sector

	xor dx, dx
	div word [bdb_numHeads]									; ax = (lba / sec per track) / num heads = cyl
	mov dh, dl															; dx = (lba / sec per track) % num heads = head
	mov ch, al															; ch = cyl
	shl ah, 6																; shift left 6 bits
	or cl, ah																; 2 high bits of cyl in cl

	pop ax
	pop dx
	ret

; read disk using bios interrupt 13h
; params: ax (lba address), cl (sectors to read), dl (drive num), bx (buffer)
; returns: -
disk_read:
	push di
	push ax
	push bx
	push cx
	push dx 

	call lba_to_chs

	mov di, 0

.loop:
	mov ah, 0x02
	stc	
	int 13h
	jnc .fin

	pusha
	call disk_reset
	popa

	inc di
	cmp di, 5
	jz disk_error

	jmp .loop

.fin:
	pop dx
	pop cx
	pop bx
	pop ax
	pop di
	ret

; reset disk for retries
disk_reset:
	pusha
	mov dl, 0
	mov ah, 0
	stc
	int 13h
	jc disk_error
	popa
	ret

derror16_msg db "disk read error 1", 0