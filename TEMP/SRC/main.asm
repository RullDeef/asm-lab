data segment "data" para
    db "DATA____START___"

    align 16
    string db "this is string", 0

    align 16
    dest db 16 dup(0)

    align 16
    db "DATA____END_____"
data ends

stack segment stack para
    db 100h dup('s')
stack ends

code segment "code"

main:
    mov ax, data
    mov ds, ax
    mov es, ax

    mov si, offset string
    mov di, offset dest

    mov cx, 16
    rep movsb

    mov ax, 4C00h
    int 21h
code ends
end main
