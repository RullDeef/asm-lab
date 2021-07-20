; главный модуль программы
extrn   print_newline: far,
        input_matrix: far,
        transform_matrix: far,
        output_matrix: far

stack segment stack
    db 10h dup(?)
stack ends

code segment public "code"
    assume cs:code

main:
    call input_matrix

    cmp ax, 0
    jne end_prog

    call print_newline
    call transform_matrix
    call output_matrix

end_prog:
    mov ah, 4Ch
    int 21h
code ends

end main
