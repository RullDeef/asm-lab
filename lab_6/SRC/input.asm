public input_16cs

data segment "data"
    buffer_len equ 80
    prompt db "Input number in hex: $"

    buffer_start db buffer_len
    buffer_size db ?
    buffer db buffer_len dup(?), "$"
data ends

code segment "code" para
    assume ds:data

; saves inputed number in ax
input_16cs proc far
    mov ax, data
    mov ds, ax

    mov ah, 09h
    mov dx, offset prompt
    int 21h

    mov ah, 0Ah
    mov dx, offset buffer_start
    int 21h

    xor ax, ax
    mov bx, 10h
    xor cx, cx
    mov cl, buffer_size
    mov si, offset buffer

    collect_num_loop:
        mul bx
        mov dl, ds:[si]

        cmp dl, '9'
        jbe dec_digit
        sub dl, 'A' - 10
        jmp continue_loop

        dec_digit:
        sub dl, '0'

        continue_loop:
        mov dh, 0
        add ax, dx
        inc si
        loop collect_num_loop
    ret
input_16cs endp

code ends
end
