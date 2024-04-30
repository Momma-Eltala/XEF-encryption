bits 64
%include "./src/lib/print.asm"
%include "./src/lib/memoryman.asm"
section .data
done db "Everything worked as intended.", 0x0a, 0
error1 db " is not an valid operation!"
section .text
Global _start
_start:
    mov rdx, [rsp+16]
    cmp [rdx], byte "-"
    jne invalid
    jmp exitsuc
invalid:
    mov rax, rdx
    call Sprint
    mov rax, error1
    call Sprint
    mov rax, 60
    mov rdi,0x100
    syscall
    ret

exitsuc:
    mov rax, done
    call Sprint
    mov rax, 60
    mov rdi, 0
    syscall
    ret