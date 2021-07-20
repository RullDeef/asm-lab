.model tiny
.code
.186

org 100h

start proc near
    mov ah, 35h
    mov al, 1Ch
    int 21h

    mov word ptr old_clock, bx
    mov word ptr old_clock + 2, es

    mov ah, 25h
    mov al, 1Ch
    mov dx, offset clock_wrapper
    int 21h

    ; wait key hit
    mov ah, 1
    int 21h

    ; return old handler back
    mov ah, 25h
    mov al, 1Ch
    mov dx, word ptr old_clock + 2
    mov ds, dx
    mov dx, word ptr cs:old_clock
    int 21h

    ret
start endp

; data
old_clock dd ?

clock_wrapper proc far
    pusha
    push ds

    push cs
    pop ds

    mov ah, 02h
    int 1Ah

    cmp cs:last_second, dh
    je no_update
    mov cs:last_second, dh

    ; called every second
    mov ah, 02h
    mov dl, 'a'
    int 21h

no_update:
    pop ds
    popa
    jmp cs:old_clock

last_second db 0
clock_wrapper endp

end start
