.model small
.stack 100h
.data
a dw 7
b dw 8
c dw 9
d dw 10
.code
start:

mov ax, @DATA
mov ds, ax


xor dx,dx  ; dx=0;

mov ax, a
mul ax    ;ax=a^2

mov cx, ax   ; cx=ax

div b  ;  ax/b
mov bx, ax  


xor dx,dx  ; dx=0;

mov ax, c
mul ax     ; ax= c^2

div d   ; ax=ax/d;

cmp ax, bx  ; ax>bx
jc label_1
mov bx, ax    
label_1:




mov ax,b
mul ax   ; ax=b^2

cmp ax, cx
jc label_2
mov cx, ax   ; cx>ax
label_2:


mov ax,a
mul c   ; ax=ax*c

cmp cx, ax
jc label_3
mov ax, cx  ; ax>cx
label_3:


add ax, bx   ; ax=ax+bx


mov ah, 4ch
int 21h

end start