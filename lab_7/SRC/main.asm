.model tiny
.code

org 100h

start proc near
    jmp init_block

    old_clock dd ? ; old 1Ch handler
    last_second db 0
    counter db 0

    clock_wrapper proc far
        push ax
        push cx
        push dx

        mov ah, 02h
        int 1Ah

        cmp cs:last_second, dh
        je no_update
        mov cs:last_second, dh

        ; update every second
        mov al, 0F3h
        out 60h, al

        mov al, cs:counter
        inc al
        and al, 11111b
        out 60h, al
        mov cs:counter, al

    no_update:
        pop dx
        pop cx
        pop ax
        jmp cs:old_clock
    clock_wrapper endp

init_block:
    mov ax, 351Ch
    int 21h

    mov word ptr old_clock, bx
    mov word ptr old_clock + 2, es

    mov ax, 251Ch
    mov dx, offset clock_wrapper
    int 21h

    mov ax, 3100h ; end as resident
    mov dx, offset init_block
    int 21h
start endp

end start
