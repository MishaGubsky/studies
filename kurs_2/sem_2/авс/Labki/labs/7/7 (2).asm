.model small
.stack 1000h
.data
		zero 				dd 0.0
		two  		 		dd 2.0
		four 		 		dd 4.0

		_a		 	 		dd 0
		_b 	 				dd 0
		_c		 			dd 0
		dsc_right 			dd 0
		dsc_left			dd 0

		first_root			dd 0
		second_root			dd 0

		dis_error_msg 		db "Disrimenant below zero. No real roots$"
		b_error_msg			db "A and B can't be zero$"
		enter_a				db "A: $"
		enter_b  			db "B: $"
		enter_c  			db "C: $"
		roots_msg 			db "Roots are: $";
		root_msg 			db "Root is: $";

.code
.386
LOCAlS
include stream.inc

main:

	mov 	AX, @data
	mov 	DS, AX

	puts 	enter_a					;Ввод коэффициента А
	scanf 	_a
	puts 	enter_b					;Ввод коэффициента В
	scanf 	_b
	puts 	enter_c					;Ввод коэффициента С
	scanf 	_c	
	puts	string_newline
	
	finit
	
	fld _a							;загружаем _a в st(0)
	ftst							;проверка на 0
	fstsw ax
	sahf
	jz a_zero
	
Disrimenant:						;вычисляем дискрименант
	fmul _c
	fmul four						;4ac
	
	fld _b				
	fmul _b							;b^2
	fsub St(0), St(1)				;b^2-4ac
	
	ftst							;проверка на 0
	fstsw ax
	sahf
	jc dis_error					;>0
	jz dis_zero						;=0
	
Continue_seaching_roots:
	fsqrt							;sqrt(D)
	fld _a
	fmul two						;2a
	fxch st(1)
	fdiv st(0),st(1)				;sqrt(D)/2a
	fstp dsc_left
	
	fld _b							
	fchs
	fdiv st(0),st(1)				;-b/2a
	fstp dsc_right
	
Computing_roots:
	fld dsc_right					;1 root
	fsub dsc_left
	fstp first_root
	
	fld dsc_right					;2 root
	fadd dsc_left
	fstp second_root
	fwait
	ffree

	puts  roots_msg
	puts 	string_newline
	putf 	first_root
	puts 	string_newline
	putf 	second_root
	puts 	string_newline
	jmp 	main_end
	
dis_zero:							;D=0
	fld _b
	fchs
	
	fdiv two
	fdiv _a
	
	fstp first_root					;root=-b/2a
	puts root_msg
	puts string_newline
	putf first_root
	jmp main_end
	
dis_error:
	puts dis_error_msg
	jmp main_end
	
b_error:
	puts b_error_msg
	jmp main_end
	
a_zero:								;a=0
	fld _b							;проверка на b=0
	ftst
	fstsw ax
	sahf
	jz b_error
	
	fld _c
	fchs
	
	fdiv St(0),St(1)
	fstp first_root					;root=-c/b
	
	puts root_msg
	puts string_newline
	putf first_root
	jmp main_end

main_end:
		mov 	AX, 4c00h
		int 	21h
end main
	