TITLE Program Template     (template.asm)

; Author: Brian Trang
; Email:trangb@oregonstate.edu
; Course / Project ID   CS271-400              Due Date:10/8/2017
; Programming Assignment #1
;Description: This program will take 2 number inputs from the user and calculate the sum, difference,
;quotient, and remainder of the numbers.
INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
intro_name			BYTE	"		Elementary Arithmetic      by Brian Trang" , 0
instruct_1			BYTE	"Enter 2 numbers, and I'll show you the sum, difference, " ,0
instruct_2			BYTE	"product, quotient , and remainder." ,0
prompt_1			BYTE	"First number: ",0
prompt_2			BYTE	"Second number: ",0
plus				BYTE	" + ",0			
equal				BYTE	" = ",0
minus				BYTE	" - ",0
multiply			BYTE	" x ",0
divide				BYTE	" / ",0
remainder_output	BYTE	" remainder: ",0
farewell			BYTE	" Thanks for using the program. ",0
comparison			BYTE	"First number must be larger then second. ",0
askAgain_prompt		BYTE	"Do you want to calculate again? (1 for yes, 0 for no) ",0
EC_1				BYTE	"EC: Program repeats until user chooses to quit. ",0						;extra credit 1 print statement
EC_2				BYTE	"EC: Program checks if second number is more then first. ",0				;extra credit 2 print statement
EC_3				BYTE	"EC: Program divides and calculates quotient as floating point. ",0			;extra credit 3 print statement

float_prompt		BYTE	"Floating point quotient: ",0
float_EC3			REAL4	?
float_1000			DWORD	1000																		;converting to .001	
float_decimal		BYTE	".",0																		;decimal for floating point
float_int			DWORD	?																			;whole number portion of floating point
float_remainder		DWORD	?																			;remainder from float division
float_toConvert		DWORD	0																			;float multipled by 1000


first_num			DWORD	?																			;first user input
second_num			DWORD	?																			;second user input
sum					DWORD	?																			;sum of inputs
product				DWORD	?																			;product of inputs
quotient			DWORD	?																			;quotient of inputs
remainder			DWORD	?																			;remainder of inputs
difference			DWORD	?																			;difference of inputs
again				DWORD	?																			;user input for running program again
														
; (insert variable definitions here)

.code
main PROC

; (insert executable instructions here)

;introduction
mov	edx, OFFSET intro_name
call WriteString
call Crlf

;get the data
mov		edx, OFFSET instruct_1								;print instructions
call	WriteString											
call	Crlf												

mov		edx, OFFSET instruct_2								;print instructions	
call	WriteString											
call	Crlf
call	Crlf

mov		edx, OFFSET EC_1									;message for extra credit 1
call	WriteString
call	Crlf
call	Crlf	

mov		edx, OFFSET EC_2									;message for extra credit 2
call	WriteString
call	Crlf
call	Crlf

mov		edx, OFFSET EC_3									;message for extra credit 3
call	WriteString
call	Crlf
call	Crlf

starting:													;Beginning of user input

mov		edx, OFFSET prompt_1								;get first user input
call	WriteString
call	ReadInt												
mov		first_num, eax

mov		edx, OFFSET prompt_2								;get second user input
call	WriteString
call	ReadInt												
mov		second_num, eax
call	Crlf

; EC: is the second number smaller then first?
mov		eax,second_num
cmp		eax,first_num
jg		lessThan											;go to less than portion 1st num is less than 2nd num
jle		calculate

lessThan:

mov		edx, OFFSET comparison
call	WriteString
call	Crlf
jg		askAgain												;go to askAgain instruction

calculate:													;calculations of the 2 user inputs

;calculate the require values
mov		eax, first_num										;add first num to second num
mov		ebx, second_num
add		eax,ebx
mov		sum, eax

mov		eax, first_num										;subtract first num from second num
mov		ebx, second_num
sub		eax,ebx
mov		difference, eax

mov		eax,first_num										;multiply first num and second num
mov		ecx,second_num
mul		ecx
mov		product,eax

mov		edx,0												;divide first num by second num, store quotient and remainder
mov		eax,first_num
mov		ecx,second_num
div		ecx		
mov		quotient,eax
mov		remainder,edx

;EC 3 Calculate quotient as floating point
fld		first_num											;load first_num into stack
fdiv	second_num											;divide first_num in stack by second_num
fimul	float_1000											;multiply 1000 to convert
frndint
fist	float_toConvert										;first_num/second_num converted into int		


;display the results
mov		eax, first_num										;output the sum
call	WriteDec
mov		edx, OFFSET plus
call	WriteString
mov		eax, second_num
call	WriteDec
mov		edx, OFFSET equal
call	WriteString
mov		eax, sum
call	WriteDec
call	Crlf

mov		eax, first_num										;output the difference
call	WriteDec
mov		edx, OFFSET minus
call	WriteString
mov		eax, second_num
call	WriteDec
mov		edx, OFFSET equal
call	WriteString
mov		eax, difference
call	WriteDec
call	Crlf

mov		eax, first_num										;output the product
call	WriteDec
mov		edx, OFFSET multiply
call	WriteString
mov		eax, second_num
call	WriteDec
mov		edx, OFFSET equal
call	WriteString
mov		eax, product
call	WriteDec
call	Crlf

mov		eax, first_num										;output the quotient
call	WriteDec
mov		edx, OFFSET divide
call	WriteString
mov		eax, second_num
call	WriteDec
mov		edx, OFFSET equal
call	WriteString
mov		eax, quotient
call	WriteDec
mov		edx,OFFSET remainder_output
call	WriteString
mov		eax,remainder
call	WriteDec
call	Crlf
call	Crlf

;EC 3 float quotient output
mov		edx, OFFSET float_prompt
call	WriteString
mov		edx,0												;zero out edx register
mov		eax,float_toConvert									
cdq															;convert data in eax to quad
mov		ebx,float_1000
cdq
div		ebx													;divide by 1000 to convert
mov		float_int,eax										;move numbers before decimal to float_int
mov		float_remainder,edx									;move numbers after decimal to float_remainder
mov		eax, float_int										
call	WriteDec											;print numbers before decimal
mov		edx, OFFSET float_decimal							;print actual decimal
call	WriteString

;EC 3 float quotient after decimal output
mov		eax,float_int
mul		float_1000											;multiply by 1000
mov		float_EC3,eax										;float_EC3 is a temporary holding place for multip
mov		eax,float_toConvert
sub		eax,float_EC3										;subtract to obtain trailing digits
mov		float_remainder,eax						

call	WriteFloatfloat_prompt		BYTE	"Floating point quotient: ",0
call	Crlf


;ask user if they want to use program again	
askAgain:														
mov		edx, OFFSET askAgain_prompt
call	WriteString
call	Crlf
call	ReadInt
mov		again,eax
cmp		eax,1												;did user enter 1?
je		starting											;return to starting if user entered 1


;say goodbye
mov		edx, OFFSET farewell								;output ending message
call	WriteString
call	Crlf
call	Crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main