; модуль для работы с матрицей
public  input_matrix,
        transform_matrix,
        output_matrix

extrn   print_newline: far,
        print_dims_prompt: far,
        print_mat_prompt: far,
        print_out_prompt: far,
        print_error_msg: far

; сегмент для хранения матрицы 9х9
data segment "data"
    mat_rows db ?
    mat_cols db ?
    matrix db 81 dup("+")
data ends

; сегмент с функциями модуля
code segment public "code"
    assume cs:code, ds:data

; static _mat_at: bl - row, bh - col
; returns: bx - offset for element at row & col
_mat_at proc near ; uses ax,
    push ax

    xor ax, ax      ; ax = 0
    mov al, bl      ; al = row
    mul mat_cols    ; ax = al * mat_cols
    xchg bh, bl
    mov bh, 0
    add bx, ax
    add bx, offset matrix

    pop ax
    ret
_mat_at endp

input_matrix proc far
    call print_dims_prompt

    mov ax, data
    mov ds, ax

    ; ввод размеров матрицы
    mov ah, 01h
    int 21h
    sub al, '0'

    ; проверка корректности ввода
        cmp al, 0
        ja check_2
        jmp bad_input

        check_2:
            cmp al, 10
            jb end_check

    bad_input:
        ; print "bad input"
        call print_newline
        call print_error_msg
        mov ax, 1
        ret

end_check:
    mov mat_rows, al
    mov mat_cols, al

    call print_newline

    push ds
    call print_mat_prompt
    pop ds

    ; ввод матрицы построчно
    xor cl, cl
    row_loop:
        mov ah, 01h
        xor ch, ch
        col_loop:
            mov bx, cx
            call _mat_at

            int 21h
            mov [bx], al

            inc ch
            cmp ch, mat_cols
            jne col_loop

        call print_newline

        inc cl
        cmp cl, mat_rows
        jne row_loop

    xor ax, ax
    ret
input_matrix endp

transform_matrix proc far
    mov ax, data
    mov ds, ax

    cmp mat_rows, 1
    je no_action

    mov bl, 1 ; row
    mov bh, 0 ; col
    call _mat_at
    mov dl, [bx]

    xor cx, cx
    loop_top:
        mov bx, cx
        call _mat_at
        xchg dl, [bx]

        inc ch
        cmp ch, mat_cols
        jne loop_top

    inc cl
    dec ch
    loop_right:
        mov bx, cx
        call _mat_at
        xchg dl, [bx]

        inc cl
        cmp cl, mat_rows
        jne loop_right

    dec cl
    dec ch
    loop_bottom:
        mov bx, cx
        call _mat_at
        xchg dl, [bx]

        dec ch
        cmp ch, 0
        jg loop_bottom

    loop_left:
        mov bx, cx
        call _mat_at
        xchg dl, [bx]

        dec cl
        cmp cl, 0
        jne loop_left

no_action:
    ret
transform_matrix endp

output_matrix proc far
    call print_out_prompt
    mov ax, data
    mov ds, ax

    mov ah, 06h
    xor cl, cl
    row_loop:
        xor ch, ch
        col_loop:
            mov bx, cx
            call _mat_at

            mov dl, [bx]
            int 21h

            inc ch
            cmp ch, mat_cols
            jne col_loop

        call print_newline

        inc cl
        cmp cl, mat_rows
        jne row_loop

    ret
output_matrix endp
code ends

end
