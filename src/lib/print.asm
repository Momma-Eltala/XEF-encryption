bits 64
section .data
hexstart db "0X"
hexvalues db "0123456789ABCDEF"
section .bss
hex8bytereg resb 8
hexvaluetxt resb 16
section .text
print:
	pop rax
	mov r9, rax
		printm:
		pop rcx
		mov r8, rcx
		cmp rcx, 0x00
		jne morearg
		push r9
		ret
morearg:
	pop rax
	cmp rax, 0x00
	je Sprint
	cmp rax, 0x01
	je Bprint
	cmp rax, 0x02
	je H8print
nextprint:
	mov rcx, r8
	dec rcx
	push rcx
jmp printm
    Sprint:
        mov rax, [rsp]
        mov rbx, 0
    _Sprintloop:
        inc rax
        inc rbx
        mov cl, byte [rax]
        cmp cl, 0
        jne _Sprintloop

        mov rax, 1
        mov rdi, 1
        pop rsi
        mov rdx, rbx
        syscall

        jmp nextprint

   Bprint:
        mov rax, 1
        mov rdi, 1
        pop rdx
        pop rsi
        syscall
        jmp nextprint
	
	H8print:
		mov rax, 1
		mov rdi, 1
		mov rsi, hexstart
		mov rdx, 2
		syscall
		H8printloopstart:
			pop rbx
			mov rcx, 16
			mov rdx, hexvaluetxt
			add rdx, 15
			H8printloop:
			push rbx
			and rbx, 0x0F
			mov rax, rbx
			add rax, hexvalues
			mov al, byte [rax]
			mov byte [rdx], al
			dec rdx
			dec rcx
			pop rbx
			shr rbx, 4
			cmp rcx, 0x00
			jne H8printloop

			mov rax, 1
			mov rdi, 1
			mov rsi, hexvaluetxt
			mov rdx, 16
			syscall
			jmp nextprint
