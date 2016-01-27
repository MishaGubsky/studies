.model small
.stack 100h
.data
	ent_1_mess      db    "Enter your string",10,13,'$'
	ent_2_mess      db    "New string",10,13,'$'
	error_mess      db    "Error! $"
	output_1_mess   db    "Attitude= $"
	output_2_mess   db    "Residue= $" 
	space			db    0
	buffer          db    100
	newstring	    db    256 dup(' ')
	end_of_string   db    10,13,'$'
.code

sub_sim proc
push cx
push si
push dx
push bx




pop bx
pop dx
pop si
pop cx
ret 
endp sub_sim



;///////////////////////////////////////////////////////
backspace proc
	push ax
	push dx

	mov dl,8
	mov ah,02h
	int 21h

	mov dl,0
	mov ah,02h
	int 21h

	mov dl,8
	mov ah,02h
	int 21h

	pop dx
	pop ax
ret
endp backspace
;/////////////////////////////////////////////////////////



;////////////////////////////////////////////////////////
scan_num proc
	push ax
	push cx
	push dx
	
	
	xor bx,bx
	xor cx,cx
	lea si,newstring

		
scan_loop:
	mov ah, 08h
	int 21h	
	mov dl,al
	inc cx
	
	cmp dl, 27
	je scan_esc
	cmp dl,8
	je scan_backspace
	cmp dl,13
	je scan_end
	cmp dl,' '
	je scan_space
	
	mov [si],dl
	inc si
	
	mov space,0
	mov bl,dl	;в di предпоследний символ
	mov ah,02h
	mov al,dl
	int 21h
	jmp scan_loop

scan_space:
	mov bl,dl
	mov ah,02h
	mov al,dl
	int 21h
	
	inc space
	cmp space,1
	jne scan_loop
	
	mov [si],dl
	inc si
	
	
	
	jmp scan_loop
	
scan_esc:
	cmp cx,0
	je scan_loop
	
	cycl:					;очищает строку на экране
		call backspace
	loop cycl
	
	mov cx,si				;kol букв в новой строке
	lea si,newstring		;si на начало newstring
	mov dl,' '				
	
	cycle:					;очищение newstring
		mov [si],dl
		inc si
	loop cycle
	
	xor bx,bx				;очищаем предпоследний символ в di
	lea si,newstring		;si на начало newstring
jmp scan_loop	
	
scan_backspace:
	cmp cx,0
	je scan_loop
	
	call backspace
	cmp bl,' '
	jne delite
	dec space
	cmp space,0
	jne scan_loop
	delite:
		push bx
		mov bl,' '
		dec si
		mov [si],bl
		pop bx
		
		mov space,0
jmp scan_loop

	
scan_end:
	
	mov [si]," $"
	
	mov Ah,09h
	mov dx,offset end_of_string
	int 21h
	
	pop dx
	pop cx
	pop ax
	ret 
endp scan_num 
;/////////////////////////////////////////////////////


;########################################################
start:

	mov ax, @DATA
	mov ds, ax
	
	mov Ah,09h
	mov dx,offset ent_1_mess
	int 21h
	
	call scan_num
	
	mov Ah,09h
	mov dx,offset ent_2_mess
	int 21h
	
	mov Ah,09h
	mov dx,offset newstring
	int 21h
	
	end_start:
	mov ah, 4ch
	int 21h

end start