;Calculate factorial of a given number(command line input)

section .data
	msg1 db "Factorial of a given number is"
	len1 equ $-msg1
	msg2 db "Gievn number is:"
	len2 equ $-msg2
	msg0 db "factorial of a given number is :",10
	len0 equ $-msg0
	msg3 db "error",10
	len3 equ $-msg3
	newline db 10
	factorial dd 1
section .bss
	final resb 8
	result resb 4
	counter resb 4
	num resb 4
	numh resb 4
	numlen resb 4
					;macro to write
%macro print 2
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 0x80
%endmacro
					;macro to read
%macro read 2
	mov eax,3
	mov ebx,0
	mov ecx,%1
	mov edx,%2
	int 0x80
%endmacro
section .text
	global _start
_start:
	xor eax,eax
	mov dword[num],eax

	print msg2,len2
	pop ecx	;pop no. of argument
	pop ecx	;pop exec command
	pop ecx	;pop given number
	mov edx,00
up:
	cmp byte[ecx+edx],0
	jz l1
	inc edx
	jmp up
l1:
	mov esi,ecx			;printing the number form command line
	mov eax,dword[esi]
	mov dword[num],eax
	mov dword[numlen],edx
	print num,dword[numlen]
	print newline,1

	mov esi,num
	call packnum			;convert the ascii number to hex
	mov dword[numh],ebx
	cmp dword[numh],0
	jne next2
	print msg0,len0		;print factorial of 0
	jmp exit
next2:
	mov ecx,dword[numh]
	call facto
	
	mov edx,dword[factorial]	;print factorial of the number
	mov dword[result],edx
	call ascii
print msg1,len1
	print final,8
	print newline,1
exit:					;exit system call
	mov eax,1
	mov ebx,0
	int 0x80
	
packnum:				;function to cinevrt form ascii to hex
	mov eax,0
	mov ecx,dword[numlen]
	mov dword[counter],ecx
	mov ebx,0
back:
	mov al,[esi]
	rol ebx,4
	cmp al,39h
	jbe next
	sub al,7h
next:
	sub al,30h
	or bl,al
	inc esi
	dec dword[counter]
	jnz back
	ret
ascii:					;function to convert hex to ascii
	mov esi,final
	mov dword[counter],8
	mov eax,dword[result]
bck2:
	mov ebx,eax
	rol ebx,04
	mov eax,ebx
	and bl,0Fh
	cmp bl,9h
	jbe next1
	add bl,7h
next1:
	add bl,30h
	mov [esi],ebx
	inc esi
	dec dword[counter]
	jnz bck2
	ret
facto:					;function to find factorisl of given number
	push ecx			;push value from ecx into stack
	cmp ecx,01			;if value equal to 1, step recursion
	jne next3
	jmp exit1
next3:dec ecx
	call facto			;recursive call
exit1:   
	pop ecx			;pop value from stack into ecx
	mov eax,ecx
	mul dword[factorial]		;perform multiplication
	mov dword[factorial],eax	;stroe product into factorial
	ret	


;cc-57@cc57-ThinkCentre-M70e:~$ nasm -f elf Exp9.asm
;cc-57@cc57-ThinkCentre-M70e:~$ ld -m elf_i386 -s -o m Exp9.o
;cc-57@cc57-ThinkCentre-M70e:~$ ./m 4
;Gievn number is:4
;Factorial of a given number is00000018
;cc-57@cc57-ThinkCentre-M70e:~$ 

