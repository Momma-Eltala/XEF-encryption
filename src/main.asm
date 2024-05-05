bits 64
%include "print.asm"
%include "memoryman.asm"
%include "filemanager.asm"
%include "encryptionhandler.asm"
section .data
helppagetextline1 db "--help prints this", 10
helppagetextline2 db "-f File that you want to encypt/or decypt", 10
helppagetextline3 db "-p Password", 10
helppagetextline4 db "-o file's output name (only for encyption)", 10
helppagetextline5 db "-e encypt option", 10
helppagetextline6 db "-d decypt option", 10, 0
done db "Everything worked as intended.", 0x0a, 0
error1 db " is not an valid operation!", 0x0a, 0
nooptions db "No arguments detected.", 0x0a, 0x00
newline db 0x0a, 0x00
section .text
Global _start
_start:
    pop rax
    cmp rax, 1
    je closenoop 
    mov r15, rax
        pop rax
        xor rax, rax
        dec r15
    nextargument:
        cmp r15, 0
        je main
        pop rdx
        mov r13, rdx

    arguments:

        mov al, "-"
        cmp al, byte [rdx]
        jne invalid 
        inc rdx
        mov al, byte [rdx]
        cmp al, "f"
        je filenameset
        cmp al, "p"
        cmp al, "o"
	je filenoutset
        cmp al, "e"
	je encryptionsetup
        cmp al, "d"
	je decryptionsetup
        cmp al, "-"
        je longarg
        jmp invalid

	encryptionsetup:
		mov al, 1
		dec r15
		mov byte [e_b], al
		jmp nextargument

	decryptionsetup:
		mov al, 0
		dec r15
		mov byte [e_b], al
		jmp nextargument

        longarg:
            inc rdx
            mov r14, rdx
            mov al, byte [rdx]
            cmp al, "h"
            jne invalid
            inc rdx
            mov al, byte [rdx]
            cmp al, "e"
            jne invalid
            inc rdx
            mov al, byte [rdx]
            cmp al, "l"
            jne invalid
            inc rdx
            mov al, byte [rdx]
            cmp al, "p"
            jne invalid
            push helppagetextline1
            push 0
            push 1
            call print
            jmp exitsuc

        filenameset:
            pop rax
            mov [filename], rax
            dec r15
            dec r15
	    call file_open
	    jmp nextargument
		
	filenoutset:
            pop rax
            mov [fileoutputname], rax
            dec r15
            dec r15
	    call fileopeniner
	    jmp nextargument

invalid:
    push newline
    push 0
    push 0x100
    push 2
    push error1
    push 0
    push r13
    push 0
    push 4
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

closenoop:
    push newline
    push 0
    push 0x404
    push 2
    push nooptions
    push 0
    push 3
    call print

    xor rax, rax
    mov al, 60
    xor rdi, rdi
    mov di, 404
    syscall



main:
	mov rax, 4
	mov rdi, done
	mov rdx, 0
	call filewrite
	
	call exitsuc
	mov ah, byte [e_b]
	mov al, 0x00
	cmp al, ah
	jne encrypt
	jmp decrypt
