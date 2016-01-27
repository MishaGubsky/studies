.model small
.stack 100h
.data
	separator_str				db 	"---------------------------------------------------", 10, 13, '$'
	division_by_zero_message 	db 	"Division by zero!!! Terminated", 10, 13, '$'
	overflow_msg 				db 	"Overflow!!! Result is not correct", 10, 13, '$'
	enter_first_number_msg 		db 	"First number:   ", '$'
	enter_second_number_msg 	db 	"Second number:  ", '$'
	enter_operator_msg 			db 	"Opetaror(+, -, *, /): ", '$'
	print_result_msg			db 	"Result is: 	", '$'
	print_quotient_msg			db 	"Quotient is: ", '$'
	print_remainder_msg 		db 	"Remainder is: ", '$'	
	need_to_retry_msg			db 	"Retry?(y/n): 	 ", '$'
.code
.386
include io.inc




;.......................................................................................................................................;
;													Процедуры установки флага переполнения												;
;.......................................................................................................................................;
SetOverflowFlag proc
		push 	AX

		pushf 								;Помещаем регисто флагов в стек
		pop 	AX 							;Достаем значение регистра флагов из стека
		or 		AX, 0000100000000000b 		;Устанавливаем 11-ый бит, который отвечает за флаг OF
		push 	AX 							;Помещаем новое значение 
		popf 								;Устанавливаем его в регистр флагов

		pop 	AX
		ret
endp 	SetOverflowFlag


ClearOverflowFlag proc
		push 	AX

		pushf 								;Помещаем регисто флагов в стек
		pop 	AX 							;Достаем значение регистра флагов из стека
	    and 	AX, 1111011111111111b 		;Устанавливаем 11-ый бит, который отвечает за флаг OF
		push 	AX 							;Помещаем новое значение 
		popf 								;Устанавливаем его в регистр флагов

		pop 	AX
		ret
endp 	ClearOverflowFlag


;.......................................................................................................................................;
;													Процедура подсчета суммы															;
;										Входные параметры:  	В вершине стека - два слагаемых											;
;										Выходные параметры: 	В регистре DX сумма, в флаге OF бит переполнения						;
;.......................................................................................................................................;
Addition proc 											
		push	AX BX CX SI DI BP
		mov 	BP, SP
		mov 	SI, [BP + 16] 						    ;Берем из стека первое слагаемое
		mov 	DI, [BP + 14]							;Берем из стека второе слагаемое

		push 	SI
		push 	DI

		xor 	BH, BH
		xor 	CX, CX 									;В CH будем хранить перенос. В CL номер итерации
		xor 	DX, DX 									;В DX будем накапливать сумму
ADDITION_LOOP:
		xor 	AX, AX 					
		xor 	BX, BX

		shr 	SI, 1 							        ;Получаем младший бит первого слагаемого. Само слагаемое сдвигаем вправл
		jnb 	GET_NEXT_LOW_BIT	
		mov 	AL, 1

GET_NEXT_LOW_BIT:
		shr 	DI, 1 							        ;Аналогично получаем младший бит второго слагаемого
		jnb		LOOP_CONTINUE				
		mov 	BL, 1

LOOP_CONTINUE:
		push 	AX 								        ;Запоминаем младшие биты
		push    BX
		
		xor 	AL, BL 							        ;Вычисляем соответсвующий бит суммы
		xor 	AL, CH 							        ;Учитываем перенос с предыдущего разряда
		shl		AX, CL 							        ;Сдвигаем его на нужное место
		or 		DX, AX 							        ;Устанавливаем его в DX

		pop 	BX 								        ;Возвращаем значения младших битов
		pop 	AX

		mov 	BH, BL 							        ;Вычисляем перенос в следующий разряд 						
		and 	BL, AL 							        ;Он есть, когда оба младших бита равны 1
		and 	AL, CH 							        ;Либо, когда один из них равен 1, а перенос в этот разряд тоже равен 1
		and 	CH, BH
		or 		CH, BL
		or 		CH, AL 							        ;Обновили перенос

		inc 	CL 								        ;Увеличиваем счетчик итераций
		cmp		CL, 16
		jb 		ADDITION_LOOP 	

OVERFLOW_CHECK: 								        ;Проверяем на переполнение
		pop 	SI
		pop 	DI
		push 	DX

		shr 	SI, 15 							        ;Получаем знаковые биты
		shr		DI, 15 						
		shr		DX, 15

		cmp		SI, DI 							        ;Если знаки слагаемых разные, то переполнения не было
		jne 	ADDITION_END
		cmp		SI, DX 							        ;Если знак суммы не совпал со знаком слагаемых, то переполнение случилось
		je		ADDITION_END

		call 	SetOverflowFlag					        ;Запоминаем, что было переполнение

ADDITION_END:
		pop 	DX 								        ;В DX - сумма
		pop 	BP DI SI CX BX AX
		ret
endp Addition




;.......................................................................................................................................;
;													Процедура отрицания																	;
;									Входные параметры:  	В BX число для отрицания													;
;									Выходные параметры: 	В BX число, противоположное входному										;
;.......................................................................................................................................;
Negation proc									        
		push 	DX AX CX

		xor 	CX, CX
NEGATIVE_LOOP:
		mov 	AX, 1 			
		shl 	AX, CL 							        ;Сдвинули единичку на нужное место
		xor 	BX, AX 							        ;Поменяли бит на противоположный

		inc 	CX
		cmp 	CX, 16
		jb 		NEGATIVE_LOOP

NEGATIVE_END:
		mov 	AX, 1
		push	AX
		push 	BX
		call	Addition 				 		        ;Добавили единичку к числу
		pop 	BX
		pop 	AX
		mov 	BX, DX	

		pop 	CX AX DX
		ret
endp Negation




;.......................................................................................................................................;
;												Процедера подсчета разности																;
;									Входные параметры:  	В вершине стека - уменьшаемое, под ним - вычитаемое							;
;									Выходные параметры: 	В регистре DX разность, в флаге OF бит переполнения							;
;.......................................................................................................................................;												
Substraction proc								        ;Процедура разности
		push 	AX BX BP CX
		mov 	BP, SP
		mov 	AX, [BP + 12] 					        ;Взяли числа 
		mov 	BX, [BP + 10]

		call 	Negation 						        ;Поменяли знак у второго

		push 	AX 
		push 	BX
		call 	Addition 						        ;Выполнили сумму	
		pop 	BX
		pop 	CX

		pop 	CX BP BX AX
		ret
endp	Substraction





;.......................................................................................................................................;
;												Процедура подсчета произведения															;
;									Входные параметры:  	В вершине стека - множитель, под ним множимое								;
;									Выходные параметры: 	В регистре DX произведение, в флаге OF бит переполнения						;
;.......................................................................................................................................;
Multiplication proc 							        ;Процедура умножения
		push 	AX BX CX BP SI DI

		mov 	BP, SP 
		mov 	AX, [BP + 16] 					        ;Взяли множимое
		mov 	BX, [BP + 14] 					        ;Взяли множитель

		xor 	BP, BP
		xor 	EDX, EDX 						        ;В нижней части EDX сохраняем множитель				
		mov 	DX, BX 			
		xor 	SI, SI
		mov 	CX, 16

MULTIPLICATION_LOOP:
		xor 	DI, DI 
		mov 	BX, DX 							        ;Берем нижнюю часть EDX
		shr 	BX, 1 							        
		jnb 	$+5
		mov 	DI, 1 							        ;Получаем младший бит EDX

		xor 	DI, SI 							        ;Если 11 или 00, то ничего не делаем
		jz 		PERFORM_MUL_RIGHT_SHIFT

		push 	DX 								        ;Сохраняем младшую часть EDX
		shr 	EDX, 16 						        ;Берем старшую часть EDX
		push 	DX
		push 	AX

		cmp		SI, 1 							        ;Если 01, то выполняем сложение старшей части EDX и множимого AX, иначе вычитание
		je 		PERFORM_MUL_ADDTION
		jmp 	PERFORM_MUL_SUBSTRACTION


PERFORM_MUL_ADDTION:
		call 	Addition 						        ;Выполняем сложение 
		jmp		CONTINUE_MULTPLICATION_LOOP

PERFORM_MUL_SUBSTRACTION:
		call 	Substraction 					        ;Выполняем вычитание
		jmp 	CONTINUE_MULTPLICATION_LOOP

CONTINUE_MULTPLICATION_LOOP:
		pop 	AX		
		pop 	DI
		shl		EDX, 16							        ;Возвращаем результат в старшую часть EDX
		pop 	DX								        ;Восстонавливаем младшую часть EDX

PERFORM_MUL_RIGHT_SHIFT:
		xor 	SI, SI 							
		sar 	EDX, 1 							        ;Сдвигаем вправо
		jnb 	$+5 		
		mov 	SI, 1 							        ;Получаем младший бит 
		loop 	MULTIPLICATION_LOOP


MULTIPLICATION_LOOP_OUT:
		push 	EDX 							
		shr 	EDX, 15							        ;Берем старшую часть результата

		cmp     EDX, 0 							        ;Если не 0
		je 		MULTIPLICATION_END
		cmp 	EDX, 1FFFFh 						     ;И не FFFFh 
		je 		MULTIPLICATION_END 

		call 	SetOverflowFlag 				        ;То было переполнение

MULTIPLICATION_END:
		pop 	EDX
		pop 	DI SI BP CX BX AX
		ret
endp	Multiplication





;.......................................................................................................................................;
;													Процедера подсчета частного															;
;									Входные параметры:  	В вершине стека - делитель, под ним - делимое								;
;									Выходные параметры: 	В младшей части регистра EDX - частное, в старшей - остаток					;
;.......................................................................................................................................;
Division proc
		push 	AX BX CX BP SI DI

		mov 	BP, SP 
		mov 	AX, [BP + 16] 					        ;Берем делимое
		mov 	BX, [BP + 14]					        ;Берем делитель

DIVISION_START:
		;push 	CX
		cwde 									        ;Расширяем AX до EAX
		mov 	EDX, EAX 						        ;Перемещаем делимое в EDX
		mov 	CX, 16

DIVISION_LOOP:
		shl 	EDX, 1 							        ;Сдвигаем делимое EDX влево
		push 	EDX 							        ;Сохраняем делимое EDX

		xor 	SI, SI
		xor 	DI, DI

		shr 	EDX, 16 						        ;Берем старшую часть делимого EDX
		test 	DX, 8000h 			        			;Получаем старший бит делимого EDX
		je 		$+5
		mov 	SI, 1

		test 	BX, 8000h 			        			;Получаем старший бит BX
		je 		$+5
		mov 	DI, 1

		xor 	SI, DI 							        ;Сравниваем старшие биты
		jnz 	PERFORM_DIV_ADDITION			        ;Если равны, то отнимаем от старшей части делимого EDX делитель AX
		jmp 	PERFORM_DIV_SUBSTRACION 		        ;Иначе складываем

PERFORM_DIV_ADDITION:
		push 	DX
		push 	BX
		call 	Addition 						        ;Произвели сложение
		pop 	BX
		pop 	DI
		jmp 	DIVISION_LOOP_CONTINUE

PERFORM_DIV_SUBSTRACION:
		push 	DX
		push 	BX
		call 	Substraction 					        ;Произвели вычитание
		pop 	BX
		pop 	DI
		jmp 	DIVISION_LOOP_CONTINUE

DIVISION_LOOP_CONTINUE:
		mov 	SI, DX 							        ;Помещаем в SI новое значение старшей части делимого
		shr 	SI, 15 							        ;Получаем старший бит нового значения
		shr 	DI, 15 							        ;Получаем старший бит старого значения

		shl 	EDX, 16 						        ;Возвращаем старшую часть EDX
		pop 	EAX 	
		mov 	DX, AX						        	;Возвращаем значение делимого до выполнения сложения-вычитания

		xor 	SI, DI 							        ;Если знак нового и старого значения старщей части делителя совпадают, то операция успешна
		je 		OPERATION_SUCCESS

		cmp 	EDX, 0 							        ;Если делимое равно нулю, то операция успешна
		je 		OPERATION_SUCCESS
		jmp 	OPERATION_FAILURE

OPERATION_SUCCESS:
		mov 	DX, AX 							        ;Устанавливаем значение частного
		or 		DX, 1 							        ;Устанавливаем младший бит частного в 1
		jmp 	DIVISION_LOOP_END

OPERATION_FAILURE:
		mov 	EDX, EAX 						        ;Возвращаем старое значение делимого
		jmp 	DIVISION_LOOP_END

DIVISION_LOOP_END:
		loop 	DIVISION_LOOP


		mov 	BP,SP
		mov 	SI, [BP + 16] 					        ;Берем делимое
		mov 	DI, [BP + 14]					        ;Берем делитель
		shr 	SI, 15 							        ;Получаем старший бит делимого
		shr 	DI, 15 							        ;Получаем старший бит делителя
		
		cmp 	SI, 1
		jne 	INVERT_RESIDUE
		test 	EDX, 0FFFF0000h
		je 		INVERT_RESIDUE

		add 	DX, 1
		mov 	BX, [BP + 14]
		test 	BX, 8000h
		je 		$+5
		call 	Negation
		shl 	EBX, 16
		add 	EDX, EBX
		jmp 	INVERT_RESIDUE

INVERT_RESIDUE:
		xor 	SI, DI 							        ;Если они равны, то ничего не делаем
		je 		DIVISION_PROC_END

		mov 	BX, DX 							
		call 	Negation 						        ;Выполняем отрицание для частного
		mov 	DX, BX


DIVISION_PROC_END:
		pop 	DI SI BP CX BX AX
		ret
endp	Division




MAIN:											        ;Главнвя программа
		mov 	AX, @data
		mov 	DS, AX

		lea 	DX, separator_str
		call 	PrintString


		lea 	DX, enter_first_number_msg 		        ;Ввели первое число
		call 	PrintString 				
		call 	EnterNumber
		call 	PrintBinNumber
		push 	AX

		lea		DX, enter_second_number_msg		        ;Ввели второе число
		call 	PrintString
		call 	EnterNumber
		call 	PrintBinNumber
		push 	AX


		lea 	DX, enter_operator_msg 			        ;Вводим знак операции
		call 	PrintString
		mov 	AH, 08h
ENTER_OPERATOR_LOOP: 
		int 	21h
		mov 	DL, AL

		cmp 	DL, '+'
		je 		PERFORM_ADDITION
		cmp		DL, '-'
		je 		PERFORM_SUBSTRACTION
		cmp	 	DL, '*'
		je 		PERFORM_MULTIPLICATION
		cmp 	DL, '/'
		je 		PERFORM_DIVISION

		jmp 	ENTER_OPERATOR_LOOP	


PERFORM_ADDITION: 								        ;Если ввели плюс, то выполняем сложение
		mov 	AH, 02h
		int 	21h
		call 	Addition
		jmp 	RESULT_OF_OPERATION

PERFORM_SUBSTRACTION: 							        ;Если ввели минус, то отрицание
		mov		AH, 02h
		int 	21h
		call 	Substraction 	
		jmp 	RESULT_OF_OPERATION

PERFORM_MULTIPLICATION:
		pop 	AX
		pop 	BX
		cmp 	AX, 8000h
		je 		$+3	
		xchg 	AX, BX
		push 	AX
		push 	BX

		mov 	AH, 02h
		int 	21h
		call 	Multiplication

		pop 	AX
		pop 	BX
		pushf
		cmp 	AX, 0001h
		jne 	PERFORM_MULTIPLICATION_CONTINUE1
		cmp 	BX, 8000h
		jne 	PERFORM_MULTIPLICATION_CONTINUE1
		popf 
		call 	ClearOverflowFlag
		pushf

PERFORM_MULTIPLICATION_CONTINUE1:
		cmp 	AX, 0ffffh
		jne 	PERFORM_MULTIPLICATION_CONTINUE
		cmp 	BX, 8000h
		jne 	PERFORM_MULTIPLICATION_CONTINUE
		popf
		call 	SetOverflowFlag
		pushf
		jmp 	RESULT_OF_OPERATION

PERFORM_MULTIPLICATION_CONTINUE:
		cmp 	AX, 0001h
		jne 	RESULT_OF_OPERATION
		cmp 	BX, 8000h
		jne 	RESULT_OF_OPERATION
		call 	ClearOverflowFlag
		pushf

RESULT_OF_OPERATION:
		popf
		push 	DX
		call 	PrintNewLine
		call 	PrintNewLine
								
		jo 		OVERFLOW_CASE 					        ;Произошло переполнение
		jmp 	PRINT_RESULT

OVERFLOW_CASE:
		lea 	DX, overflow_msg
		mov 	AH, 09h
		int 	21h 

PRINT_RESULT:
		pop 	AX
		lea 	DX, print_result_msg 			        ;Выводим результат
		call 	PrintString
		call 	PrintNumber
		call 	PrintBinNumber
		jmp 	MAIN_END

PERFORM_DIVISION:
		mov 	AH, 02h
		int 	21h

		pop 	AX
		cmp 	AX, 0 							        ;Отлавливаем деление на ноль
		je 		DIVISION_BY_ZERO_CASE
		push 	AX

		call 	division 								;Делим
		pop 	AX
		pop 	BX

		push 	EDX
		cmp 	AX, -1
		jne 	DIVISION_PRINT_RESILT
		cmp 	BX, -32768
		jne 	DIVISION_PRINT_RESILT

DIVISION_OVERFOLOW:
		call 	PrintNewLine
		call  	PrintNewLine
		lea 	DX, overflow_msg
		mov 	AH, 09h
		int 	21h 
									        
DIVISION_PRINT_RESILT:
		pop 	EAX			
		call 	PrintNewLine
		lea 	DX, print_quotient_msg 			        ;Выводим частное
		call 	PrintString
		call 	PrintNumber
		call 	PrintBinNumber

		shr 	EAX, 16
		lea		DX, print_remainder_msg 		        ;Выводим остаток
		call 	PrintString
		call 	PrintNumber
		call 	PrintBinNumber

		jmp 	MAIN_END

DIVISION_BY_ZERO_CASE:
		call	PrintNewLine
		call 	PrintNewLine

		lea 	DX, division_by_zero_message 	        ;Выводим сообщение о переполнении
		call	PrintString
		jmp 	MAIN_END

MAIN_END:
		lea 	DX, need_to_retry_msg 			        ;Спрашиваем, нужно ли еще
		call 	PrintString
		mov 	AH, 01h
		int 	21h
		call 	PrintNewLine
		call 	PrintNewLine		
		cmp 	AL, 'y'
		je 		MAIN        ;

		mov 	AX, 4c00h
		int 	21h 
end MAIN
