extrn printf:far

Data segment "DATA"
    message     db "Hello, World!"
Data ends

Code segment "CODE"
_start:
    ret

Code ends
END _start
