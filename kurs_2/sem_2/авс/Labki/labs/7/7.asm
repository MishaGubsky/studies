.model small
.stack 1000h
.data
		zero 				dd 0.0
		two  		 		dd 2.0
		four 		 		dd 4.0

		a_coeff 	 		dd 0
		b_coeff 	 		dd 0
		c_coeff		 		dd 0
		coeff 				dd 0
		dsm_coeff			dd 0

		first_root			dd 0
		second_root			dd 0

		disrimenant_error 	db "Disrimenant below zero. No real roots$"
		a_coeff_error		db "A can't be zero$"
		enter_a_coeff_msg   db "A: $"
		enter_b_coeff_msg   db "B: $"
		enter_c_coeff_msg   db "C: $"
		roots_msg 			db "Roots are: $";

.code
.386
LOCAlS
include fio.inc


MAIN:
		mov 	AX, @data
		mov 	DS, AX

		puts 	enter_a_coeff_msg 					;Ввод коэффициента А
		scanf 	a_coeff
		puts 	enter_b_coeff_msg 					;Ввод коэффициента В
		scanf 	b_coeff
		puts 	enter_c_coeff_msg 					;Ввод коэффициента С
		scanf 	c_coeff	
		puts	string_newline


		finit
DISCRIMENANT_COUNT:
		fld 	a_coeff 							
		ftst										;Сравниваем А с нулем
		fstsw 	AX
		sahf 	
		jz 		ZERO_A_COEFF 						;Если ноль, то ошибка

		fmul 	c_coeff		 						;Вычисляем дискрименант
		fmul 	four	
		fld 	b_coeff
		fmul 	b_coeff
		fsub 	ST(0), ST(1)

		ftst 										;Сравниваем дискрименант с нулем
		fstsw 	AX
		sahf
		jc 		DISCRIMENANT_BELOW_ZERO 			;Если ноль, то ошибка

TEMP_COEFFS_COUNT:
		fsqrt 	 									;Считаем корень из дискременанта
		fld 	a_coeff
		fmul 	two
		fxch	ST(1)
		fdiv 	ST(0), ST(1)
		fstp	dsm_coeff	 						;Считаем sqrt(D)/2A
		fwait 

		fld 	b_coeff 							;Вычисляем -B/2A
		fchs
		fdiv 	ST(0), ST(1)
		fstp 	coeff

ROOTS_COUNT:
		fld 	coeff 								;Вычисляем первый корень
		fsub 	dsm_coeff
		fstp 	first_root

		fld 	coeff 								;Вычисляем второй корень
		fadd 	dsm_coeff
		fstp 	second_root
		
		fwait
		ffree

		puts 	roots_msg
		puts 	string_newline
		putf 	first_root
		puts 	string_newline
		putf 	second_root
		puts 	string_newline
		jmp 	MAIN_END


DISCRIMENANT_BELOW_ZERO:
		puts 	disrimenant_error
		jmp 	MAIN_END

ZERO_A_COEFF:
		puts 	a_coeff_error
		jmp 	MAIN_END

MAIN_END:
		mov 	AX, 4c00h
		int 	21h
end MAIN