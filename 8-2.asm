;Aim: Write a Program to simulate DOS COPY commands

section .data
	fnotmsg db "FILE NOT FOUND...",10
	fnmsg_len equ $-fnotmsg
	msg1 db "Copied Successfully!",10
	len1 equ $-msg1

	newline db 10
section .bss
	fd_in resd 1
	fd_out resd 1
	fbuff resb 20
	fb_len equ $-fbuff
	act_len resd 1
	srcfile resb 80
	destfile resb 80

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
	
	pop ecx 		;pop destination filename
	mov edx,00
up1:
	cmp byte[ecx+edx],0
	jz l11
	inc edx
	jmp up1
l11:
	xor edi,edi
	mov esi,ecx
				;save destination filename
l21:
	mov al,byte[esi]
	mov byte[destfile+edi],al
	inc edi
	inc esi
	dec edx
	jnz l21

;open the file for reading
		
	mov eax,5
	mov ebx,srcfile
	mov ecx,0
	mov edx,0777
	int 80h
	mov [fd_in],eax
	bt eax,31
	jnc conti1
	print fnotmsg,fnmsg_len
	jmp exit
conti1:

;open or create the file for writting
	mov eax,8
	mov ebx,destfile
	mov ecx,0777				;read,write and execute by all
	int 0x80				;call krrnal
	mov [fd_out],eax			;store the file descriptor

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
	mov eax,4				;system call number(sys_write)
	mov ebx,[fd_out]			;file descriptor
	mov ecx,fbuff				;message to write
	mov edx,[act_len]			;number of bytes
	int 0x80				;call kernel

	jmp readfile

nxt1:	mov eax,6			;close source file
	mov ebx,[fd_in]
	int 80h
	mov eax,6				;close destination file
	mov eax,[fd_out]
	int 80h
	print msg1,len1	

exit:						;exit system call
	mov eax,1
	mov ebx,0
	int 0x80

;cc-57@cc57-ThinkCentre-M70e:~$ nasm -f elf Exp8_2.asm
;cc-57@cc57-ThinkCentre-M70e:~$ ld -m elf_i386 -s -o h Exp8_2.o
;cc-57@cc57-ThinkCentre-M70e:~$ ./h myfile.txt myfile2.txt
;Copied Successfully!
;cc-57@cc57-ThinkCentre-M70e:~$ 
						
