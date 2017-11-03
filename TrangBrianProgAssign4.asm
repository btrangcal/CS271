TITLE Programming Assignment #4     (TrangBrianProgAssign4.asm)

; Author: Brian Trang
; Email:trangb@oregonstate.edu
; Course / Project ID: CS271-400                 Date:10/26/2017
; Programming Assignment #4
; Description: This program will calculate composite numbers. User will enter total # of composites to display
; and will be prompted to enter an integer in the range of [1..600]. Program verifies number in the range
; and then the program calculates and displays all composite numbers up to and including nth composite. Results displayed
; 20 composites per line with at least 1-3 spaces between the numbers


INCLUDE Irvine32.inc


.data
;intro and instructions for user output messages
intro_title			BYTE	"Composite Numbers		Programmed by Brian Trang",0
intro_instruct1		BYTE	"Enter the number of composite numbers you would like to see.",0
intro_instruct2		BYTE	"I'll accept orders for up to 600 composites.",0
getInput_instruct	BYTE	"Enter the number of composites to display [1 .. 600]: ",0
getInput_notValid	BYTE	"Out of range. Try again",0
outputSpaces		BYTE	"   ",0
outputSpaces1		BYTE	"    ",0
outputSpaces2		BYTE	"  ",0
goodbye				BYTE	"Results certified by Brian Trang. Goodbye.",0
pressKey			BYTE	"Press any key to continue...",0
;extra credit messages
EC1					BYTE	"**EC: Align the columns",0
EC2					BYTE	"**EC: Display more composites, but 1 page at a time.",0



errorInput			DWORD	0																;acting bool to set if userInput is not within lower and upper range
okayToDisplay		DWORD	0																;acting bool to determine if number is okay to display
lower_limit			DWORD	1																;lower limit for total composites to find
upper_limit			DWORD	600																;upper limit for total composites to find
currentNum			DWORD	2																;we start our current number at 2, since 1 is obviously a prime 


numComposites		DWORD	0																;counter for # composites found so far
numPerLine			DWORD	0																;counter for # per row
.data?
userInput			DWORD	?																;userInput for total composite numbers
continue			BYTE	?																;to store user input to continue to next row
.code
main PROC

;display introduction of programmer and program title
call		introduction

;get user input for total composites to display
call		getUserData
;calculate composites and display them
call		showComposites
;display farewell message
call		farewell

		

	exit			; exit to operating system
main ENDP

; (insert additional procedures here)


;Procedure for introducing the program
;receives: N/A
;returns: N/A
;preconditions: N/A
;registers change: edx
introduction PROC USES edx,
;Display title and introduce programmer
mov			edx, OFFSET intro_title
call		WriteString
call		Crlf																				;double space
call		Crlf
;Display extra credit message
mov			edx, OFFSET EC1
call		WriteString
call		Crlf
mov			edx, OFFSET EC2
call		WriteString
call		Crlf
call		Crlf
;display instructions
mov			edx, OFFSET intro_instruct1
call		WriteString
call		Crlf
mov			edx, OFFSET intro_instruct2
call		WriteString
call		Crlf
call		Crlf
;return 
ret
introduction ENDP


;Procedure to get input number n from user.
;Implementation note: this procedure checks user input is in the range
; of [1..400] via sub procedure validate

;receives: input from user
;returns: user input for total number of composites to display
;preconditions: user input is 1<= n<= 400
;registers changed: eax, edx
getUserData PROC USES eax edx,

ask:
;ask for input
mov			edx, OFFSET getInput_instruct
call		WriteString
;get input
call		ReadInt
mov			userInput,eax	
call		validate

;if acting bool errorInput is set, we have to ask user for a correct input
cmp			errorInput, 1
je			ask

correct:
call		Crlf
ret

getUserData ENDP


; validate is a sub procedure for checking if input is valid
validate PROC USES eax edx,

;validate input

mov			eax, userInput
cmp			eax, lower_limit
jl			invalid
cmp			eax, upper_limit
jg			invalid
jmp			good

;if input is invalid , display message to user and set the acting bool errorInput

invalid:
mov			edx, OFFSET getInput_notValid
call		WriteString	
mov			errorInput, 1
ret
good:
mov			errorInput,0
ret
validate ENDP




;Procedure to show composites.

;receives: 
;returns: output of composite numbers
;preconditions: userInput 1<-n <=400
;registers changed: eax, ebx, ecx,edx

showComposites PROC USES eax ecx edx ebx,

mov	eax, userInput

determineComposite:
mov			okayToDisplay,0															;set default bool to 0
call		isComposite		
cmp			okayToDisplay,1															;check if okayToDisplay is set
je			display
inc			currentNum																;not composite, so we increment instead of display
mov			eax, numComposites
cmp			eax, userInput
jl			determineComposite														;search for more composites if less than
jmp			done

;display our number, then determine appropriate amount of spacing
display:
mov			eax, currentNum
call		WriteDec
cmp			eax, 9
jle			singledigit		
jg			doubledigit

;line spacing for single digits
singledigit:																		
mov			edx, OFFSET outputSpaces1
call		WriteString
jmp			createLine																;skip to createLine since we established our spacing

;line spacing for double digits
doubledigit:
cmp			eax,100
jge			tripledigit
mov			edx, OFFSET outputSpaces
call		WriteString
jmp			createLine																;skip to createLine since we established our spacing

;line spacing for triple digits
tripledigit:
mov			edx, OFFSET outputSpaces2
call		WriteString



createLine:
inc			currentNum																;move to next num
inc			numPerLine																;update num per line
cmp			numPerLine,20															;check if we have 20 per line
je			newLine
jmp			determineComposite

;wait for a button press from user before displaying next row of composites
newLine:
call		Crlf
mov			edx, OFFSET pressKey
call		WriteString
call		Crlf
call		Crlf
push		eax																															;save composite in eax since we need eax to store user alphanumeric key for displaying next row

;create 500 second delay so user can enter a key to display next row, keeps looping until button press
L1:
mov			eax,500
call		Delay
call		Readkey
jz			L1

;once user presses key, continue to our next number to evaluate if composite and display
mov			continue, al
pop			eax																															;restore our composite value back to eax
call		Crlf
mov			numPerLine,0																												;restart our counter for total per line
jmp			determineComposite

done:
ret



showComposites ENDP

;Procedure to check if number is composite

;receives: n/a
;returns: set value of okayToDisplay, which acts as bool to determine if composite
;preconditions: user input is 1<= n<= 400
;registers changed: eax, edx, ebx, ecx


isComposite PROC USES eax ebx edx ecx,
	
mov			ecx, currentNum											;set loop counter
dec			ecx														;decrement by 1 since we don't need to check 1 divisbility
mov			ebx, currentNum											;set up ebx for division
dec			ebx


isComp:
cmp			ebx,1													;we need to divide by a num other than 1
je			finish													;if prime, skip to end and don't set okayToDisplay
mov			eax, currentNum
mov			edx,0													;zero out edx
div			ebx
cmp			edx,0													;is remainder 0?
je			compVerified
dec			ebx														;if not composite, we move down the list
loop		isComp

compVerified:
mov			okayToDisplay,1											;we found our composite, set okayToDisplay
inc			numComposites											;increment the number of composites 

finish:
ret
isComposite ENDP

;receives: n/a
;returns: message saying goodbye to user
;preconditions: n/a
;registers changed: edx


farewell PROC 
call		Crlf
call		Crlf
mov			edx, OFFSET goodbye
call		WriteString
call		Crlf

ret

farewell ENDP

END main





