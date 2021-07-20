EXTRN Input: NEAR, CopySyms: NEAR

MAGIC_DATA SEGMENT "DATA" PUBLIC
    MagicVar DB 4 DUP(?)
MAGIC_DATA ENDS

STACK SEGMENT STACK
    DB 100h DUP(?)
STACK ENDS

KODE SEGMENT "CODE" PUBLIC
    ASSUME DS:MAGIC_DATA
Main:
    CALL Input

    MOV AX, MAGIC_DATA
    MOV DS, AX

    ; скопировать 4 символа 
    MOV DX, OFFSET MagicVar
    MOV CX, 4
    CALL CopySyms

    ; вывести второй символ
    MOV AH, 06h
    MOV DL, MagicVar[1]
    INT 21h

    MOV AH, 4Ch
    INT 21h
KODE ENDS

END Main
