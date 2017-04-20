section .data
file_name db "myfile.txt",0
fnotmsg db "FILE NOT FOUND.....",10
fnotmsg_len equ $-fnotmsg
openmsg db "FILE OPENED SUCESSFULLY...!",10
openmsg_len equ $-openmsg
filemsg db "FILE CONTENTS ARE:-",10
filemsg_len equ $-filemsg
opmsg db "Enter the character:-",10
opmsg_len equ $-opmsg
msg1 db "Number of blank spaces:-"
msg1_len equ $-msg1
msg2 db "Number of Lines:-"
msg2_len equ $-msg2
msg3 db "Number of Occurances:-"
msg3_len equ $-msg3


newline db 10
bs dd 0h
nl dd 0h
chc dd 0h

section .bss
final resb 8
result resb 4
counter resb 4
fd_in resd 1
fbuff resb 20
fb_len equ $-fbuff
act_len resd 1
ch1 resb 1

%macro  print   2
	mov 	eax,4			
  	mov 	ebx,1			
   	mov 	ecx,%1			
   	mov 	edx,%2			
   	int 80h		
%endmacro
%macro  read   2
	mov 	eax,3		
  	mov 	ebx,0			
   	mov 	ecx,%1			
   	mov 	edx,%2			
   	int 80h	
%endmacro
section .txt
global _start
_start:
print opmsg,opmsg_len
read ch1,1

	mov 	eax,5			
  	mov 	ebx,file_name		
   	mov 	ecx,0		
   	mov 	edx,0777			
   	int 80h	
mov [fd_in],eax
bt eax,31
jnc counti1
print fnotmsg,fnotmsg_len
jmp exit
counti1:
	print openmsg,openmsg_len
	print filemsg,filemsg_len

readfile:
	mov 	eax,3		
  	mov 	ebx,[fd_in]		
   	mov 	ecx,fbuff
   	mov 	edx,fb_len			
   	int 80h	

mov [act_len],eax
mov dword[counter],eax
cmp eax,0
je nxt1
mov esi,0

back2:
cmp byte[fbuff+esi],''
jne nxt3
inc byte[bs]
nxt3:
	mov bl,byte[ch1]
	cmp byte[fbuff+esi],bl
	jne nxt2
	inc byte[chc]
nxt2:
	cmp byte[fbuff+esi],10
	jne nxt
	inc byte[nl]
nxt:
	inc esi
	dec byte[counter]
	jnz back2
	print fbuff,[act_len]
	jmp readfile

nxt1:
	mov eax,6
	mov ebx,[fd_in]
	int 80h

	print msg1,msg1_len
	mov eax,dword[bs]
	mov dword[result],eax
	call ascii
	print final,8
	print newline,1

	print msg2,msg2_len
	mov eax,dword[nl]
	mov dword[result],eax
	call ascii
	print final,8
	print newline,1

	print msg3,msg3_len
	mov eax,dword[chc]
	mov dword[result],eax
	call ascii
	print final,8
	print newline,1
exit:
	mov 	eax,1	
  	mov 	ebx,0			
   	int 80h	
ascii:
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

;cc-57@cc57-ThinkCentre-M70e:~$ nasm -f elf Exp5.asm
;cc-57@cc57-ThinkCentre-M70e:~$ ld -m elf_i386 -s -o m Exp5.o
;cc-57@cc57-ThinkCentre-M70e:~$ ./m
;Enter the character:-
;a
;FILE OPENED SUCESSFULLY...!
;FILE CONTENTS ARE:-
;Hello World.
;A microprocessor is an electronic component that is used by a computer to do its work.
;It is a central processing unit on a single integrated circuit.
;Number of blank spaces:-0000001A
;Number of Lines:-00000003
;Number of Occurances:-00000007
;cc-57@cc57-ThinkCentre-M70e:~$ 




