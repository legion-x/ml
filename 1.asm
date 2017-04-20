section .data
welmsg db 10,'To Count Positive and Negative Numbers in Array',10
	welmsg_len equ $-welmsg
	posmsg1 db 10,'Count of Positive Numbers::'
	posmsg1_len equ $-posmsg1
	negmsg2 db 10,'Count of Negative Numbers::'
	negmsg2_len equ $-negmsg2

	array dw 8505h,90ffh,8700h,7800h,8a9fh,0a0dh,0200h
	arrcnt equ 07h
	
section .bss
	poscnt resb 01
	negcnt resb 01
	dispbuff resb 03

%macro dispmsg 2
	mov eax,04
	mov ebx,01
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro

section .text
	global _start
	_start:
	
	dispmsg welmsg,welmsg_len	
	mov esi, array
	mov ecx, arrcnt
	
up:	bt word[esi], 31
	jnc pnext
	inc byte[negcnt]
	jmp pskip

pnext:	inc byte[poscnt]
pskip:	inc esi
	inc esi
	loop up

	dispmsg posmsg1,posmsg1_len
	mov bl, [poscnt]
	call disp8_proc

	dispmsg negmsg2,negmsg2_len
	mov bl, [negcnt]
	call disp8_proc

	mov eax,01 ;Exit
	mov ebx,00
	int 80h

disp8_proc:
	mov ecx,2
	mov edi,dispbuff
dup1:
	rol bl,4
	mov al,bl
	and al,0fh
	cmp al,09
	jbe dskip
	add al,07h
dskip: 	add al,30h
	mov [edi],al
	inc edi
	loop dup1

	dispmsg dispbuff,3
	ret

