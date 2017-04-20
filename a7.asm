section .data

	fname: db 'abc.txt',0

	msg: db "file opened successfully",0x0A
	len: equ $-msg


	msg1: db "file closed successfully",0x0A
	len1: equ $-msg1

	msg2: db "error in opening file",0x0A
	len2: equ $-msg2

	msg3: db "Original array is",0x0A
	len3: equ $-msg3

	msg4: db "Final array is",0x0A
	len4: equ $-msg4

	msg5: db "_________________________________",0x0A
	len5: equ $-msg5

section .bss
	fd: resb 17
	fdnew: resb 17
	buffer: resb 200
	buf_len: resb 17
	buffernew: resb 200
	buf_lennew: resb 17
	cnt: resb 2
	cnt2: resb 2
	;cnt3: resb 2
	;cha: resb 2

%macro mrp 4
	mov eax,%1
	mov ebx,%2
	mov ecx,%3
	mov edx,%4
	int 80h
%endmacro
;__________________________________________________________________________
section .text
	global _start
	_start:

	mov eax,5
	mov ebx,fname
	mov ecx,2
	mov edx,0777
	int 80h		

	mov dword[fd],eax
	test eax,31
	jc next
	mrp 4,1,msg,len
	jmp next2
next:
	mrp 4,1,msg2,len2

next2:
	mrp 3,[fd],buffer,200
	mov dword[buf_len],eax
	
	mrp 4,1,msg3,len3
	mrp 4,1,buffer,[buf_len]

;______________________________________________________________________________
;bubble sort
	mov byte[cnt2],5

up2:
	mov esi,buffer
	mov edi,buffer+1
	mov byte[cnt],5

up:
	mov al,byte[esi]
	cmp al,byte[edi]
	jg next3
	inc esi
	inc edi
	dec byte[cnt]
	jnz up
	jmp next4

next3:
	mov bl,byte[esi]
	mov cl,byte[edi]
	mov byte[edi],bl
	mov byte[esi],cl
	inc esi
	inc edi
	dec byte[cnt]
	jnz up

next4:
	dec byte[cnt2]
	jnz up2

	mrp 4,[fd],msg4,len4
	mrp 4,[fd],buffer,[buf_len]

	mov eax,6
	mov edi,[fd]
	int 80h

	mrp 4,1,msg1,len1
	mrp 4,1,msg5,len5
;__________________________________________________________________


	mov eax,4
	mov ebx,fname
	mov ecx,2
	mov edx,0777
	int 80h

	mov dword[fdnew],eax
	test eax,31
	jc next5
	;mrp 4,1,msg,len
	jmp next6
next5:
	mrp 4,1,msg2,len2
	jmp exit
next6:

	mrp 3,[fdnew],buffernew,200
	mov dword[buf_lennew],eax

	;mrp 4,1,msg3,len3
	;mrp 4,1,buffernew,[buf_lennew]

exit:
	mov eax,1
	mov ebx,0
	int 80h
