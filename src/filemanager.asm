bits 64
section .bss
perm resb 1
filedescriptor1 resb 8
filedescriptor2 resb 8
fileheader resb 4
file1size resb 8
section .data
askownertext db " is a file that exist. would you like to write over it? (N/or y) : ", 0x00
FDNXS db " Does not exist.", 0x00
fileexists db "Opened file < ", 0x00
ipfs db "Input file size is = ", 0x00
bytessize db " bytes", 0x00
exitbecausenotpermited db "Stopping program because not permited to overwrite ", 0x00
section .text

file_open:
	mov rax, 2
	mov rdi, qword [filename]
	mov rsi, 1
	mov rdx, 0
	syscall

	cmp rax, 3
	mov qword [filedescriptor1], rax
	jne FDNX

	push newline
	push 0
	push qword [filename]
	push 0
	push fileexists
	push 0
	push 3
	call print

	mov rax, 8
	mov rdi, qword [filedescriptor1]
	mov rsi, 0
	mov rdx, 2
	SYSCALL
	
	mov qword [file1size], rax

	mov rax, 8
	mov rdi, qword [filedescriptor1]
	mov rsi, 0
	mov rdx, 0
	syscall

	push newline
	push 0
	push bytessize
	push 0
	push qword [file1size]
	push 3
	push ipfs
	push 0
	push 4
	call print

	ret

	FDNX:
		push newline
		push 0
		push 38
		push 2
		push newline
		push 0
		push FDNXS
		push 0
		push qword [filename]
		push 0
		push 5
		call print

		mov rax, 60
		mov rdi, 38
		syscall

	fileopeniner:
		
		mov rax, 2
		mov rdi, qword [fileoutputname]
		mov rsi, 66
		mov rdx, 0644o
		syscall
	
		mov qword [filedescriptor2], rax
		
		mov rax, 0
		mov rdi, qword [filedescriptor2]
		mov rsi, fileheader
		mov rdx, 4
		syscall

		mov al, 0
		mov ah, byte [fileheader]
		cmp al, ah
		jne askownerset
		jmp noneed
		askownerset:
			call askowner
		noneed:
		mov rax, 8
		mov rdi, qword [filedescriptor2]
		mov rsi, 0
		mov rdx, 0
		syscall

		ret

		askowner:
			push askownertext 
			push 0
			push qword [fileoutputname]
			push 0
			push 2
			call print

			mov rax, 0
			mov rdi, 0
			mov rsi, perm
			mov rdx, 1
			syscall
			
			mov al, byte [perm]
			cmp al, "y"
			jne nopermitedexit
			
			ret

			nopermitedexit:
				push newline
				push 0
				push qword [fileoutputname]
				push 0
				push exitbecausenotpermited
				push 0
				push 3
				call print

				mov rax, 60
				mov rdi, 0
				syscall
