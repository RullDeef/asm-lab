public print_dec_signed

data segment "data"
    db 5 dup(?)
    digits_stack db 13, 10, '$'
data ends

code segment "code"
    assume ds:data
; prints signed integer stored in ax in dec form
print_dec_signed proc far
    mov bx, ax

    mov ax, data
    mov ds, ax

    mov di, offset digits_stack

    ; handle sign output
    cmp bx, 0
    jge digit_loop
    neg bx
    mov ah, 02h
    mov dl, '-'
    int 21h

    digit_loop:
        xor dx, dx
        mov ax, bx
        mov bx, 10
        div bx
        mov bx, ax

        add dl, '0'
        dec di
        mov [di], dl

        cmp bx, 0
        jg digit_loop

    ; print digits in reverse order from 'stack' with new line
    mov ah, 09h
    mov dx, di
    int 21h

    ret
print_dec_signed endp
code ends
end
