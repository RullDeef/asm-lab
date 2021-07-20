.686
.model flat, c

public copy_string

.stack

.code
    copy_string proc
        push ebp
        mov ebp, esp

        mov esi, [ebp +  8] ; source string
        mov edi, [ebp + 12] ; dest string
        mov ecx, [ebp + 16] ; size

        cmp esi, edi
        je end_coping
        jg no_bad_overlapping

        ; bad overlapping - copy from end
        std
        add esi, ecx
        add edi, ecx

        no_bad_overlapping:
            inc ecx
            rep movsb

        end_coping:
            cld
            pop ebp
            ret
    copy_string endp
end
