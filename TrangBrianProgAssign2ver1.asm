TITLE Programming Assignment #2     (TrangBrianProgAssign2.asm)

; Author: Brian Trang
; Email:trangb@oregonstate.edu
; Course / Project ID: CS271-400                 Date:10/10/2017
; Programming Assignment #2
; Description: This program will calculate Fibonacci numbers.

INCLUDE Irvine32.inc



.data
MAX = 30																					;max size of user string input
UPPER_LIMIT = 46																			;fibonacci upper limit as a constant
LOWER_LIMIT =1
MAX_ROW=5
title_prompt		BYTE	"Fibonacci Numbers",0					
author				BYTE	"Programmed by Brian Trang",0
name_prompt			BYTE	"What is your name? ",0						

user_name			BYTE	MAX+1 DUP (?)													;user input name add 1 for null
user_prompt			BYTE	"Hello, ",0

instruct_prompt		BYTE	"Enter the number of Fibonacci terms to be displayed. ",0
input_prompt		BYTE	"Give  the number as an integer in the range [1 .. 46]. ",0
max_prompt			BYTE	"How many Fibonacci terms do you want? ",0
incorrect_prompt	BYTE	"Out of range. Enter a number in [1 ...46] ",0
spacing				BYTE	"     ",0														;spacing for output
closing				BYTE	"Results certified by Brian Trang. ",0
goodbye				BYTE	"Good bye ",0
num_terms			DWORD	?																;how many terms?
num_total			DWORD	0						
num_current			DWORD	1									
endBlock			BYTE	"You are in the end block. ",0			
column				DWORD	0																;keep track before creating new row
prev_term			DWORD	?

.code
main PROC

;Introduction
	mov		edx, OFFSET title_prompt
	call	WriteString
	call	CrLf
	mov		edx, OFFSET author
	call	WriteString
	call	CrLf
	call	CrLf

;read user string input
	mov		edx, OFFSET name_prompt										;ask for user name
	call	WriteString
	mov		edx, OFFSET user_name										
	mov		ecx, MAX													;set max number of non-null chars to read (buffer - 1 null char)
	call	ReadString			
	mov		edx, OFFSET user_prompt
	call	WriteString
	mov		edx, OFFSET user_name
	call	WriteString
	call	Crlf

;get user data
	mov		edx, OFFSET instruct_prompt
	call	WriteString
	call	Crlf
	mov		edx, OFFSET input_prompt
	call	WriteString
	call	Crlf

askNum:
	mov		edx, OFFSET max_prompt
	call	WriteString
	call	ReadInt
	mov		num_terms,eax
	cmp		eax,UPPER_LIMIT										;test if user input is more then 46
	ja		invalid
	cmp		eax,LOWER_LIMIT										;test if user input is less then 1
	jb		invalid
	mov		num_terms,eax
	jmp		fibBLock

invalid:														;post test loop for user input
	mov		edx, OFFSET incorrect_prompt
	call	WriteString
	call	Crlf
	jmp		askNum


;displayFibs
fibBlock:
	mov		eax,0														;initialize accumulator
	mov		ebx,num_current
	mov		ecx,num_terms												;initialize counter
	
fibLoop:
	add		eax,ebx
	cmp		eax,LOWER_LIMIT
	je		firstTerm
	;add		eax,ebx
	;call	WriteDec
	;mov		edx,OFFSET spacing
	;inc		ebx
	;loop	fibLoop
;
firstTerm:																;special block for first two terms
	call	WriteDec
	dec		ecx
	inc		column
	mov		edx, OFFSET spacing
	call	WriteString
	call	WriteDec
	mov		edx, OFFSET spacing
	call	WriteString
	dec		ecx
	inc		column
	jmp		restLoop

restLoop:
	mov		prev_term,eax
	add		eax,ebx
	mov		ebx,prev_term

	call	WriteDec
	mov		edx, OFFSET spacing
	call	WriteString 
	inc		column
	cmp		column, MAX_ROW
	je		newRow
	jmp		continueLoop
newRow:
	call	Crlf		
	mov		column,0

continueLoop:
	loop	restLoop


	
	exit			; exit to operating system
main ENDP

; (insert additional procedures here)

END main
