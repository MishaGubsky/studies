[org 0x7c00]
	mov 	bp, 0x9000
	mov 	sp, bp
	call 	switch_to_pm
	jmp 	$

gdt_start:
gdt_null: ; the mandatory null descriptor
	dd 0x0 ; ’dd’ means define double word (i.e. 4 bytes)
	dd 0x0
gdt_code: ; the code segment descriptor
	dw 0xffff ; Limit (bits 0-15)
	dw 0x0 ; Base (bits 0-15)
	db 0x0 ; Base (bits 16-23)
	db 10011010b ; 1st flags , type flags
	db 11001111b ; 2nd flags , Limit (bits 16-19)
	db 0x0 ; Base (bits 24-31)
gdt_data: ;the data segment descriptor
	dw 0xffff ; Limit (bits 0-15)
	dw 0x0 ; Base (bits 0-15)
	db 0x0 ; Base (bits 16-23)
	db 10010010b ; 1st flags , type flags
	db 11001111b ; 2nd flags , Limit (bits 16-19)
	db 0x0 ; Base (bits 24-31)
gdt_end: ; The reason for putting a label at the end of the
gdt_descriptor:
	dw gdt_end - gdt_start - 1 ; Size of our GDT, always less one
	dd gdt_start ; Start address of our GDT
	CODE_SEG equ gdt_code - gdt_start
	DATA_SEG equ gdt_data - gdt_start


[bits 16]
switch_to_pm:
	cli 
	lgdt 	[gdt_descriptor] ; Load our global descriptor table , which defines
	mov 	eax, cr0 ; To make the switch to protected mode, we set
	or 		eax, 0x1 ; the first bit of CR0, a control register
	mov 	cr0, eax	
	jmp 	CODE_SEG:init_pm ; Make a far jump (i.e. to a new segment) to our 32-bit

[bits 32]
init_pm:
	mov 	ax, DATA_SEG ; Now in PM, our old segments are meaningless ,
	mov 	ds, ax ; so we point our segment registers to the
	mov 	ss, ax ; data selector we defined in our GDT
	mov 	es, ax
	mov 	fs, ax
	mov 	gs, ax
	mov 	ebp, 0x90000 ; Update our stack position so it is right
	mov 	esp, ebp ; at the top of the free space.
	call 	BEGIN_PM ; Finally , call some well-known label


[bits 32]
; Define some constants
	VIDEO_MEMORY equ 0xb8000
	WHITE_ON_BLACK equ 0x0f
; prints a null-terminated string pointed to by EDX
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY ; Set edx to the start of vid mem.
print_string_pm_loop:
	mov al, [ebx] ; Store the char at EBX in AL
	mov ah, WHITE_ON_BLACK ; Store the attributes in AH
	cmp al, 0 ; if (al == 0), at end of string , so
	je print_string_pm_done ; jump to done
	mov [edx], ax ; Store char and attributes at current
	; character cell.
	add ebx, 1 ; Increment EBX to the next char in string.
	add edx, 2 ; Move to next character cell in vid mem.
	jmp print_string_pm_loop ; loop around to print the next char.
print_string_pm_done:
	popa
	ret ; Return from the function


[bits 32]
BEGIN_PM:

	mov 	ebx, MSG_PROT_MODE
	call 	print_string_pm
	jmp 	$ 	
	
	MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
	MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0
	
	
Return_To_RM:
	mov eax,cr0
	and ax, 0x0
	mov cr0,eax
	
	
	
	
	
	times 510-($-$$) db 0
	dw 0xaa55