.model small

.486

.stack 256
	LOCALS

.data
	overflow_error        	equ 1 						;Значения ошибок. Ошибка переполнения
	underflow_error       	equ 2 						;Ошибка антипереполнения
	plus_inf_error  		equ 3 						;Плюс бесконечность
	minus_inf_error  		equ 4 						;Минус бесконечность

	enter_x_msg   			db "Enter x: $" 			;Сообщение о вводе Х
	enter_y_msg   			db "Enter y: $" 			;Сообщение о вводе У
	enter_operation_msg 	db "Enter operation: $" 	;Сообщение о вводе операции
	result_msg 				db "Result: $" 			;Сообщение о выводе результата
	
	x_num      				dd 0 						;Переменная, где храниться Х
	y_num      				dd 0 						;Переменная, где храниться У
	result 					dd 0 						;Переменная, где сохраняется результат
	error 					db 0 						;Переменная, где сохраняется значение ошибки
	order 					db 0						;Переменная, для хранения порядка числа
	sign  					dd 0 						;Переменная, для хранения знака числа	
.code
LOCALS
include Stream.inc



;......................Вывод результата............................................;
PrintResult proc
		cmp 	error, overflow_error 					;Было переполнение
		je 		RESULT_OWERFLOW 
		
		cmp 	error, underflow_error					;Было антипереполнение
		je 		RESULT_UNDERFLOW
		
		cmp 	error, plus_inf_error 				;Результат - плюс бесконечность
		je 		RESULT_PLUS_INFINITY
		
		cmp 	error, minus_inf_error 			;Результат - минус бесконечность
		je 		RESULT_MINUS_INFINITY
		
		putf 	result									;вывод числа
		puts 	string_newline
		putb 	result									;вывод в 2-ом виде
		puts 	string_newline
		ret

	
RESULT_OWERFLOW:
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

		mov 	EAX, x_num 						;Берем Х и У из памяти
		mov 	EBX, y_num
		mov 	error, false
		
		mov 	ECX, EAX 							;Проверяем Х на ноль
		and 	ECX, except_sign_bit
		cmp 	ECX, 0
		je 		ADD_RETURN_Y
		
		mov 	ECX, EBX 							;Проверяем У на ноль
		and 	ECX, except_sign_bit
		cmp 	ECX, 0
		je 		ADD_RETURN_X

		
ORDER_ADDACTION:										;Выравнивание порядков
		and 	EAX, all_order_bits 				;Получаем порядок Х
		shr 	EAX, mantissa_size 					
		mov 	ECX, EAX 							
		and 	EBX, all_order_bits 				;Получаем порядок У
		shr 	EBX, mantissa_size
		mov 	EDX, EBX 						


MANTISS_SELECT: 									;Получение мантисс
		mov 	EAX, x_num 						
		and 	EAX, all_mantissa_bits 				;Получение мантиссы Х
		or 		EAX, last_order_bit 
		mov 	EBX, y_num 						;Получение мантиссы У
		and 	EBX, all_mantissa_bits
		or 		EBX, last_order_bit


ORDERS_COMPARE:
		cmp 	ECX, EDX 							;Сравниваем порядки
		jg 		X_ORDER_GREATER 			;Прыгаем, если порядок Х больше
		jl 		Y_ORDER_GREATER 				;Прыгаем, если порядок У больше
		mov 	order, CL
		jmp 	ADD_PERFORM 			;Порядки одинаковые
		

X_ORDER_GREATER:
		mov 	order, CL 							;Сохраняем больший порядок
		sub 	ECX, EDX 							;Находим разность порядков
		shr 	EBX, CL 							;Сдвигаем мантиссу меньшего числа, теряя точность
		cmp 	EBX, 0 								;Если произошло антипереполнение, то возвращаем Х
		je 		ADD_RETURN_X
		jmp 	ADD_PERFORM


Y_ORDER_GREATER:
		mov 	order, DL 							;Аналогично действуем, если порядок Y больше
		sub 	EDX, ECX 							;Получаем разность порядков
		mov 	CL, DL 								
		shr 	EAX, CL 							;Сдвигаем мантиссу Х
		cmp 	EAX, 0 								;Антипереполнение - выводим У
		je 		ADD_RETURN_Y
		jmp	 	ADD_PERFORM


ADD_PERFORM: 							;Сложение мантисс
		mov 	ECX, x_num
		and 	ECX, sign_bit 						;Получаем знак Х
		mov 	EDX, y_num
		and 	EDX, sign_bit 						;Получаем знак У
		
		cmp 	ECX, EDX
		jl 		ADD_X_NEGATIVE 				;Если Х отрицательное
		jg 		ADD_Y_NEGATIVE 				;Если У отрицательное
		
		add 	EAX, EBX  							;Если одинаковые знаки, то просто складываем
		mov 	sign, 0 							;Получаем знак результата
		cmp 	ECX, 0  				
		je 		ADD_CHECK
		mov 	sign, 1
		jmp 	ADD_CHECK
		

ADD_X_NEGATIVE: 							;Число Х - отрицательное
		cmp 	EAX, EBX
		jg 		ADD_NEGATIVE_X_GREATER			;Если Х больше У
		mov 	sign, 0 							;Знак +
		sub 	EBX, EAX 							;Отнимаем от У значение Х
		mov 	EAX, EBX 						
		jmp 	ADD_CHECK 					
		
ADD_NEGATIVE_X_GREATER: 
		mov 	sign, 1 							;Знак отрицательный
		sub 	EAX, EBX 							;Отнимаем от Х значение У
		jmp 	ADD_CHECK


ADD_Y_NEGATIVE: 							;Если У отрицательный, то все аналогично
		cmp 	EBX, EAX 							;Сравниваем Х и У
		jg 		ADD_NEGATIVE_Y_GREATER 		;Если У больше, то прыгаем
		mov 	sign, 0 							;Знак +
		sub 	EAX, EBX 							;Отнимаем от Х значение У
		jmp 	ADD_CHECK

ADD_NEGATIVE_Y_GREATER: 						
		mov 	sign, 1 							;Знак положительный	
		sub 	EBX, EAX 							;Отнимаем от У значение Х
		mov 	EAX, EBX
		jmp 	ADD_CHECK


ADD_CHECK:
		cmp 	EAX, 0 								;Проверка мантиссы на равенство 0
		je 		ADD_RETURN_ZERO 				;Выводим 0, если так

		mov 	EBX, EAX 							;Проверка необходимости приращения порядка
		shr 	EBX, mantissa_size  				;Получаем биты слева от мантиссы
		shr 	EBX, 1
		cmp 	EBX, 0      	  					;Если там ничего нету, то порядок приращивать не нужно
		je 		ADD_NORMALIZE 					;Проводим нормализацию
		
		shr 	EAX, 1 								;Сдвигаем мантиссу враво
		add 	order, 1 							;Увеличиваем порядок
		jc 		ADD_RETURN_OVERFLOW 			;Если порядок переполнился, то произошло переполнение
		

ADD_NORMALIZE: 								;Нормализация
		mov 	EBX, EAX
		and 	EBX, all_order_bits 				
		cmp 	EBX, 0 								;Если порядок не равен 0
		jne 	ADD_RESULT						;Выводим результат
		shl 	EAX, 1 								;Сдвигаем мантиссу
		sub 	order, 1 							;Уменьшаем порядок
		jc 		ADD_RETURN_UNDERFLOW 			;Если порядок переполнился, то произошло антипереполнение
		jnc 	ADD_NORMALIZE 					 
		

ADD_RESULT: 									;Вывод результата
		and 	EAX, all_mantissa_bits 				;Убираем старший единичный бит мантиссы
		
		mov 	EBX, 0
		mov 	BL, order
		shl 	EBX, mantissa_size
		or 		EAX, EBX  							;Записываем порядок
		
		mov 	ECX, sign 							;Записываем знаковый бит
		shl 	ECX, 31 							
		or 		EAX, ECX 							
		jmp 	ADD_END
		

ADD_RETURN_Y:
		mov 	EBX, y_num
		mov 	result, EBX
		ret
	
ADD_RETURN_X:
		mov 	EAX, x_num
		mov 	result, EAX
		ret

ADD_RETURN_ZERO:
		mov 	result, 0
		ret
	
ADD_RETURN_OVERFLOW:
		mov 	error, overflow_error
		ret
	
ADD_RETURN_UNDERFLOW:
		mov 	error, underflow_error
		ret
	
ADD_END:
		mov 	result, EAX
		ret
Addition endp



;.........................Вычитание Х-У...............................;
Substruction proc
		push 	y_num 				

		xor 	y_num, sign_bit 				;Поменяли знак У
		call 	Addition 						;Сложили Х и -У

		pop 	y_num 
		ret
Substruction endp



;..........................Умножение Х*У................................;
Multiplication proc c
	uses EAX, EBX, ECX, EDX
	
		mov EAX, x_num						;Загружаем значения
		mov EBX, y_num
		mov error, false
		
		mov 	ECX, EAX 						;Проверяем Х на 0
		and 	ECX, except_sign_bit
		cmp 	ECX, 0
		je 		MULT_RETURN_ZERO
		mov 	ECX, EBX 						;Проверяем У на 0
		and 	ECX, except_sign_bit
		cmp 	ECX, 0
		je 		MULT_RETURN_ZERO
		

ORDER_ADD: 										;Сложение порядков
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
		jnz 	MULT_RETURN_UNDERFLOW 		;Если порядок равен 0, то произошло антипереполнение
		
		mov 	EDX, all_order_bits 			
		shr 	EDX, mantissa_size
		not 	EDX 
		test 	ECX, EDX
		jnz 	MULT_RETURN_OVERFLOW 		;Произошло переполнение


MANTISS_MULTIPLICATION:
		mov 	EAX, x_num					;Получение мантиссы Х
		and 	EAX, all_mantissa_bits
		or 		EAX, last_order_bit 		
		mov 	EBX, y_num 					;Получение мантиссы У
		and 	EBX, all_mantissa_bits
		or 		EBX, last_order_bit 
		mul 	EBX 							;Перемножаем мантиссы

		mov 	CX, mantissa_size
MULT_SHIFT_LOOP: 							;Округление
		shr 	EDX, 1 
		rcr 	EAX, 1 							;из edx бит->eax через cf
		loop 	MULT_SHIFT_LOOP


MULT_NORMALIZE_LOOP: 						;Нормализация
		mov 	ECX, all_mantissa_bits
		not 	ECX
		and 	ECX, EAX
		shr 	ECX, mantissa_size 
		cmp 	ECX, 1
		je 		MULT_RESULT  				;Слева от мантиссы осталась еденица

		shr 	EAX, 1 							;Сдвигаем мантиссу
		add 	order, 1 						;Увеличиваем порядок
		jc 		MULT_RETURN_OVERFLOW 
		jmp 	MULT_NORMALIZE_LOOP


MULT_RESULT:
		and 	EAX, all_mantissa_bits 			;Убираем первую единицу
		
		mov 	EBX, 0
		mov 	BL, order
		shl 	EBX, mantissa_size
		or 		EAX, EBX 						;Записываем порядок
		
		mov 	ECX, x_num
		xor 	ECX, y_num
		and 	ECX, sign_bit
		or 		EAX, ECX 						;Записываем знаковый бит
		jmp 	MULT_END
		

MULT_RETURN_ZERO:
		mov result, 0
		ret
	
MULT_RETURN_OVERFLOW:
		mov error, overflow_error
		ret
	
MULT_RETURN_UNDERFLOW:
		mov error, underflow_error
		ret
	
MULT_END:
		mov result, EAX
		ret
Multiplication endp



;..........................Деление X на У...............................;
Division proc c
	uses EAX, EBX, ECX, EDX
		
		mov 	EAX, x_num 						;Загрузка Х и У
		mov 	EBX, y_num
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
		mov 	EAX, x_num						;Получение мантиссы Х
		and 	EAX, all_mantissa_bits
		or 		EAX, last_order_bit 
		
		mov 	EBX, y_num						;Получение мантиссы У
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
		
		mov 	ECX, x_num
		xor 	ECX, y_num
		and 	ECX, sign_bit
		or 		EAX, ECX 							;Записываем знаковый бит
		jmp 	DIVISION_END
		

DIVISION_RETURN_ZERO:
		mov 	result, 0
		ret
	
DIVISION_NORMALIZE_OVERFLOW:
		mov 	error, overflow_error
		jmp 	ADD_RETURN_ZERO
	
DIVISION_RETURN_UNDERFLOW:
		mov 	error, underflow_error
		jmp 	ADD_RETURN_ZERO
	
DIVISION_RETURN_PLUS_INFINITY:
		mov 	error, plus_inf_error
		ret
	
DIVISION_RETURN_MINUS_INFINITY:
		mov 	error, minus_inf_error
		ret
	
DIVISION_END:
		mov result, EAX
		ret
Division endp

;#####################################################################################

MAIN:		
		mov 	AX, @data
		mov 	DS, AX
			
		puts 	enter_x_msg				;вывод строки ввода х
		scanf 	x_num				;ввод х
		putb 	x_num				;вывод х в 2-ом виде
		puts 	string_newline			;перевод стр
		
		puts 	enter_y_msg				;аналогично
		scanf 	y_num
		putb 	y_num
		puts 	string_newline

		puts 	enter_operation_msg		;вывод строки операции

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
		puts 	result_msg
		call 	PrintResult

		mov AX, 4c00h
		int 21h
end MAIN