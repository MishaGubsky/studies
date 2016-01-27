AddDigitToNumber proc 						; Добавление цифры к числу. Исходное число в BX, цифра в DL, CX отвечает за отрицательность числа, результат в BX. 
		push 	AX
		push 	CX
		push 	DX

		xor		DH, DH
		sub 	DL, 48

		cmp 	CX, 0
		je 		ADDING_DIGIT_CONTINUE 		; Число положительное. (СХ == 0)
		neg		DX							; Число отрицательное. (CX == 1)

ADDING_DIGIT_CONTINUE:
		mov 	CX, DX
		mov 	AX, BX
		mov 	DX, 10
		imul 	DX
		jo 		ADDING_DIGIT_OUT 			; Произошло переполнение.
		add 	AX, CX
		jo 		ADDING_DIGIT_OUT
		mov 	BX, AX

ADDING_DIGIT_OUT:
		pop 	DX
		pop 	CX
		pop 	AX
		ret
endp AddDigitToNumber


GetDigitFromNumber proc						; Получение последней цифры числа. Исходное число в BX, результат в BX, полученная цифра в DL.
		push 	AX
		push 	CX

		mov 	AX, BX
		xor 	DX, DX
		mov		CX, 10
		cwd
		idiv	CX
		mov 	BX, AX

		test 	DX, DX 						; Проверка цифры на отрицательность
		jns 	GETTING_DIGIT_OUT
		neg 	DX

GETTING_DIGIT_OUT:
		Add 	DX, 48

		pop 	CX
		pop 	AX
		ret
endp GetDigitFromNumber


DoBackspace proc
		push 	AX
		push 	DX

		mov 	AH, 02h
		mov 	DL, 8
		int 	21h
		mov 	DL, 0
		int 	21h
		mov 	DL, 8
		int 	21h

		pop 	DX
		pop 	AX
		ret
endp DoBackspace

EnterNumber proc
		push 	BX
		push 	CX
		push 	DX

		xor 	BX, BX
		xor 	CX, CX
SCANNING_LOOP:
		mov 	AH, 08h						; Ввод символа без эха на экране
		int 	21h
		mov 	DL, AL

		cmp 	DL, 8						; Проверка на корректность символа. Обработка нажатия минуса, энтера, бекспейса
		je 		BACKSPACE_HANDLING
		cmp 	DL, 13
		je 		SCANNING_LOOP_OUT
		cmp 	DL, '-'
		je 		MINUS_HANDLING
		cmp 	DL, 27
		je 		ESCAPE_HANDLING
		cmp 	DL, 48
		jc 		SCANNING_LOOP
		cmp 	DL, 58
		jnc		SCANNING_LOOP

ADDING_DIGIT:						
		call	AddDigitToNumber			; Добавление цифры к числу
		jo 		SCANNING_LOOP 				; При переполнении не выводим цифру на экран

PRINTING_DIGIT:								; Вывод цифры на экран, если она добавлена к числу
		mov 	AH, 02h
		int 	21h
		jmp 	SCANNING_LOOP

BACKSPACE_HANDLING:							; Обработка нажатия бекспейса
		cmp 	BX, 0
		jne 	BACKSPACE_CONTINUE
		mov 	CX, 0

BACKSPACE_CONTINUE:
		call 	GetDigitFromNumber  		; Удаление последней цифры числа
		call 	DoBackspace
		
		jmp 	SCANNING_LOOP

MINUS_HANDLING:							 	; Обработка нажатия минуса. СХ == 1, если число отрицательное. СХ == 0, если число положительное.
		cmp 	BX, 0
		jne 	SCANNING_LOOP
		cmp 	CX, 0
		jne 	SCANNING_LOOP
		mov 	CX, 1
		jmp  	PRINTING_DIGIT

ESCAPE_HANDLING:
		call 	GetDigitFromNumber			
		call	DoBackspace
		cmp 	BX, 0
		jne		ESCAPE_HANDLING

		call  	DoBackspace
		mov 	CX, 0

		jmp 	SCANNING_LOOP

SCANNING_LOOP_OUT:
		mov 	AX, BX
ENTER_NUMBER_ENDP:
		pop 	DX
		pop 	CX
		pop 	BX
		ret
endp EnterNumber


PrintNumber proc						; Вывод числа. Исходоное число в ВХ.
		push 	AX
		push 	BX
		push	CX
		push 	DX
		xor 	CX, CX

		mov 	BX, AX
		test 	BX, BX					; Проверка на отрицательность. Вывод минуса, если нужнен.
		jns 	GETTING_DIGITS_LOOP
		mov 	AH, 02h
		mov 	DL, '-'
		int 	21h

GETTING_DIGITS_LOOP:					; Получение цифр и сохранение их в стеке.
		call 	GetDigitFromNumber
		push 	DX
		inc  	CX
		cmp 	BX, 0
		jne  	GETTING_DIGITS_LOOP

PRINTING_DIGITS_LOOP:					; Вывод цифр в консоль.
		pop 	DX
		mov 	AH, 02h
		int 	21h
		loop 	PRINTING_DIGITS_LOOP

		pop 	DX
		pop 	CX
		pop 	BX
		pop 	AX
		ret
endp PrintNumber


PrintBinNumber proc
		push 	AX BX CX

		xor 	CX, CX
GETTING_BITS_LOOP:
		shr		AX, 1
		jb 		GET_1_BIT
GET_0_BIT:
		mov 	DL, '0'
		jmp 	GETTING_BITS_CONTINUE
GET_1_BIT:
		mov 	DL, '1'
		jmp 	GETTING_BITS_CONTINUE
GETTING_BITS_CONTINUE:
		push 	DX
		inc 	CX
		cmp 	AX, 0
		jne 	GETTING_BITS_LOOP


		mov 	AH, 02h
		mov 	DL, ' '
		int 	21h
PRINTING_BITS_LOOP:
		pop 	DX
		int 	21h
		loop 	PRINTING_BITS_LOOP

		mov 	DL, 10
		int 	21h
		mov 	DL, 13
		int 	21h

		pop 	CX BX AX
		ret
endp PrintBinNumber


PrintString proc
		push 	AX
		
		mov 	AH, 09h
		int 	21h

		pop 	AX
		ret
endp PrintString

PrintNewLine proc
		push 	AX DX

		mov 	AH, 02h
		mov 	DL, 10
		int 	21h
		mov 	DL, 13
		int 	21h

		pop 	DX AX
		ret
endp PrintNewLine