.model small
.stack 100h
.data
	ent_1_mess      db    "Enter your string",10,13,'$'
	int9_vect       dd    0
.code
org 100h

interraption proc far
		 push es ds si di cx bx dx ax
		 xor ax,ax
		 xor dx,dx
		 in      al,60H             ;читать ключ
         cmp     al,1Eh  		;это кнопка вызова?	
         je      do_A                                  
         cmp     al,30h         ;это кнопка вызова?
         je      do_B
		 cmp     al,2Eh         ;это кнопка вызова?
         je      do_C
		 cmp     al,20h         ;это кнопка вызова?
         je      do_D
		 cmp     al,12h         ;это кнопка вызова?
         je      do_E
		 
		
		;mov dl,al
		;mov ah,02h
		;int 21h
		
		pop ax dx bx cx di si ds es
		jmp dword ptr cs:int9_vect 
		jmp exit
do_A:  
         mov ah,02h
		 mov dl,'z'
		 int 21h
		 jmp return
do_B:  
         mov ah,02h
		 mov dl,'y'
		 int 21h
		 jmp return
do_C:  
         mov ah,02h
		 mov dl,'x'
		 int 21h
		 jmp return
do_D:  
         mov ah,02h
		 mov dl,'w'
		 int 21h
		 jmp return
do_E:  
         mov ah,02h
		 mov dl,'v'
		 int 21h	
		 jmp return		 
		 
return:	
		pop ax dx bx cx di si ds es
	exit:	
		 mov     ax,0
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
	
	pushf
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

	sti
	
	xor ax,ax
	mov ah,31h
	mov dx,(interraptionEnd- @code +10FH)/16
	int 21h
	

end start