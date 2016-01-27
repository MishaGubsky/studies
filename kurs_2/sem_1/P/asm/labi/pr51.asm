.model small
.stack 100h
.data
	ent_1_mess      db    "Enter your string",10,13,'$'
	int9_vect       dd    0
.code
org 100h

interraption proc
         push es ds si di cx bx dx ax
         in al, 60h
         mov dl, al
         add dl, '0'
         mov	ah, 2h
         int	21h
         
         pop ax dx bx cx di si ds es
         mov ax, 0
         mov     al,20H           
         out     20H,al         
         iret
interraption endp

interraptionEnd:

;########################################################
start:
	mov ax, @DATA
	mov ds, ax
	
	mov Ah,09h
	mov dx,offset ent_1_mess
	int 21h
	
		
	xor bx,bx
	xor cx,cx
	xor dx,dx
	xor di,di
	xor si,si
	
	cli
	push es
	xor ax,ax
	mov es,ax
	
	mov ax, word ptr es:[09h*4]	;смещение
	mov word ptr int9_vect, ax
	mov ax, word ptr es:[09h*4+2]	;сегмент 
	mov word ptr int9_vect+2, ax

	mov ax, cs
	mov word ptr eS:[09h*4+2], ax	;сегмент 
	mov ax, offset interraption
	mov word ptr es:[09h*4], ax	;смещение

	pop es

	sti
	
	xor ax,ax
	mov ah,31h
	mov dx,(interraptionEnd- @code +10FH)/16
	int 21h
	

end start