section .bss
filename resb 8
section .data
I db "is not an valid file"
valid db "is a valid file"
section .text
file_check:
    test rax, rax
    js failed0x111
    jmp sucess0x111
    failed0x111:
        mov rax, I
        call Sprint
        ret
    sucess0x111:
        mov rax, valid
        call Sprint
        ret

    