public print_bin_unsigned

code segment "code"

; outputs number stored in ax in binary form
print_bin_unsigned proc far
    mov bx, ax

    mov ah, 02h

    mov cx, 16
    output_loop:
        rol bx, 1
        jc cf_set

        mov dl, '0'
        jmp cf_not_set

        cf_set:
        mov dl, '1'

        cf_not_set:
        int 21h
        loop output_loop

    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    ret
print_bin_unsigned endp

code ends
end
