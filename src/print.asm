bits 64
section .data
hexstart db "0X"
hexvalues db "0123456789ABCDEF"
section .bss
digitSpace resb 100
digitSpacePos resb 8
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
	cmp rax, 0x03
	je iprint
	
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

	iprint:

		pop rax
		jmp _printRAX
				
			
		_printRAX:
			mov rcx, digitSpace
			inc rcx
			mov [digitSpacePos], rcx
			
			_printRAXLoop:
				mov rdx, 0
				mov rbx, 10
				div rbx
				push rax
				add rdx, 48
			
				mov rcx, [digitSpacePos]
				mov [rcx], dl
				inc rcx
				mov [digitSpacePos], rcx
				
				pop rax
				cmp rax, 0
				jne _printRAXLoop
				
				_printRAXLoop2:
					mov rcx, [digitSpacePos]
				
					mov rax, 1
					mov rdi, 1
					mov rsi, rcx
					mov rdx, 1
					syscall
				
					mov rcx, [digitSpacePos]
					dec rcx
					mov [digitSpacePos], rcx
				
					cmp rcx, digitSpace
					jge _printRAXLoop2

					cleardigitspace:
					xor rax, rax
					mov rbx, digitSpace
					xor rcx, rcx
					mov cl, 100

					clearloop:
						cmp rcx, 0
						je clearloopdone
						mov byte [rbx], al
						inc rbx
						dec rcx
						jmp clearloop

					clearloopdone:
						jmp nextprint
