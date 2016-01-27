.model small
.stack 1000h
.data
		max_iter_count 		equ 1000
		eps 				dd 0.000001
		two 				dd 2.0
		interval_start 		dd 0
		interval_end		dd 0
		interval_step		dd 0
		current_x			dd 0
		sum_value 			dd 0
		function_value 		dd 0
		index 				dw 0
		coeff 				dd 0


		enter_int_start_msg db "Interval start A: $"
		enter_int_end_msg 	db "Interval end B: $"
		enter_int_step_msg  db "Step H: $"
		enter_int_eps_msg 	db "Epsilon eps: $"
		table_header_msg 	db "     x:         F(x):         S(x):     ", 10, 13, '$'

		interval_step_err   db "Step must be greater than null", 10, 13, '$'
		interval_bounds_err db "A must be less than B", 10, 13, '$'
.code
.386
LOCALS
include fio.inc


;..........................Подсчет суммы ряда....................;
CountSummValue proc
		push	AX CX
		save_fpu_state 								;Сохранение состояния сопроцессора

		fld1 	
		fld 	current_x 							;Вычисление Х+1
		faddp 	

		fld1 			
		fld 	current_x 							;Вычисление Х-1
		fsubrp

		fdivrp 										;Вычисление (Х-1)/(Х+1)
		fstp	coeff 								;Сохранение в соeff

		mov 	index, 1
		mov 	sum_value, 0	
SUM_VALUE_COUNT:
		fld1	
		mov 	CX, index

SCALE_SUM_VALUE:
		fmul	coeff 								;Вычисление ((Х-1)/(Х+1))^(2*k+1)
		loop 	SCALE_SUM_VALUE

		fild 	index 								;Деление на 2*k+1
		fdivp
		fadd 	sum_value 							
		fst		sum_value

		fsub 	function_value 						;Проверка на удовлетворение точности
		fabs 
		fcomp 	eps
		fstsw 	AX
		fwait
		sahf
		jz 		@@LOOP_CONTINUE
		jc 		@@PROC_END

@@LOOP_CONTINUE:
		add 	index, 2 							;Проверка количества итераций
		cmp		index, max_iter_count
		jb 		SUM_VALUE_COUNT


@@PROC_END:
		load_fpu_state 								;Загрузка состояния сопроцессора
		pop 	CX AX
		ret
endp	CountSummValue



CountFunctionValue proc
		save_fpu_state 			

		fld 	current_x
		fldln2
		fdiv 	two
		fxch	ST(1)
		fyl2x 										;Вычисление ln(x) = ln(2)*log(x)
		fstp 	function_value
		fwait

		load_fpu_state
		ret
endp 	CountFunctionValue



MAIN:
		mov 	AX, @data
		mov 	DS, AX
		
		puts 	enter_int_start_msg
		scanf 	interval_start

		puts 	enter_int_end_msg 
		scanf 	interval_end
		
		puts 	enter_int_step_msg
		scanf 	interval_step

		puts 	enter_int_eps_msg
		scanf 	eps


		finit
		fld 	interval_step
		ftst
		fstsw 	AX
		fwait
		sahf
		jc 		ZERO_INTERVAL_STEP
		je 	 	ZERO_INTERVAL_STEP
		fst 	interval_step 								;Проверка шага

		fld 	interval_start
		fcom 	interval_end
		fstsw	AX
		fwait
		sahf 
		jnc 	INTERVAL_END_ERR 							;Проверка границ интервала

		puts 	table_header_msg
COUNTING_LOOP:
		fst 	current_x
		fwait
		
		puts 	string_whitespace 	
		putf 	current_x
		puts 	string_whitespace
		call	CountFunctionValue 							;Вычисление суммы ряда
		putf 	function_value
		puts 	string_whitespace
		call 	CountSummValue 								;Вычисление функции
		putf 	sum_value
		puts 	string_whitespace
		puts 	string_newline

		fld 	current_x		 							;Добавление к Х шага
		fadd 	interval_step
		fcom 	interval_end
		fstsw	AX
		fwait
		sahf 	
		jnc 	LOOP_OUT 									;Проверка на границу
		jmp 	COUNTING_LOOP


LOOP_OUT:
		jmp 	MAIN_END

ZERO_INTERVAL_STEP:
		puts 	interval_step_err
		jmp 	MAIN_END

INTERVAL_END_ERR:
		puts 	interval_bounds_err
		jmp 	MAIN_END

MAIN_END:
		mov 	AX, 4c00h
		int 	21h
end MAIN