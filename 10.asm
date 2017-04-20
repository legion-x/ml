;Write 80387 ALP to find the roots of the quadratic equation. All the possible cases must
;be considered in calculating the roots

%macro print 2
	mov eax,4
	mov ebx,1
	mov ecx,%1	
	mov edx,%2
	int 80h
%endmacro
%macro read 2
	mov eax,3
	mov ebx,0
	mov ecx,%1	
	mov edx,%2
	int 80h
%endmacro
section .data
	msgA db "Enter value for 'a':",10
	lenA equ $-msgA
	msgB db "Enter value for 'b':",10
	lenB equ $-msgB
	msgC db "Enter value for 'c':",10
	lenC equ $-msgC
	msg1 db "Real and distinct roots",10
	len1 equ $-msg1
	msg2 db "Real and equal roots",10
	len2 equ $-msg2
	msg3 db "Complex roots",10
	len3 equ $-msg3
	msg4 db "Root 1:",10
	len4 equ $-msg4
	msg5 db "Root 2:",10
	len5 equ $-msg5
	msg6 db "Equal roots are:",10
	len6 equ $-msg6

	newline db 10
	TWO dd 2.0
	FOUR dd 4.0
	A dd 1.0
	B dd 3.0
	C dd 2.0
	decimalpoint db '.'
	decimal dq 100
section .bss
	avar resb 2
	var rest 1
	R1 resb 4
	R2 resb 4
	delta resb 4
	rtdelta resb 4
global _start
section .text
_start:
	finit				;Initialise 8087 coprocessor
	fld dword[B]
	fmul dword[B]		;b^2
	fld dword[A]
	fmul dword[C]
	fmul dword[FOUR]		;4ac
	fsub				;b^2-4ac
	fst dword[delta]		;store delta
	fmul dword[decimal]		;Check MSB of the delta
	fbstp tword[var]
	mov esi,var+9
	mov bl,04h
	and bl,0Fh
	cmp bl,08h
	jne next
	print msg3,len3		;Complex roots
	jmp exit
next:
	cmp dword[delta],0
	jne next2
	print msg2,len2		;Real and Equal roots
	print msg6,len6
	jmp next4
next2:
	print msg1,len1		;Real and Equal roots
	
next3:	
	fld dword[delta]		;calculate root 1
	fsqrt
	fst dword[rtdelta]
	fsub dword[B]
	fdiv dword[A]
	fdiv dword[TWO]
	print msg4,len4
            call display

           print msg5,len5
next4:
          fldz                                    ;calculate root 2
         fsub  dword[rtdelta]
         fsub dword[B]
         fdiv  dword[A]
         fdiv dword[TWO]
         call display
exit:                                         ;exit system call
       mov eax,1
       mov ebx,0
       int 0x80
display:
      fimul dword[decimal]
      fbstp tword[var]
     mov ecx,09h
            mov esi,var+9
back3:  push ecx
            push esi
            mov bl,byte[esi]
            call ascii
            print avar,2
            pop esi
            dec esi
           pop ecx
           loop back3
           print decimalpoint,1          ; printing decimal point
           mov bl,[var]
           call ascii
           print avar,2
           print newline,1   
           ret
ascii:                                            ;procedure to convert  into ascii
         mov edi,avar
         mov ecx,02

back2:  rol bl,04h
            mov dl,bl
            AND dl,0Fh
            cmp dl,09h
            jbe next1
            add dl,7h
next1:
          add dl,30h
          mov[edi],dl
          inc edi
          loop back2
          ret

;cc-57@cc57-ThinkCentre-M70e:~$ nasm -f elf Exp10.asm
;cc-57@cc57-ThinkCentre-M70e:~$ ld -m elf_i386 -s -o h Exp10.o
;cc-57@cc57-ThinkCentre-M70e:~$ ./h
;Real and distinct roots
;Root 1:
;800000000000000001.00
;Root 2:
;800000000000000002.00
;cc-57@cc57-ThinkCentre-M70e:~$
