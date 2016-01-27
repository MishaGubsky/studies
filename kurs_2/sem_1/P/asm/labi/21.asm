.model small
.stack 100h
.data 
	enter_num1_mess 		db 	"Enter first number", 10, 13, '$'
	enter_num2_mess 		db 	"Enter second number", 10, 13, '$'
	quotient_mess 			db 	"Quotient is: $"
	residue_mess			db  "Residue is: $"
	error_mess 				db 	"Error!!! Divide by zero :($"
.code

;/////////////////// Backspace /////////////////////
do_backspace proc
	push AX
	push DX

	mov DL, 8
	mov AH, 02h
	int 21h

	mov DL, 0
	mov AH, 02h
	int 21h

	mov DL, 8
	mov AH, 02h
	int 21h

	pop DX
	pop AX
	ret
endp do_backspace
;////////////////////////////////////////////////////

;//// BX - число, DL - цифра(символ) -> BX-число ////
add_num proc
	push AX
	push DX
	push CX

	mov AX, BX
	xor DH, DH
	sub DL, 48
	mov CX, DX

	mov DX, 10
	mul DX
	jc anp_END
	add AX, CX
	jc anp_END
	mov BX, AX

anp_END:
	pop CX
	pop DX
	pop AX
	ret
endp add_num
;/////////////////////////////////////////////////////

;//// BX - число -> BX-число, DL - цифра(символ) ////
sub_num proc
	push AX
	push CX

	mov AX, BX
	xor DX, DX
	mov CX, 10
	div CX
	mov BX, AX
	add DL, 48

	pop CX
	pop AX
	ret
endp sub_num
;///////////////////////////////////////////////////

;///////// -> BX - число ///////////////////////////
scan_num proc
	push AX
	push CX
	push DX

	mov BX, 0
enp_SCANING_LOOP:
	mov AH, 08h
	int 21h
	mov DL, AL

	cmp DL, 8
	je  enp_BACKSPACE
	cmp DL, 13
	je  enp_END
	cmp DL, 48
	jc enp_SCANING_LOOP
	cmp DL, 58
	jnc enp_SCANING_LOOP

	call add_num
	jc enp_SCANING_LOOP

	mov AH, 02h
	mov AL, DL
	int 21h
	jmp enp_SCANING_LOOP
 	
enp_BACKSPACE:
	call do_backspace
	call sub_num
	jmp enp_SCANING_LOOP

enp_END:
	mov AH, 02h
	mov DL, 10
	int 21h

	mov AH, 02h
	mov DL, 13
	int 21h

	pop DX
	pop CX
	pop AX
	ret
endp scan_num
;/////////////////////////////////////////

;///// BX - число -> /////////////////////
print_num proc
	push AX
	push CX
	push DX 

	xor CX, CX
pnp_LOOP:
	call sub_num
	push DX
	inc CX

	cmp BX, 0
	je  pnp_PRINT_LOOP
	jmp pnp_LOOP

pnp_PRINT_LOOP:
	pop DX
	mov AH, 02h
	int 21h
	loop pnp_PRINT_LOOP

pnp_END:
	mov AH, 02h
	mov DL, 10
	int 21h

	mov AH, 02h
	mov DL, 13
	int 21h

	pop DX
	pop CX
	pop AX
	ret
endp print_num
;////////////////////////////////////////

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
main:
	mov AX, @data
	mov DS, AX

	mov AH, 09h
	mov DX, offset enter_num1_mess;
	int 21h
	call scan_num
	push BX

	
	mov AH, 09h
	mov DX, offset enter_num2_mess;
	int 21h
	call scan_num
	cmp BX, 0
	je m_ERROR

	xor DX, DX
	pop AX
	div BX
	push DX

	mov BX, AX
	mov AH, 09h
	mov DX, offset quotient_mess;
	int 21h
	call print_num

	pop BX
	mov AH, 09h
	mov DX, offset residue_mess;
	int 21h
	call print_num
	jmp m_END

m_ERROR:
	mov AH, 09h
	mov DX, offset error_mess;
	int 21h

m_END:
	mov AX, 4c00h
	int 21h
end main
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
