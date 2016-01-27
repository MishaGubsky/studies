.model small

.486

.stack 256
	LOCALS

.data
	overflow_error        	equ 1 						;Значения ошибок. Ошибка переполнения
	underflow_error       	equ 2 						;Ошибка антипереполнения
	plus_infinity_error  	equ 3 						;Плюс бесконечность
	minus_infinity_error  	equ 4 						;Минус бесконечность

	enter_x_msg   			db "Enter x_number: $" 		;Сообщение о вводе Х
	enter_y_msg   			db "Enter y_number: $" 		;Сообщение о вводе У
	enter_operation_msg 	db "Enter operation: $" 	;Сообщение о вводе операции
	print_result_msg 		db "Result is: $" 			;Сообщение о выводе результата
	
	x_number      			dd 0 						;Переменная, где храниться Х
	y_number      			dd 0 						;Переменная, где храниться У
	result 					dd 0 						;Переменная, где сохраняется результат
	error 					db 0 						;Переменная, где сохраняется значение ошибки
	order 					db 0						;Перменная, для хранения порядка числа
	sign  					dd 0 						;Перменная, для хранения знака числа
	pr     					db 0 				
	resmin 					db 0	
.code
LOCALS
include fio.inc



;......................Вывод результата............................................;
PrintResult proc
		cmp 	error, overflow_error 					;Было переполнение
		je 		RESULT_OEWRFLOW 
		
		cmp 	error, underflow_error					;Было антипереполнение
		je 		RESULT_UNDERFLOW
		
		cmp 	error, plus_infinity_error 				;Результат - плюс бесконечность
		je 		RESULT_PLUS_INFINITY
		
		cmp 	error, minus_infinity_error 			;Результат - минус бесконечность
		je 		RESULT_MINUS_INFINITY
		
		putf 	result
		puts 	string_newline
		putb 	result
		puts 	string_newline
		ret

	
RESULT_OEWRFLOW:
		puts 	string_overflow 					
		puts 	string_newline
		ret
	
RESULT_UNDERFLOW:
		puts 	string_underflow
		puts 	string_newline
		ret
	
RESULT_PLUS_INFINITY:
		puts 	string_plus_infinity
		puts 	string_newline
		ret
		
RESULT_MINUS_INFINITY:
		puts 	string_minus_infinity
		puts 	string_newline
		ret
PrintResult endp



;................................Сумма X+Y................................:
Addition proc c
		uses EAX, EBX, ECX, EDX

		mov 	EAX, x_number 						;Берем Х и У из памяти
		mov 	EBX, y_number
		mov 	error, false
		
		mov 	ECX, EAX 							;Проверяем Х на ноль
		and 	ECX, except_sign_bit
		cmp 	ECX, 0
		je 		ADDITION_RETURN_Y
		
		mov 	ECX, EBX 							;Проверяем У на ноль
		and 	ECX, except_sign_bit
		cmp 	ECX, 0
		je 		ADDITION_RETURN_X

		
ORDER_ALIGN:										;Выравнивание порядков
		and 	EAX, all_order_bits 				;Получаем порядок Х
		shr 	EAX, mantissa_size 					
		mov 	ECX, EAX 							
		and 	EBX, all_order_bits 				;Получаем порядок У
		shr 	EBX, mantissa_size
		mov 	EDX, EBX 						


MANTISS_SELECT: 									;Получение мантисс
		mov 	EAX, x_number 						
		and 	EAX, all_mantissa_bits 				;Получение мантиссы Х
		or 		EAX, last_order_bit 
		mov 	EBX, y_number 						;Получение мантиссы У
		and 	EBX, all_mantissa_bits
		or 		EBX, last_order_bit


COMPARE_ORDERS:
		cmp 	ECX, EDX 							;Сравниваем порядки
		jg 		ADDITION_X_ORDER_GREATER 			;Прыгаем, если порядок Х больше
		jl 		ADDITION_X_ORDER_LESS 				;Прыгаем, если порядок У больше
		mov 	order, CL
		jmp 	ADDITION_PERFORM_ADDITION 			;Порядки одинаковые
		

ADDITION_X_ORDER_GREATER:
		mov 	order, CL 							;Сохраняем больший порядок
		sub 	ECX, EDX 							;Находим разность порядков
		shr 	EBX, CL 							;Сдвигаем мантиссу меньшего числа, теряя точность
		cmp 	EBX, 0 								;Если произошло антипереполнение, то возвращаем Х
		je 		ADDITION_RETURN_X
		jmp 	ADDITION_PERFORM_ADDITION


ADDITION_X_ORDER_LESS:
		mov 	order, DL 							;Аналогично действуем, если порядок Y больше
		sub 	EDX, ECX 							;Получаем разность порядков
		mov 	CL, DL 								
		shr 	EAX, CL 							;Сдвигаем мантиссу Х
		cmp 	EAX, 0 								;Антипереполнение - выводим У
		je 		ADDITION_RETURN_Y
		jmp	 	ADDITION_PERFORM_ADDITION


ADDITION_PERFORM_ADDITION: 							;Сложение мантисс
		mov 	ECX, x_number
		and 	ECX, sign_bit 						;Получаем знак Х
		mov 	EDX, y_number
		and 	EDX, sign_bit 						;Получаем знак У
		
		cmp 	ECX, EDX
		jl 		ADDITION_X_IS_NEGATIVE 				;Если Х отрицательное
		jg 		ADDITION_Y_IS_NEGATIVE 				;Если У отрицательное
		
		add 	EAX, EBX  							;Если одинаковые знаки, то просто складываем
		mov 	sign, 0 							;Получаем знак результата
		cmp 	ECX, 0  				
		je 		ADDITION_CHECK
		mov 	sign, 1
		jmp 	ADDITION_CHECK
		

ADDITION_X_IS_NEGATIVE: 							;Число Х - отрицательное
		cmp 	EAX, EBX
		jg 		ADDITION_NEGATIVE_X_GREATER			;Если Х больше У
		mov 	sign, 0 							;Знак +
		sub 	EBX, EAX 							;Отнимаем от У значение Х
		mov 	EAX, EBX 						
		jmp 	ADDITION_CHECK 					
		
ADDITION_NEGATIVE_X_GREATER: 
		mov 	sign, 1 							;Знак отрицательный
		sub 	EAX, EBX 							;Отнимаем от Х значение У
		jmp 	ADDITION_CHECK


ADDITION_Y_IS_NEGATIVE: 							;Если У отрицательный, то все аналогично
		cmp 	EBX, EAX 							;Сравниваем Х и У
		jg 		ADDITION_NEGATIVE_Y_GREATER 		;Если У больше, то прыгаем
		mov 	sign, 0 							;Знак +
		sub 	EAX, EBX 							;Отнимаем от Х значение У
		jmp 	ADDITION_CHECK

ADDITION_NEGATIVE_Y_GREATER: 						
		mov 	sign, 1 							;Знак положительный	
		sub 	EBX, EAX 							;Отнимаем от У значение Х
		mov 	EAX, EBX
		jmp 	ADDITION_CHECK


ADDITION_CHECK:
		cmp 	EAX, 0 								;Проверка мантиссы на равенство 0
		je 		ADDITION_RETURN_ZERO 				;Выводим 0, если так

		mov 	EBX, EAX 							;Проверка необходимости приращения порядка
		shr 	EBX, mantissa_size  				;Получаем биты слева от мантиссы
		shr 	EBX, 1
		cmp 	EBX, 0      	  					;Если там ничего нету, то порядок приращивать не нужно
		je 		ADDITION_NORMALIZE 					;Проводим нормализацию
		
		shr 	EAX, 1 								;Сдвигаем мантиссу враво
		add 	order, 1 							;Увеличиваем порядок
		jc 		ADDITION_RETURN_OVERFLOW 			;Если порядок переполнился, то произошло переполнение
		

ADDITION_NORMALIZE: 								;Нормализация
		mov 	EBX, EAX
		and 	EBX, all_order_bits 				
		cmp 	EBX, 0 								;Если порядок не равен 0
		jne 	ADDITION_RESULT						;Выводим результат
		shl 	EAX, 1 								;Сдвигаем мантиссу
		sub 	order, 1 							;Уменьшаем порядок
		jc 		ADDITION_RETURN_UNDERFLOW 			;Если порядок переполнился, то произошло антипереполнение
		jnc 	ADDITION_NORMALIZE 					 
		

ADDITION_RESULT: 									;Вывод результата
		and 	EAX, all_mantissa_bits 				;Убираем старший единичный бит мантиссы
		
		mov 	EBX, 0
		mov 	BL, order
		shl 	EBX, mantissa_size
		or 		EAX, EBX  							;Записываем порядок
		
		mov 	ECX, sign 							;Записываем знаковый бит
		shl 	ECX, 31 							
		or 		EAX, ECX 							
		jmp 	ADDITION_END
		

ADDITION_RETURN_Y:
		mov 	EBX, y_number
		mov 	result, EBX
		ret
	
ADDITION_RETURN_X:
		mov 	EAX, x_number
		mov 	result, EAX
		ret

ADDITION_RETURN_ZERO:
		mov 	result, 0
		ret
	
ADDITION_RETURN_OVERFLOW:
		mov 	error, overflow_error
		ret
	
ADDITION_RETURN_UNDERFLOW:
		mov 	error, underflow_error
		ret
	
ADDITION_END:
		mov 	result, EAX
		ret
Addition endp



;.........................Вычитание Х-У...............................;
Substruction proc
		push 	y_number 				

		xor 	y_number, sign_bit 				;Поменяли знак У
		call 	Addition 						;Сложили Х и -У

		pop 	y_number 
		ret
Substruction endp



;..........................Умножение Х*У................................;
Multiplication proc c
	uses EAX, EBX, ECX, EDX
	
		mov EAX, x_number						;Загружаем значения
		mov EBX, y_number
		mov error, false
		
		mov 	ECX, EAX 						;Проверяем Х на 0
		and 	ECX, except_sign_bit
		cmp 	ECX, 0
		je 		MULTIPLY_RETURN_ZERO
		mov 	ECX, EBX 						;Проверяем У на 0
		and 	ECX, except_sign_bit
		cmp 	ECX, 0
		je 		MULTIPLY_RETURN_ZERO
		

ORDER_ADDITION: 								;Сложение порядков
		and 	EAX, all_order_bits 			;Находим порядок Х
		shr 	EAX, mantissa_size
		mov 	ECX, EAX 
		and 	EBX, all_order_bits 			;Находим порядок У
		shr 	EBX, mantissa_size
		mov 	EDX, EBX 

		add 	ECX, EDX 						;Складываем порядки
		sub 	ECX, 127 						;Отнимаем смещение
		mov 	order, CL 						;Сохраняем порядок
		
		test 	ECX, first_bit
		jnz 	MULTIPLY_RETURN_UNDERFLOW 		;Если порядок равен 0, то произошло антипереполнение
		
		mov 	EDX, all_order_bits 			
		shr 	EDX, mantissa_size
		not 	EDX 
		test 	ECX, EDX
		jnz 	MULTIPLY_RETURN_OVERFLOW 		;Произошло переполнение


MANTISS_MULTIPLICATION:
		mov 	EAX, x_number					;Получение мантиссы Х
		and 	EAX, all_mantissa_bits
		or 		EAX, last_order_bit 		
		mov 	EBX, y_number 					;Получение мантиссы У
		and 	EBX, all_mantissa_bits
		or 		EBX, last_order_bit 
		mul 	EBX 							;Перемножаем мантиссы

		mov 	CX, mantissa_size
MULTIPLY_SHIFT_LOOP: 							;Округление
		shr 	EDX, 1 
		rcr 	EAX, 1 
		loop 	MULTIPLY_SHIFT_LOOP


MULTIPLY_NORMALIZE_LOOP: 						;Нормализация
		mov 	ECX, all_mantissa_bits
		not 	ECX
		and 	ECX, EAX
		shr 	ECX, mantissa_size 
		cmp 	ECX, 1
		je 		MULTIPLY_RESULT  				;Слева от мантиссы осталась еденица

		shr 	EAX, 1 							;Сдвигаем мантиссу
		add 	order, 1 						;Увеличиваем порядок
		jc 		MULTIPLY_RETURN_OVERFLOW 
		jmp 	MULTIPLY_NORMALIZE_LOOP


MULTIPLY_RESULT:
		and 	EAX, all_mantissa_bits 			;Убираем первую единицу
		
		mov 	EBX, 0
		mov 	BL, order
		shl 	EBX, mantissa_size
		or 		EAX, EBX 						;Записываем порядок
		
		mov 	ECX, x_number
		xor 	ECX, y_number
		and 	ECX, sign_bit
		or 		EAX, ECX 						;Записываем знаковый бит
		jmp 	MULTIPLY_END
		

MULTIPLY_RETURN_ZERO:
		mov result, 0
		ret
	
MULTIPLY_RETURN_OVERFLOW:
		mov error, overflow_error
		ret
	
MULTIPLY_RETURN_UNDERFLOW:
		mov error, underflow_error
		ret
	
MULTIPLY_END:
		mov result, EAX
		ret
Multiplication endp



;..........................Деление X на У...............................;
Division proc c
	uses EAX, EBX, ECX, EDX
		
		mov 	EAX, x_number 						;Загрузка Х и У
		mov 	EBX, y_number
		mov 	error, false
		
		mov 	ECX, EAX 							;Проверка Х на 0
		and 	ECX, except_sign_bit
		cmp 	ECX, 0
		je 		DIVISION_RETURN_ZERO
		
		mov 	ECX, EBX 							;Проверка У на 0
		and 	ECX, except_sign_bit
		cmp 	ECX, 0
		jne 	ORDER_SUBSTRUCTION

		mov 	ECX, EBX 							
		xor 	ECX, EAX
		test 	ECX, sign_bit
		jz 		DIVISION_RETURN_PLUS_INFINITY 		;Если Х положительный, то результат +бесконечность
		jnz 	DIVISION_RETURN_MINUS_INFINITY		;Иначе -бесконечность


ORDER_SUBSTRUCTION:
		and 	EAX, all_order_bits 				;Нахождение порядка Х 
		shr 	EAX, mantissa_size 
		mov 	ECX, EAX 
		and 	EBX, all_order_bits 				;Нахождение порядка У
		shr 	EBX, mantissa_size
		mov 	EDX, EBX 
		sub 	ECX, EDX 							;Вычитаем порядки
		add 	ECX, 127 							;Добавляем смещение
		mov 	order, CL
		
		test 	ECX, first_bit
		jnz 	DIVISION_RETURN_UNDERFLOW 			;Произошло антипереполнение
		mov 	EDX, all_order_bits
		shr 	EDX, mantissa_size
		not 	EDX 							
		test 	ECX, EDX
		jnz 	DIVISION_NORMALIZE_OVERFLOW			;Произошло переполнение


MANTISS_DIVISION:
		mov 	EAX, x_number						;Получение мантиссы Х
		and 	EAX, all_mantissa_bits
		or 		EAX, last_order_bit 
		
		mov 	EBX, y_number						;Получение мантиссы У
		and 	EBX, all_mantissa_bits
		or 		EBX, last_order_bit 

		xor 	EDX, EDX
		mov 	ECX, mantissa_size 					;Сдвигаем мантиссу
DIVISION_SHIFT_LOOP:
		sal 	EAX, 1
		rcl 	EDX, 1
		loop 	DIVISION_SHIFT_LOOP
		div EBX 									;Делим мантиссы


DIVISION_NORMALIZE_LOOP:							;Нормализация
		mov 	ECX, all_mantissa_bits
		not 	ECX
		and 	ECX, EAX
		shr 	ECX, mantissa_size 
		cmp 	ECX, 1
		je 		DIVISION_RESULT 					;Если слева от мантиссы единица, то выводим результат

		shl 	EAX, 1 								;Сдвигаем мантиссу
		sub 	order, 1 							;Увеличиваем порядок
		jc 		DIVISION_RETURN_UNDERFLOW ; 
		jmp 	DIVISION_NORMALIZE_LOOP
	

DIVISION_RESULT:
		and 	EAX, all_mantissa_bits  			;Убираем старшую единицу
		
		mov 	EBX, 0
		mov 	BL, order
		shl 	EBX, mantissa_size
		or 		EAX, EBX 							;Записываем порядок
		
		mov 	ECX, x_number
		xor 	ECX, y_number
		and 	ECX, sign_bit
		or 		EAX, ECX 							;Записываем знаковый бит
		jmp 	DIVISION_END
		

DIVISION_RETURN_ZERO:
		mov 	result, 0
		ret
	
DIVISION_NORMALIZE_OVERFLOW:
		mov 	error, overflow_error
		jmp 	ADDITION_RETURN_ZERO
	
DIVISION_RETURN_UNDERFLOW:
		mov 	error, underflow_error
		jmp 	ADDITION_RETURN_ZERO
	
DIVISION_RETURN_PLUS_INFINITY:
		mov 	error, plus_infinity_error
		ret
	
DIVISION_RETURN_MINUS_INFINITY:
		mov 	error, minus_infinity_error
		ret
	
DIVISION_END:
		mov result, EAX
		ret
Division endp

;#####################################################################################

MAIN:		
		mov 	AX, @data
		mov 	DS, AX
			
		puts 	enter_x_msg
		scanf 	x_number
		putb 	x_number
		puts 	string_newline

		puts 	enter_y_msg
		scanf 	y_number
		putb 	y_number
		puts 	string_newline

		puts 	enter_operation_msg

SCANNING_OPERATION_LOOP:
		mov 	AH, 07h
		int 	21h
		mov 	DL, AL

		cmp 	DL, '+'
		je 		PERFORM_ADDITION
		cmp 	DL, '-'
		je 		PERFORM_SUBSTRUCTION
		cmp 	DL, '*'
		je 		PERFORM_MULTIPLICATION
		cmp 	DL, '/'
		je 		PERFORM_DIVISION
		jmp 	SCANNING_OPERATION_LOOP


PERFORM_ADDITION:
		mov 	AH, 02h
		int 	21h
		puts 	string_newline

		call 	Addition
		jmp 	PRINT_RESULT

PERFORM_SUBSTRUCTION:
		mov 	AH, 02h
		int 	21h
		puts 	string_newline

		call 	Substruction
		jmp 	PRINT_RESULT

PERFORM_MULTIPLICATION: 
		mov 	AH, 02h
		int 	21h
		puts 	string_newline

		call 	Multiplication
		jmp 	PRINT_RESULT

PERFORM_DIVISION:
		mov 	AH, 02h
		int 	21h
		puts 	string_newline

		call 	Division
		jmp 	PRINT_RESULT


PRINT_RESULT:
		puts 	string_newline
		puts 	print_result_msg
		call 	PrintResult

		mov AX, 4c00h
		int 21h
end MAIN