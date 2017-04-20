.model tiny
.code
.stack 100

ORG 100H

BEGIN:   JMP TRANSIT


SAVE_INT0 DD?

HR db 00h         ;VARIABLE TO SAVE CURRENT TIME
MIN db 00h
SEC db 00h

HR1 db 00h        ;START TIME INTERVAL
MIN1 db 10h


RESD:
            PUSH AX     ;SAVE REGISTERS
            PUSH BX
            PUSH CX
            PUSH DX
            PUSH SI
            PUSH DI
            PUSH BP
            PUSH CS
            POP DS

           MOV AX,0B800H ;SET POINTER TO VIDEO RAM

MOV ES,AX
MOV DI,2000  ;SET OFFSET(40X25X2)
MOV AH,02     ;GET CURRENT TIME
INT 1AH
MOV HR,CH    ;SAVE HOURS
MOV MIN,CL   ;SAVE MINUTES
MOV SEC,DH   SAVE SECONDS



MOV AH,HR      ;CHECK WHEATHER KEY-PRESSES DURING
MOV AL,MIN    ;STIPULATED TIME
MOV BH,HR1
MOV BL,MIN1

CMP AX,BX
JB EXIT


MOV AH,HR
MOV AL,MIN
MOV BH,HR2
MOV BL,MIN2

CMP AX,BX
JG EXIT

MOV BH,HR       ;DISPLAY HOURS
CALL DIS

MOV AL,3AH     ;DISPLAY COLON:
MOV ES:[DI],AL
INC DI
ANC DI

MOV BH,MIN       ;DISPLAY MINUTES
CALL DIS

MOV AL,3AH        ;DISPLAY COLON
MOV ES:[DI],AL

INC DI
INC DI


MOV BH,SEC        ;DISPLAY SECONDS
CALL DIS

EXIT:

 POP BP                  ;RESTORE REGISTERS
POP DI
POP SI
POP DX
POP CX
POP BX
POP AX
JMP CS:SAVE_INTO


DIS PROG NEAR ;DISPLAY TIME BY CONVERTING IT TO ASCII

MOV AL,BH
AND AL,0F0H
MOV CL04H
SHR AL,CL
ADD AL,30H
MOV ES:[DI],AL

INC DI
INC DI
MOV AL,BH
AND AL,0FH
ADD AL,30H

MOV ES:[DI],AL
INC DI
INC DI
RET
ENDP


TRANSIT :
CLI
PUSH CS
POP DS
MOV AX,0003H
INT 10H

MOV AH,35H
MOV AL,09H
INT 21H
MOV WORD PTR SAVE_INT0,BX
MOV WORD PTR SAVE_INT0+2,ES

MOV AH,25H
MOV AL,09H
MOV DX,OFFSET RESD
INT 21H
MOV AH,31H
MOV AL,01H
MOV DX,OFFSET TRANSIT
INT 21H
STI
END
   