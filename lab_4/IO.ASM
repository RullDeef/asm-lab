PUBLIC Input, CopySyms

StrBuffSize EQU 80

; сегмент с данными для хранения введёной строки
DATA SEGMENT "DATA" PUBLIC
    Prompt DB "Input string: $"
    NewLine DB 13, 10, '$'
    StrBuffStart DB StrBuffSize
    StrBuffLen DB ?
    StrBuff DB StrBuffSize DUP(0)
DATA ENDS

KODE SEGMENT "CODE" PUBLIC
; выводит приглашение для ввода, считывает ввод.
Input PROC NEAR
    MOV AX, DATA
    MOV DS, AX

    ; отобразить приглашение ко вводу
    MOV AH, 09h
    MOV DX, OFFSET Prompt
    INT 21h

    ; ввести строку
    MOV AH, 0Ah
    MOV DX, OFFSET StrBuffStart
    INT 21h

    ; вывести символы перехода на новую строку
    MOV DX, OFFSET NewLine
    MOV AH, 09h
    INT 21h

    ; можно сделать проверку ввода (нужно 4+ символа)
    ; код ошибки вернуть в AH

    ; MOV AH, 0
    ; CMP StrBuffLen, 4
    ; JGE no_err_label
    ; MOV AH, 1
    ; no_err_label:

    RET
Input ENDP

; Копирует первые CX символов строки StrBuff в DS:DX
CopySyms PROC NEAR
    MOV AX, DATA
    MOV ES, AX

    XOR SI, SI
    MOV DI, DX
loop_label:
    MOV AH, ES:StrBuff[SI]
    MOV DS:[DI], AH
    INC DI
    INC SI
    LOOP loop_label

    RET
CopySyms ENDP

KODE ENDS

END
