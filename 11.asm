;Assignment No. 11

;Write 80387 ALP to obtain:1) Mean 2) Variance) Standard ;Deviantion.Also plot the histrogram
; for the data set. The data ;elements are available in a text file.

Section .data
	welmsg db 10,"***WELCOME TO 64 BIT PROGRAMMING***"
	welmsg_len equ $-welmsg
	meanmsg db 10,"CALCULATED MEAN IS:-"
	meanmsg_len equ $-meanmsg
	sdmsg db 10,"CALCULATED STANDARD DEVIATION IS:-"
	sdmsg_len equ $-sdmsg
	varmsg db 10,"CALCULATED VARIANCE IS:-"
	varmsg_len equ $-varmsg
	array dd 100.08,200.16,300.32,400.48,500.64
	arraycnt dw 05
	dpoint db '.'
	hdec dq 100
	newline db 10

section .bss
	dispbuff resb 1
	resbuff rest 1
	mean resd 1
	variance resd 1
%macro disp 2
	mov rax,4		;System call for write
	mov rbx,1		;Specifies standard output
	mov rcx,%1		;Address of message to write
	mov rdx,%2		;Message lenght
	int 80h			;Invoke operating system to write
%endmacro
%macro accept 2
	mov rax,3		;System call for read
	mov rbx,0		;from standard input
	mov rcx,%1		;start address
	mov rdx,%2		;size
	int 80h			;Invoke operating system to Read
%endmacro

%macro exit 0
	mov rax,1		;System call for exit
	int 80h			;Invoke operating system to write
%endmacro exit

section .text
	global _start
_start:
	disp welmsg,welmsg_len	;display msg
	disp newline,1
	finit
	fldz
	mov rbx,array			;move array into rbx
	mov rsi,00			;clear rsi reg
	xor rcx,rcx			;clear rcx reg
	mov cx,[arraycnt]		;mov arraycnt into cx reg.
up:	fadd dword[rbx+rsi*4]		;perform sum of array elements
	inc rsi				;inc rsi
	loop up				;if rcx not equal to zero repeat
	fidiv word[arraycnt]		;calculate the mean
	fst dword[mean]			;store it
	disp meanmsg,meanmsg_len	;display msg
	call dispres			;call disperse
	MOV RCX,00			;clear rcx reg
	MOV CX,[arraycnt]		;initialize counter
	MOV RBX,array			;initialize  array pointer
	MOV RSI,00			;initialize offset pointer
	FLDZ
up1:	FLDZ
	FLD DWORD[RBX+RSI*4]
	FSUB DWORD[mean]
	FST ST1
	FMUL
	FADD
	INC RSI
	LOOP up1
	FIDIV word[arraycnt]
	FST dWORD[variance]
	FSQRT
	disp sdmsg,sdmsg_len
	CALL dispres
	FLD dWORD[variance]
	disp varmsg,varmsg_len
	CALL dispres
	disp newline,1
exit
disp8proc:
	mov rdi,dispbuff
	mov rcx,02
back:
	rol bl,04
	mov dl,bl
	and dl,0FH
	cmp dl,09
	jbe next1
	add dl,07H
next1:	add dl,30H
	mov [rdi],dl
	inc rdi
	loop back
	ret

dispres:
	fimul dword[hdec]
	fbstp tword[resbuff]
	mov rcx,09H
	mov rsi,resbuff+9
up2:
	push rcx
	push rsi
	mov bl,[rsi]
	call disp8proc
	disp dispbuff,2
	pop rsi
	dec rsi
	pop rcx
	loop up2
	disp dpoint,1
	mov bl,[resbuff]
	call disp8proc
	disp dispbuff,2
	disp newline,1
	ret


;cc-57@cc57-ThinkCentre-M70e:~$ nasm -f elf64 Exp12.asm
;cc-57@cc57-ThinkCentre-M70e:~$ ld -o Exp12 Exp12.o
;cc-57@cc57-ThinkCentre-M70e:~$ ./Exp12

;***WELCOME TO 64 BIT PROGRAMMING***

;CALCULATED MEAN IS:-000000000000000300.30

;CALCULATED STANDARD DEVIATION IS:-000000000000000141.31

;CALCULATED VARIANCE IS:-000000000000020057.37

;cc-57@cc57-ThinkCentre-M70e:~$
