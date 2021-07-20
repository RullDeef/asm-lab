.model tiny
.186

.code
start proc near
    mov al, 0F3h
    out 60h, al
    mov al, 00h
    out 60h, al

    ret

    mov cx, 80
    _loop:
        mov ah, 1
        int 21h
        loop _loop

    ret
start endp

end start
