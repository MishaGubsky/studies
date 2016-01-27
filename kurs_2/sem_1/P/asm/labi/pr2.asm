.model small
.stack 100h
.data
	ent_1_mess     db    "Enter first number",10,13,'$'
	ent_2_mess     db    "Enter second number",10,13,'$'
	error_mess     db    "Error! $"
	output_1_mess  db    "Attitude= $"
	output_2_mess  db    "Residue= $" 
	plus		   db	 0
.code



;/////////////////////////////////////////////////
sub_num proc
	push cx
	push ax
		
	xor dx,dx
	
	mov cx,10
	mov ax, bx
	div cx
	mov bx,ax
		
	pop ax
	pop cx
ret
endp sub_num
;////////////////////////////////////////////////


;////////////////////////////////////////////////////
add_num proc
	push cx
	push ax
	push dx
	push si

	mov si,dx
	xor dx,dx
	mov cx,10
	mov ax, bx
	mul cx
	
	jc end_add
	
	mov dx, si
	xor dh,dh
	sub dl,48
	add ax,dx
	
	jc end_add
	cmp di,1
	jne positive
	
	cmp ax,32768
	jne positive
	jmp true
	
	positive:
	test ax,ax
	js end_add
	true:
	mov bx,ax
	
	end_add:
	pop si
	pop dx
	pop ax
	pop cx
ret 
endp add_num
;///////////////////////////////////////////////////////



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
	
	xor di,di
	mov plus,0
	xor bx,bx
	
scan_loop:
	mov ah,08h
	int 21h
	mov dl, al

	cmp dl, 27
	je scan_esc
	cmp dl,8
	je scan_backspace
	cmp dl,13
	je scan_end
	cmp dl,'+'
	je scan_plus
	cmp dl, 45
	je scan_minus
	cmp dl, 48
	jc scan_loop
	cmp dl,58
	jnc scan_loop

	call add_num
	jc scan_loop
	js scan_loop
	
	mov ah,02h
	mov al,dl
	int 21h
	jmp scan_loop

	
scan_esc:
	cmp bx,0
	jne delite
		mov di,0
	delite:
		call backspace
		call sub_num
	cmp bx,0
	jne scan_esc
	cmp di,1
	je scan_esc
jmp scan_loop	
	
scan_backspace:
	cmp bx,0
	jne do
	mov di,0
	mov plus,0
	do:
	call backspace
	call sub_num
	jmp scan_loop

scan_minus:
	cmp di,1
	je scan_loop
	mov di, 1
	mov ah,02h
	mov dl,45
	int 21h
	jmp scan_loop	
	
scan_plus:
	cmp plus,1
	je scan_loop
	mov plus, 1
	mov ah,02h
	mov dl,'+'
	int 21h
	jmp scan_loop	
	
scan_end:
	mov ah,02h
	mov dl,10
	int 21h

	mov ah, 02h
	mov dl,13
	int 21h
	
	cmp di,1
	jne clean_minus
	neg bx
	clean_minus:
	
	
	
	pop dx
	pop cx
	pop ax
	ret 
endp scan_num 
;/////////////////////////////////////////////////////




;////////////////////////////////////////////////////////
print_num proc
push dx
push ax
push cx

test bx,bx
jns print_positive
mov ah,02h
mov dl,45
int 21h
neg bx
print_positive:
xor cx,cx

loop_num:
inc cx
call sub_num
add dx,48
push dx
cmp bx,0
je next_loop_num
jmp loop_num


next_loop_num:
cycle:
pop dx
mov ah,02h
int 21h
loop cycle

mov ah,02h
mov dl,10
int 21h

mov ah,02h
mov dl,13
int 21h

pop cx
pop ax
pop dx
ret
endp print_num
;////////////////////////////////////////////////////////



;########################################################
start:

	mov ax, @DATA
	mov ds, ax
	
	mov Ah,09h
	mov dx,offset ent_1_mess
	int 21h
	call scan_num
	push bx
	
	mov Ah,09h
	mov dx,offset ent_2_mess
	int 21h
	call scan_num
	
	xor dx,dx
	pop ax
	cwd
	idiv bx
	mov bx,ax
	mov cx,dx
	
	
	mov Ah,09h
	mov dx,offset output_1_mess
	int 21h
	call print_num

	mov Ah,09h
	mov dx,offset output_2_mess
	int 21h
	mov bx,cx
	call print_num
	jmp end_start
	
	
	error_num:
	mov Ah,09h
	mov dx,offset error_mess
	int 21h
	
	end_start:
	mov ah, 4ch
	int 21h

end start