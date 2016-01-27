.model small
.stack 100h
.data
	ent_1_mess     db    "Enter number of rows",10,13,'$'
	ent_2_mess     db    "Enter number of col",10,13,'$'
	ent_3_mess     db    "Enter matrix",10,13,'$'

	output_1_mess  db    "min elements $"

	plus		   db	 0
	minus		   dw    0
	N			   dw    1
	M	   		   dw    1
	min_num        dw    32767,'$'
	
	mas_min		   dw    1000 dup(' ')
	;mas       	   dw    1000 dup(0)
	
	enum_N		   dw    0
	enum_M 		   dw    0
	min_sgn		   dw    0
	end_str		   db    '$'
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
	mov di,minus
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
	
	mov minus,0
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
	je temp1
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
	
	temp:
	jmp scan_loop
	
	temp1:
	jmp scan_end
	
scan_esc:
	cmp bx,0
	jne delite
		mov minus,0
	delite:
		call backspace
		call sub_num
	cmp bx,0
	jne scan_esc
	mov di,minus
	cmp di,1
	je scan_esc
jmp scan_loop	
	
scan_backspace:
	cmp bx,0
	jne do
	mov minus,0
	mov plus,0
	do:
	call backspace
	call sub_num
	jmp scan_loop

scan_minus:
	cmp minus,1
	je scan_loop
	mov minus, 1
	mov ah,02h
	mov dl,45
	int 21h
	jmp scan_loop	
	
scan_plus:
	cmp plus,1
	je temp
	mov plus, 1
	mov ah,02h
	mov dl,'+'
	int 21h
	jmp scan_loop	
	
scan_end:
	

	
	mov di,minus
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

;mov ah,02h
;mov dl,10
;int 21h

;mov ah,02h
;mov dl,13
;int 21h

pop cx
pop ax
pop dx
ret
endp print_num
;////////////////////////////////////////////////////////




;///////////////////////////////////////////////////////
min proc
push bx
push di
push ax

mov di,minus
mov ax,min_sgn
cmp di,ax	;сравнение на знак
jc end_min

cmp di,min_sgn	;если мин положит, а ди отриц->negative
jne negative

mov ax,min_num
cmp ax, bx	;сравнение числа с минимумом
jc end_min

negative:
mov min_num,bx	;в min_num закидываем bx	
mov min_sgn,di	;закидываем знак в min_sgn
end_min:

pop ax
pop di
pop bx
ret
endp min
;///////////////////////////////////////////////////////////////





;////////////////////////////////////////////////////////////
E_mass proc 
push cx
push si
push di;/////////////////////////////////

mov enum_M,0
mov enum_N,0
xor si,si


E_loop:
call scan_num   ;сканируем число
call min		;проверяем на минимум
inc enum_M		;указатель на след число

mov dl,' '
mov ah,02h
int 21h

mov bx,enum_M		
cmp bx,M	;проверка на конец строки
jc E_loop	;///////////////

mov bx, min_num	
mov mas_min[si],bx	;закидываем в вектор минимумов min_num
mov min_num,32767
mov min_sgn,0
mov enum_M,0

mov ah,02h  ;переходим на след строчку на экране
mov dl,10	;
int 21h		;
mov ah, 02h	;
mov dl,13	;
int 21h		;

add si,2		;указатель на след сточку
inc enum_N
mov ax,enum_N
cmp ax,N	;проверка на след срочку
jc E_loop

pop di
pop si
pop cx
ret 
endp E_mass 

;////////////////////////////////////////////////////////////


print proc
push ax
push cx
push si

xor si,si
mov cx,N
loop_print:
mov bx,mas_min[si]
call print_num
mov dl,' '
mov ah,02h
int 21h
add si,2
loop loop_print

pop si
pop cx
pop ax
ret
print endp


;########################################################
start:

	mov ax, @DATA
	mov ds, ax
	
	mov Ah,09h
	mov dx,offset ent_1_mess
	int 21h
	call scan_num
	mov N,bx
	
	mov ah,02h
	mov dl,10
	int 21h
	mov ah, 02h
	mov dl,13
	int 21h
	
	
	mov Ah,09h
	mov dx,offset ent_2_mess
	int 21h
	call scan_num
	mov M,bx
	
	mov ah,02h
	mov dl,10
	int 21h
	mov ah, 02h
	mov dl,13
	int 21h
	
	mov Ah,09h
	mov dx,offset ent_3_mess
	int 21h
	call E_mass

	mov ah, 02h
	mov dl,13
	int 21h

	mov Ah,09h
	mov dx,offset output_1_mess
	int 21h
	
	mov ah,02h
	mov dl,10
	int 21h
	mov ah, 02h
	mov dl,13
	int 21h
	
	call print
	
	
	
	end_start:
	mov ah, 4ch
	int 21h

end start