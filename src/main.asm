bits 64
%include "./src/lib/print.asm"
%include "./src/lib/memoryman.asm"
section .data
done db "Everything worked as intended.", 0x0a, 0
error1 db " is not an valid operation!", 0x0a
newline db 0x0a
section .text
Global _start
_start:
    mov rdx, [rsp+16]
    cmp [rdx], byte "-"
    jne invalid
    jmp exitsuc
invalid:
    push error1
    push 0
    push rdx
    push 0
    push 2
    call print
    push newline
    push 0
    push 0x100
    push 2
    push 2
    call print
    mov rax, 60
    mov rdi,0x100
    syscall
    ret

exitsuc:
    push done
    push 0
    push 1
    call print
    mov rax, 60
    mov rdi, 0
    syscall
    ret
