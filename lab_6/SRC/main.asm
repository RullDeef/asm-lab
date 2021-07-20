extrn   input_16cs: far,
        print_bin_unsigned: far,
        print_dec_signed: far

data segment "data"
    number dw ?
    options dd  input_16cs,
                print_bin_unsigned,
                print_dec_signed,
                exit

    menu db 13, 10, "Options:", 13, 10
    db "  1. Out in bin unsigned", 13, 10
    db "  2. Out in dec signed", 13, 10
    db "  3. Exit program", 13, 10
    db "> $"
data ends

stack segment stack
    dw 100h dup(?)
stack ends

code segment "code"
    assume ds:data

exit proc far
    mov ah, 4Ch
    int 21h
exit endp

main:
    mov ax, data
    mov ds, ax

    push ds
    call options[0]
    pop ds
    mov number, ax

    mainloop:
        mov ah, 09h
        mov dx, offset menu
        int 21h

        mov ah, 01h
        int 21h

        sub al, '0'
        mov bx, 4
        mul bl
        mov bl, al

        ; new line
        mov ah, 02h
        mov dl, 13
        int 21h
        mov dl, 10
        int 21h

        mov ax, number
        push ds
        call options[bx]
        pop ds
        
        jmp mainloop

code ends
end main