;Aim: Write a Program to simulate DOS DELETE commands
	
section .data
	fnotmsg db "FILE NOT FOUND...",10
	fnmsg_len equ $-fnotmsg
	msg1 db "Deleted Successfully!",10
	len1 equ $-msg1
	
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
				;delete file
	mov eax,10		;system call 10;unlink
	mov ebx,srcfile	;file name to unlink
	int 80h			;call into the system
	
	print msg1,len1
exit:				;exit system call
	mov eax,1
	mov ebx,0
	int 0x80
	

;cc-57@cc57-ThinkCentre-M70e:~$ nasm -f elf Exp8_3.asm
;cc-57@cc57-ThinkCentre-M70e:~$ ld -m elf_i386 -s -o h Exp8_3.o
;cc-57@cc57-ThinkCentre-M70e:~$ ./h myfile2.txt
;Deleted Successfully!
;cc-57@cc57-ThinkCentre-M70e:~$
