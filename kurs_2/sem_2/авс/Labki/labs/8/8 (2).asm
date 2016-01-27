.model small
.stack 1000h
.data
		max_count	 		dd 1000
		eps 				dd 0.000001
		_a 					dd 0
		_b					dd 0
		_step				dd 0
		_x					dd 0
		row_value 			dw 0
		fun_value 			dd 0
		partical_sum	 	dd 0
		i	 				dd 0
		sum	 				dd 0
		fact				dd 0


		enter_a_msg			db "Interval start A: $"
		enter_b_msg 		db "Interval end B: $"
		enter_step_msg  	db "Step H: $"
		enter_eps_msg 		db "Epsilon eps: $"
		table_header	 	db "     x:         F(x):         S(x):     n:     ", 10, 13, '$'

		_step_err   	    db "Step must be greater than null", 10, 13, '$'
		_b_err		 	    db "A must be less than B", 10, 13, '$'
.code
.386
LOCALS

include stream.inc

FunctionValue proc
	fld _x
	fcos
	
	fldl2e				;вычисление exp(cos(x))
    fmul				
    fld st
    frndint				;округление
    fsub st(1), st
    fxch st(1)
    f2xm1				;2^m-1
    fld1				;st(0)->1
    fadd
    fscale				;возведение в степень
    fstp st(1)
	
	fld _x
	fsin
	fcos
	fmul st(0),st(1)
	
	fstp fun_value
	fwait
ret
endp FunctionValue

;################################################################

RowValue proc
push ax
save_fpu_state 	

	mov sum,1
	fld1
	fstp fact
	
	fld1
	fstp i
	
	go_sum:
		fld _x 
		fld i
		fmulp
		fcos 					;cos(i*x)
		
		fld fact 
		fdiv st(1),st			;cos(ix)/fact
		fst partical_sum
	
	fld sum
	fadd 						;partical_sum
	fst sum 
	
	;fld sum
	fsub fun_value
	fabs 
	
	fcomp eps
	fstsw ax
	fwait
    sahf
    jz loop_continue
	jc go_out
	
loop_continue:
    ;fld i						; i + 1
	fld1
    fadd i
	fstp i

	fld fact 
	fmul
	fstp fact
	jmp go_sum
	
go_out:
	load_fpu_state
pop ax
ret
endp RowValue



;############################################################33


main:

	mov 	AX, @data
	mov 	DS, AX

	puts 	enter_a_msg
	scanf 	_a

	puts 	enter_b_msg 
	scanf 	_b
		
	puts 	enter_step_msg
	scanf 	_step

	puts 	enter_eps_msg
	scanf 	eps
		
	finit
	fld _step
	ftst
	fstsw ax
	sahf
	jc step_error
	je step_error
	fst _step
		
	fld _a
	fcom _b
	fstsw ax
	sahf
	jnc b_err
		
	puts table_header
go_loop:
	fst _x
	
	puts 	string_whitespace 	
	putf 	_x
	puts 	string_whitespace 
	call 	FunctionValue
	putf 	fun_value
	puts 	string_whitespace
	call 	RowValue
	putf	sum
	puts 	string_whitespace
	putf	i
	puts 	string_whitespace
	puts 	string_newline
	
	fld 	_x		 							;Добавление к Х шага
	fadd 	_step
	fcom 	_b
	fstsw	AX
	fwait
	sahf 	
	jnc 	main_end							;Проверка на границу
	jmp 	go_loop
	
	
		
b_err:
	puts _b_err
	jmp main_end
		
step_error:
	puts _step_err
	jmp main_end
		
		
main_end:
		mov 	AX, 4c00h
		int 	21h
end MAIN