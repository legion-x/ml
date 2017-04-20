;Aim: Write a Program to simulate DOS TYPE commands

section .data
	fnotmsg db "FILE NOT FOUND...",10
	fnmsg_len equ $-fnotmsg
	newline db 10
	
section .bss
	fd_in resd 1
	fbuff resb 20
	fb_len equ $-fbuff
	act_len resd 1
	counter resb 1
	srcfile resb 80
%macro print 2
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 0x80
%endmacro
section .text
global _start
_start:
	
	pop ecx		;pop no.of arguments
	pop ecx		;pop exec command

	pop ecx		;pop source filename
	mov edx,00
up:
	cmp byte[ecx+edx],0
	jz l1
	inc edx
	jmp up
l1:
	xor edi,edi
	mov esi,ecx
				;save source filename
l2:
	mov al,byte[esi]
	mov byte[srcfile+edi],al
	inc edi
	inc esi
	dec edx
	jnz l2
				;open the file for reading

	mov eax,5
	mov ebx,srcfile
	mov ecx,0				;read,write and execute by all
	mov edx,0777
	int 80h				;call krrnal
	mov [fd_in],eax			
	bt eax,31
	jnc readfile
	print fnotmsg,fnmsg_len
	jmp exit

readfile:
	mov eax,3
	mov ebx,[fd_in]
	mov ecx,fbuff
	mov edx,fb_len
	int 80h
	mov [act_len],eax
	cmp eax,0
	je nxt1
						;write to the file
	print fbuff,[act_len]
	jmp readfile
	
nxt1:	mov eax,6				;close source file
	mov ebx,[fd_in]
	int 80h

exit:	mov eax,1
	mov ebx,0
	int 0x80


;cc-57@cc57-ThinkCentre-M70e:~$ nasm -f elf Exp10.asm
;cc-57@cc57-ThinkCentre-M70e:~$ ld -m elf_i386 -s -o h Exp10.o
;cc-57@cc57-ThinkCentre-M70e:~$ ./h
;Real and distinct roots
;Root 1:
;800000000000000001.00
;Root 2:
;800000000000000002.00
;cc-57@cc57-ThinkCentre-M70e:~$ nasm -f elf Exp8_1.asm
;cc-57@cc57-ThinkCentre-M70e:~$ ld -m elf_i386 -s -o h Exp8_1.o
;cc-57@cc57-ThinkCentre-M70e:~$ ./h myfile.txt
;Shatabdi Institute of Engg. & Research
;cc-57@cc57-ThinkCentre-M70e:~$ 


