[org 0x7c00]	
	[bits 16]		
		cli		
		lgdt [gdt_descriptor]

		mov eax, cr0
		or eax, 1
		mov cr0, eax
		jmp CODE_SEG:pm_first_command
	[bits 32]
		pm_first_command:
		
		mov Ax, DATA_SEG
		mov ds, Ax
		mov ss, Ax
		mov es, Ax
		mov fs, Ax
		mov gs, Ax
		
		mov Ax, TASK_0
		ltr Ax
		
		jmp TASK_1:0		
		
		return_to_main_task:			; print string into video memory(VGA)
		
		mov eax, cr0
		and al, 0xfe
		mov cr0, eax
		
		sti		
		jmp $	
		
		task_1:
			mov ebx, MESSAGE
			
			print_str_task_1:		; print string into video memory(VGA)
				mov al, [ebx]
				mov ah, 0x0f		;color
				mov ecx, 1000000h
				loop $
				cmp al, 0
				jmp TASK_2:0
				je return_to_main_task
				
				mov [edi], ax
				add ebx, 1
				add edi, 2
				
				jmp print_str_task_1
		task_2:
		mov ebx, MESSAGE
			
			print_str_task_2:		; print string into video memory(VGA)
				mov al, [ebx]
				mov ah, 0x05		;color
				mov ecx, 1000000h
				loop $
				cmp al, 0
				jmp TASK_1:0
				je return_to_main_task
				mov [edi], ax
				
				add ebx, 1
				add edi, 2
				
				jmp print_str_task_2		
		
;########################################################################################
		
	gdt_start:
		gdt_null:
			dq 0
		gdt_code:
			dw 0xffff; limit 0-15
			dw 0x0 ; base 0-15
			db 0x0 ; base 16-23
			db 10011010b ; P-1, DPL -00, S-1,Code-1,Conform-1,Readable-1,A-0
			db 11001111b ;G-1, 32-bit - 1, 64-bit seg - 0, AVL - 0, limit 16-19
			db 0x0; base 24-31
		gdt_data:
			dw 0xffff ; limit
			dw 0x0 ; base
			db 0x0 ;base
			db 10010010b ; flags
			db 11001111b ; flags, limit
			db 0x0 ; base		
		gdt_task0:
			dw 103
			dw TSS_0
			db 0
			db 89h ; busy, 32-bit, 0-ring privileges
			db 0
			db 0
		gdt_task1:
			dw 103
			dw TSS_1
			db 0
			db 89h ; busy, dpl
			db 0
			db 0
			
		gdt_task2:
			dw 103
			dw TSS_2
			db 0
			db 89h ; busy, dpl
			db 0
			db 0
					
		gdt_end:
		
	gdt_descriptor: ; table descriptor to pass to system
		dw gdt_end - gdt_start - 1
		dd gdt_start ;table start	
	
	CODE_SEG equ gdt_code - gdt_start
	DATA_SEG equ gdt_data - gdt_start
	TASK_0 equ gdt_task0 - gdt_start
	TASK_1 equ gdt_task1 - gdt_start
	TASK_2 equ gdt_task2 - gdt_start
	VIDEO_MEMORY equ 0xb8000
	
	MESSAGE db 'HiMyDear',0
	
	TSS_0:
		dw 0, 0 ; back link
		dd 0 ; ESP0
		dw 0, 0 ; SS0, reserved
		dd 0 ; ESP1
		dw 0, 0 ; SS1, reserved
		dd 0 ; ESP2
		dw 0, 0 ; SS2, reserved
		dd 0 ; CR3
		dd task_0, 0 ; EIP, EFLAGS (EFLAGS=0x200 for ints)
		dd 0, 0, 0, 0 ; EAX, ECX, EDX, EBX
		dd 0, 0, 0, 0 ; ESP, EBP, ESI, EDI
		dw DATA_SEG, 0 ; ES, reserved
		dw CODE_SEG, 0 ; CS, reserved
		dw DATA_SEG, 0 ; SS, reserved
		dw DATA_SEG, 0 ; DS, reserved
		dw DATA_SEG, 0 ; FS, reserved
		dw DATA_SEG, 0 ; GS, reserved
		dw 0, 0 ; LDT, reserved
		dw 0, 0 ; debug, IO perm. bitmap

	TSS_1:
		dw 0, 0 ; back link
		dd 0 ; ESP0
		dw 0, 0 ; SS0, reserved
		dd 0 ; ESP1
		dw 0, 0 ; SS1, reserved
		dd 0 ; ESP2
		dw 0, 0 ; SS2, reserved
		dd 0 ; CR3
		dd task_1, 0 ; EIP, EFLAGS (EFLAGS=0x200 for ints)
		dd 0, 0, 0, 0 ; EAX, ECX, EDX, EBX
		dd 0, 0, 0, VIDEO_MEMORY ; ESP, EBP, ESI, EDI
		dw DATA_SEG, 0 ; ES, reserved
		dw CODE_SEG, 0 ; CS, reserved
		dw DATA_SEG, 0 ; SS, reserved
		dw DATA_SEG, 0 ; DS, reserved
		dw DATA_SEG, 0 ; FS, reserved
		dw DATA_SEG, 0 ; GS, reserved
		dw 0, 0 ; LDT, reserved
		dw 0, 0 ; debug, IO perm. bitmap
		
	TSS_2:
		dw 0, 0 ; back link
		dd 0 ; ESP0
		dw 0, 0 ; SS0, reserved
		dd 0 ; ESP1
		dw 0, 0 ; SS1, reserved
		dd 0 ; ESP2
		dw 0, 0 ; SS2, reserved
		dd 0 ; CR3
		dd task_2, 0 ; EIP, EFLAGS (EFLAGS=0x200 for ints)
		dd 0, 0, 0, 0 ; EAX, ECX, EDX, EBX
		dd 0, 0, 0, VIDEO_MEMORY + 160 ; ESP, EBP, ESI, EDI
		dw DATA_SEG, 0 ; ES, reserved
		dw CODE_SEG, 0 ; CS, reserved
		dw DATA_SEG, 0 ; SS, reserved
		dw DATA_SEG, 0 ; DS, reserved
		dw DATA_SEG, 0 ; FS, reserved
		dw DATA_SEG, 0 ; GS, reserved
		dw 0, 0 ; LDT, reserved
		dw 0, 0 ; debug, IO perm. bitmap
		
times 512 - ($-$$) db 0

dw 0xaa55