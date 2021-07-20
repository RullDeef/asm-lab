; модуль для вывода разного рода сообщений
public  print_newline,
        print_dims_prompt,
        print_mat_prompt,
        print_out_prompt,
        print_error_msg

data segment "data"
    dims_prompt db "Enter square matrix dimension [1...9]: $"
    mat_prompt db "Enter matrix elements:", 13, 10, "$"
    out_prompt db "Output matrix:", 13, 10, "$"
    error_msg db "Bad input! Please restart program", 13, 10, "$"
data ends

code segment public "code"
    assume cs:code, ds:data

print_newline proc far
    mov ah, 06h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    ret
print_newline endp

print_dims_prompt proc far
    mov ax, data
    mov ds, ax
    mov ah, 09h
    mov dx, offset dims_prompt
    int 21h
    ret
print_dims_prompt endp

print_mat_prompt proc far
    mov ax, data
    mov ds, ax
    mov ah, 09h
    mov dx, offset mat_prompt
    int 21h
    ret
print_mat_prompt endp

print_out_prompt proc far
    mov ax, data
    mov ds, ax
    mov ah, 09h
    mov dx, offset out_prompt
    int 21h
    ret
print_out_prompt endp

print_error_msg proc far
    mov ax, data
    mov ds, ax
    mov ah, 09h
    mov dx, offset error_msg
    int 21h
    ret
print_error_msg endp
code ends

end
