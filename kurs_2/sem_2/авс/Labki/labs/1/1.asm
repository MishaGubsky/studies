.model small
.stack 100h
.data
	separator_str				db 	"---------------------------------------------------", 10, 13, '$'
	overflow_msg 				db 	"Overflow!!! Result is not correct", 10, 13, '$'
	enter_first_number_msg 		db 	"First number:   ", '$'
	enter_second_number_msg 	db 	"Second number:  ", '$'
	enter_operator_msg 			db 	"Opetaror(+, -): ", '$'
	print_result_msg			db 	"Result is: 	", '$'
	need_to_retry_msg			db 	"Retry?(y/n): 	 ", '$'
.code
.386
include io.inc




;--------------------Процедура суммы----------------------
Addition proc
		push	BX CX SI DI BP
		mov 	BP, SP
		mov 	SI, [BP + 14] 				;Берем из стека первое слагаемое
		mov 	DI, [BP + 12]				;Берем из стека второе слагаемое

		push 	SI
		push 	DI

		xor 	BH, BH
		xor 	CX, CX 						;В CH будем хранить перенос. В CL номер итерации
		xor 	DX, DX 						;В DX будем накапливать сумму
ADDITION_LOOP:
		xor 	AX, AX 					
		xor 	BX, BX

		shr 	SI, 1 						;Получаем младший бит первого слагаемого. Само слагаемое сдвигаем вправл
		jnb 	GET_NEXT_LOW_BIT
		mov 	AL, 1

GET_NEXT_LOW_BIT:
		shr 	DI, 1 						;Аналогично получаем младший бит второго слагаемого
		jnb		LOOP_CONTINUE				
		mov 	BL, 1

LOOP_CONTINUE:
		push 	AX 							;Запоминаем младшие биты
		push    BX
		
		xor 	AL, BL 						;Вычисляем соответсвующий бит суммы
		xor 	AL, CH 						;Учитываем перенос с предыдущего разряда
		shl		AX, CL 						;Сдвигаем его на нужное место
		or 		DX, AX 						;Устанавливаем его в DX

		pop 	BX 							;Возвращаем значения младших битов
		pop 	AX

		mov 	BH, BL 						;Вычисляем перенос в следующий разряд 						
		and 	BL, AL 						;Он есть, когда оба младших бита равны 1
		and 	AL, CH 						;Либо, когда один из них равен 1, а перенос в этот разряд тоже равен 1
		and 	CH, BH
		or 		CH, BL
		or 		CH, AL 						;Обновили перенос

		inc 	CL 							;Увеличиваем счетчик итераций
		cmp		CL, 16
		jb 		ADDITION_LOOP 	

OVERFLOW_CHECK: 							;Проверяем на переполнение
		pop 	SI
		pop 	DI
		push 	DX

		shr 	SI, 15 						;Получаем знаковые биты
		shr		DI, 15 						
		shr		DX, 15

		cmp		SI, DI 						;Если знаки слагаемых разные, то переполнения не было
		jne 	ADDITION_END
		cmp		SI, DX 						;Если знак суммы не совпал со знаком слагаемых, то переполнение случилось
		je		ADDITION_END

		mov 	AL, 1 						;Запоминаем, что было переполнение

ADDITION_END:
		pop 	DX 							;В DX - сумма. В AL - флаг переполнения
		pop 	BP DI SI CX BX
		ret
endp Addition

;-----------------------Процедура отрицания-----------------------------
Negative proc
		push 	AX CX

		xor 	CX, CX
NEGATIVE_LOOP:
		mov 	AX, 1 			
		shl 	AX, CL 						;Сдвинули единичку на нужное место
		xor 	BX, AX 						;Поменяли бит на противоположный

		inc 	CX
		cmp 	CX, 16
		jb 		NEGATIVE_LOOP

NEGATIVE_END:
		mov 	AX, 1
		push	AX
		push 	BX
		call	Addition 				 	;Добавили единичку к числу
		pop 	BX
		pop 	AX
		mov 	BX, DX	

		pop 	CX AX
		ret
endp Negative

;----------------------Процедура разности---------------------------------
Substraction proc
		push 	BX BP CX
		mov 	BP, SP
		mov 	AX, [BP + 10] 				;Взяли числа 
		mov 	BX, [BP + 8]

		call 	Negative 					;Поменяли знак у второго

		push 	AX 
		push 	BX
		call 	Addition 					;Выполнили сумму	
		pop 	BX
		pop 	CX

		cmp 	BX, 8000h 					;Проверка на случай с -32768
		jne		$+4
		mov 	AL, 1

		pop 	CX BP BX
		ret
endp	Substraction

MAIN:
		mov 	AX, @data
		mov 	DS, AX

		lea 	DX, separator_str
		call 	PrintString

		lea 	DX, enter_first_number_msg 	;Ввели первое число
		call 	PrintString 				
		call 	EnterNumber
		call 	PrintBinNumber
		push 	AX

		
		lea		DX, enter_second_number_msg	;Ввели второе число
		call 	PrintString
		call 	EnterNumber
		call 	PrintBinNumber
		push 	AX


		lea 	DX, enter_operator_msg 		;Вводим знак операции
		call 	PrintString
		mov 	AH, 08h
ENTER_OPERATOR_LOOP: 
		int 	21h
		mov 	DL, AL
		cmp 	DL, '+'
		je 		PERFORM_ADDTION
		cmp		DL, '-'
		je 		PERFORM_SUBSTRACTION
		jmp 	ENTER_OPERATOR_LOOP	

PERFORM_ADDTION: 							;Если ввели плюс, то выполняем сложение
		mov 	AH, 02h
		int 	21h
		call 	Addition
		jmp 	RESULT_OF_OPERATION
PERFORM_SUBSTRACTION: 						;Если ввели минус, то отрицание
		mov		AH, 02h
		int 	21h
		call 	Substraction 	
		jmp 	RESULT_OF_OPERATION


RESULT_OF_OPERATION:
		push 	DX
		call 	PrintNewLine
		call 	PrintNewLine
		
		cmp 	AL, 1 						;Проверяем на переполнение
		je 		OVERFLOW_CASE
		jmp 	PRINT_RESULT


OVERFLOW_CASE:
		lea 	DX, overflow_msg
		mov 	AH, 09h
		int 	21h 


PRINT_RESULT:
		pop 	AX
		lea 	DX, print_result_msg 		;Выводим результат
		call 	PrintString
		call 	PrintNumber
		call 	PrintBinNumber

		lea 	DX, need_to_retry_msg 		;Спрашиваем, нужно ли еще
		call 	PrintString
		mov 	AH, 01h
		int 	21h
		call 	PrintNewLine
		call 	PrintNewLine		
		cmp 	AL, 'y'
		je 		MAIN;

		mov 	AX, 4c00h
		int 	21h 
end MAIN
