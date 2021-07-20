StkSeg  SEGMENT PARA STACK "STACK"
        DB      200h DUP(?)
StkSeg  ENDS

DataS   SEGMENT WORD "DATA"
HelloMessage    DB 13
                DB 10
                DB "Hello, World!$"
DataS   ENDS

Code    SEGMENT WORD "CODE"
        ASSUME CS:Code, DS:DataS
DispMsg:
        MOV AX, DataS
        MOV DS, AX
        MOV DX, OFFSET HelloMessage
        MOV AH, 9

        MOV CX, 3
loop_label:
        INT 21h
        LOOP loop_label

        MOV AH, 7
        INT 21h
        MOV AH, 4Ch
        INT 21h
Code    ENDS
        END     DispMsg
