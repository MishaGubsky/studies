.data
sign_bit              equ 	80000000h 
except_sign_bit       equ 	7FFFFFFFh 
all_mantissa_bits     equ 	007FFFFFh
all_order_bits        equ 	7F800000h
last_order_bit        equ 	00800000h

true  				  equ 	1
false 				  equ 	0
epsilon	      		  equ 	6 	
mantissa_size 		  equ 	23


string_newline        db 	13, 10, "$"
string_point          db 	".$"
string_delimiter      db 	" | $"
string_whitespace	  db 	"   $"
string_separator	  db 	"---------------------------------------------------", 10, 13, '$'

string_overflow       db 	"overflow! $"
string_underflow      db 	"underflow! $"
string_plus_infinity  db 	"+infinity! $"
string_minus_infinity db 	"-infinity! $"
string_try_again 	  db 	"Invalid value, try again: $"

cmfl 				  dw 	0
mfl 				  dw 	0	
expf 				  dw	0	
mexfl 				  dw 	0 	
tenconst 			  dt 	10
minusconst 	          dt   -1
symb 				  dw 	0
tenpow 				  db 	0
buf 				  db 	50 dup (?)
datain 				  dd 	0
dataout 			  dt 	0
iscorrect 			  db 	0
leftbit 			  dw 	0
first_bit 			  equ 	8000h	


.code

puts macro string
		push 	AX
		push 	DX
		mov 	AH, 09h
		lea 	DX, string
		int 	21h
		pop 	DX
		pop 	AX
endm

scanf macro number 
		push 	EAX
		save_fpu_state
		call 	number_input_correct
		load_fpu_state
		mov 	dword ptr number, EAX	
		pop 	EAX	
endm 

putf macro number 
		push 	EAX
		mov 	EAX, dword ptr number
		save_fpu_state
		call 	number_output
		load_fpu_state
		pop 	EAX
endm

putb macro number 
		push 	EAX
		mov 	EAX, dword ptr number
		call 	bin_output
		pop 	EAX
endm

save_fpu_state macro
		sub 	SP, 94
		mov 	BP, SP
		fsave 	[BP]
endm

load_fpu_state macro
		mov 	BP, SP
		frstor 	[BP]
		add 	SP, 94
endm





number_input proc c 
			 uses EAX, EBX, ECX, EDX
		xor 	BX, BX
		xor 	SI,SI
		mov 	mexfl, 0
		lea 	DX, buf
		mov 	[buf], 61
		mov 	AH, 0ah
		int 	21h
		lea 	SI,[buf+2]
		mov 	cmfl, 0
		mov 	mfl, 0
		mov 	iscorrect, 0
ln0:
		cld 
		lodsb
		cmp 	AL, 101
		jne 	ln333
		mov 	expf, 1
		jmp 	ln2
ln333:
		cmp 	AL,45
		jne 	ln34
		mov 	mfl, 1
		jmp 	ln0
ln34:
		cmp 	AL,46
		jne 	ln1
		mov 	cmfl, 1
		jmp 	ln0	
ln1:
		cmp 	AL, 13
		je 		ln2
		cmp 	cmfl, 1
		jne 	ln0
		inc 	tenpow
		jmp 	ln0
ln2:		
		fldz
		lea 	SI,[buf+2]	
step1:
		cld
		lodsb
		cmp 	AL,45
		je 		step1
		cmp 	AL,46
		je 		step1
		cmp 	AL, 101
		je 		step11
		cmp 	AL, 13
		je 		step2
		cmp 	AL,48
		jb 		step1
		cmp 	AL,57
		ja 		step1
		fbld	tenconst
		fmul
		mov 	iscorrect, 1	
		mov 	byte ptr[symb], AL
		sub 	symb,'0'
		fiadd 	symb
		jmp 	step1
step01:
		xor 	BX, BX
		mov 	BL, 0
step11:
		cld 
		lodsb
		cmp 	AL,45
		jne 	ex11
		cmp 	mexfl, 0
		jne 	step11
		mov 	mexfl, 1
		jmp 	step11
ex11:
		cmp 	AL, 13
		je 		stepq
		cmp 	AL,38
		jb 		step11
		cmp 	AL,57
		ja 		step11
		sub 	AL,'0'
		mov 	DL, AL
		mov 	AL, 10
		mul 	BL
		add 	AL, DL
		mov 	BL, AL
		jmp 	step11
stepq:
		cmp 	mexfl, 1
		je 		stepz
		jmp 	step2
stepz:
		add 	tenpow, BL
		mov 	BL, 0
step2:
		cmp 	tenpow, 0
		je 		step3
		fbld 	tenconst
		fdiv 
		dec 	tenpow
		jmp 	step2 	
step3:
		cmp 	BL, 0
		je 		step35
		fbld 	tenconst
		fmul
		dec	 	BL
		jmp 	step3
step35:
		cmp 	mfl, 1
		jne 	step4
		fbld 	minusconst
		fmul	
step4:
		fstp 	datain 
		mov		ECX, datain
		or 		ECX, 80000000h
		cmp  	ECX, 0FF800000h
		jnz  	@@exit
		mov		iscorrect, 0
		puts 	string_newline
		puts 	string_overflow
@@exit:	
		puts 	string_newline
		ret
number_input endp


number_input_correct proc
number_input_correct_start:
		call 	number_input
		cmp 	iscorrect, true
		je 		number_input_correct_end
		ffree
		puts 	string_try_again
		jmp 	number_input_correct_start
	
number_input_correct_end:
		mov 	EAX,datain
		ret
number_input_correct endp


puts_number proc
		pusha
	
		push	AX
		fxch	ST(0)
		ftst
		fstsw	AX
		sahf
		fxch	ST(0)
		pop		AX
		jnc		@@great_than_zero
		
		fabs
		push	AX
		push	DX
		mov		AH, 2h
		mov		DL, '-'
		int		21h
 
		pop		DX
		pop		AX
	
@@great_than_zero:	
		fld1
		fld		ST(1)
		fprem
		fxch	ST(1)
		ffree	ST(0)
		fincstp
		fsub	ST(1), ST(0)
		fxch	ST(1)

		mov		CX, 9
		fld1
		fld1
@@fld_10:
		fadd	ST(1), ST(0)	
		loop	@@fld_10

		ffree	ST(0)
		fincstp

		push 	BP	
		mov 	BP, sp
		push 	0
		xor		CX, CX

@@division:
		inc		CX
		fdiv	ST(1), ST(0)
		fld1	
		fcomp	ST(2)
		fstsw	AX
		cmp	 	CX, 60
		je 		@@popa2
		sahf		
		jz		@@division
		jc		@@division			

@@multiply:
		fmul	ST(1), ST(0)
		fld1
		fld		ST(2)
		fprem		
		fsubr	ST(0), ST(3)
		fist	word ptr [BP - 2]
		mov		AH, 02h
		mov		DL, byte ptr [BP - 2]
		add		DL, '0'
		int		21h
		fsubp	ST(3), ST(0)
		ffree	ST(0)
		fincstp
		loop	@@multiply
		
		fxch	ST(1)
		ffree	ST(0)
		fincstp	
	
		puts 	string_point

		mov		CX, epsilon
@@multiply1:
		fmul	ST(1), ST(0)
		fld1
		fld		ST(2)
		fprem		
		fld		ST(3)
		fsubrp	ST(1), ST(0)
		fist	word ptr [BP - 2]
		mov		AH, 02h
		mov		DL, byte ptr [BP - 2]
		add		DL, '0'
		int		21h
		fsubp	ST(3), ST(0)
		ffree	ST(0)
		fincstp
	
		push	AX
		fxch	ST(1)
		ftst
		fstsw	AX
		sahf
		fxch	ST(1)		
		pop		AX

		loop	@@multiply1	
		pop		AX
		pop		BP

		ffree	ST(0)
		fincstp
		ffree	ST(0)
		fincstp
@@popaopa:
		popa
		ret
@@popa2:
		puts 	string_overflow
		jmp @@popaopa
puts_number	endp


puts_int proc
		pusha								
		pushf
		mov		EAX, EBX
		xor 	EBX, EBX
		mov 	BX, 10
		xor 	CX, CX
	
@@metka1:							
		xor 	EDX, EDX
		div 	BX
		add 	DL, '0'
		push 	DX
		inc 	CL
		cmp 	AX, 0
		jnz 	@@metka1
		mov 	AH, 2
@@metka2:							
		pop 	DX
		int 	21h
		loop 	@@metka2
		popf
		popa
		ret
puts_int endp


writeint proc 
		push 	AX
		push 	BX
		push 	CX
		push 	DX	 
	
		xor 	CX, CX 
		mov 	BX, 10 

		test 	AX, first_bit
		jz 		writepush
		push 	AX
		mov 	DL, '-'
		mov 	AH, 02h
		int 	21h
		pop 	AX
		neg 	AX
		
writepush:                          
		xor	 	DX, DX
		div 	BX
		push 	DX 
		inc 	CX
		cmp 	AX, 0
		jne 	writepush

writepop:      
		pop 	DX
		add 	DL, '0'
		mov 	AH, 02h
		int 	21h
		loop 	writepop

		pop 	DX
		pop 	CX
		pop 	BX
		pop 	AX
		ret
writeint endp

number_output proc
		push 	EAX
		and 	EAX, all_order_bits
		xor 	EAX, all_order_bits
		cmp 	EAX, 0 ; infinity
		jne 	not_infinty
		pop 	EAX
		puts 	string_overflow
		ret	
	
not_infinty:
		pop 	EAX
	
		pusha
		push 	EAX
		mov 	datain, EAX
		fld 	datain
		fstp	dataout
		fld 	dataout

		sub		sp, 94
		mov		BP, sp
		FSAVE	[BP]
	
		fld		tbyte ptr [BP + 14]
		ftst	
		push	AX
		fstsw	AX
		sahf		
		pop		AX
	
		jnz 	@@not_null
		call	puts_number
		jmp		@@exit		

@@not_null:
		ftst	
		push	AX
		fstsw	AX
		sahf		
		pop		AX
		jnc		@@greater_zero
		push	AX
		push	DX
	
		mov		AH, 2h
		mov		DL, '-'
		int		21h

		pop		DX
		pop		AX

		fabs
@@greater_zero:
		push 	AX
		fld1
		fcomp	ST(1)
		fstsw	AX
		sahf
		pop		AX
		
		jz		$ + 4	
		jnc		@@below_one
		
		push	AX
		push	CX
		mov		CX, 9

		fld1
		fld1

@@fld_10:
		fadd	ST(1), ST(0)
		loop	@@fld_10
		
		pop		CX
		
		ffree	ST(0)
		fincstp
		fcomp	ST(1)
		fstsw	AX
		sahf
		pop		AX
		jc		@@greater_ten
		call	puts_number
		jmp		@@exit

@@below_one:
		push	CX
		mov		CX, 9
		fld1
		fld1

@@fld_10_1:
		fadd	ST(1), ST(0)
		loop	@@fld_10_1
		ffree	ST(0)
		fincstp
		pop		CX
		push	BX
		xor		BX, BX
	
@@multiply:
		inc		BX
		fmul		ST(1), ST(0)

		push	AX
		fld1
		fcomp	ST(2)
		fstsw	AX
		sahf
		pop		AX

		jnc		@@multiply
		
		ffree	ST(0)
		fincstp
		call	puts_number
		
		push	AX
		push	DX
		
		mov		AH, 2h
		mov		DL, 'e'
		int		21h
		mov		DL, '-'
		int		21h
		
		pop		DX
		pop		AX
		call	puts_int
		pop		BX
		jmp		@@exit
	
@@greater_ten:	
		push	CX
		mov		CX, 9
		
		fld1
		fld1
@@fld_10_2:
		fadd	ST(1), ST(0)
		loop	@@fld_10_2
		ffree	ST(0)
		fincstp
		pop		CX
		
		push	BX
		xor		BX, BX

@@division:
		inc		BX
		fdiv	ST(1), ST(0)

		push	CX
		mov		CX, 9
		fld1
		fld1
@@fld_10_3:
		fadd	ST(1), ST(0)
		loop	@@fld_10_3

		ffree	ST(0)
		fincstp
		pop		CX
		
		push	AX
		fcomp	ST(2)
		fstsw	AX
		sahf
		pop		AX

		jz		@@division
		jc		@@division
		
		ffree	ST(0)
		fincstp
		call	puts_number
		push	AX
		push	DX
		
		mov		AH, 2h
		mov		DL, 'e'
		int		21h
		pop		DX
		pop		AX
		
		call	puts_int
		pop		BX

@@exit:
		mov		BP, sp
		FRSTOR	[BP]
		add		sp, 94
		
		pop 	EAX
		popa
		ret
number_output	endp



bin_output proc 
		push 	EAX
		push 	CX
		push 	DX
		mov 	CX, 0

ll11:
		mov 	leftbit, 0 
		shl 	EAX, 1
		jnc 	not111
		mov 	leftbit, 1

not111:		
		push 	EAX
		xor 	AX, AX
		mov 	AH, 02h
		mov 	DX, leftbit
		add 	DX,'0'
		int 	21h
		pop 	EAX
		add 	CX, 1
		cmp 	CX, 1
		jne		ll11
		
		push 	AX
		mov 	AH, 02h
		mov 	DL,' '
		int 	21h
		pop 	AX
		
		mov 	CX, 0

ll12:
		mov leftbit, 0 
		shl EAX, 1
		jnc not112
		mov leftbit, 1

not112:		
		push 	EAX
		xor 	AX, AX
		mov 	AH, 02h
		mov 	DX, leftbit
		add 	DX,'0'
		int 	21h
		pop 	EAX
		add 	CX, 1
		cmp 	CX,8
		jne 	ll12
		
		push 	AX
		mov 	AH, 02h
		mov 	DL,' '
		int 	21h
		pop 	AX
	

		mov 	CX, 0
ll13:
		mov 	leftbit, 0 ;получаем крайний левый бит обоих чисел
		shl 	EAX, 1
		jnc 	not113
		mov 	leftbit, 1

not113:		
		push 	EAX
		xor 	AX, AX
		mov 	AH, 02h
		mov 	DX, leftbit
		add		 DX,'0'
		int 	21h
		pop 	EAX
		add 	CX, 1
		cmp 	CX,23
		jne 	ll13
		
		pop 	DX
		pop 	CX
		pop 	EAX
		ret
bin_output endp