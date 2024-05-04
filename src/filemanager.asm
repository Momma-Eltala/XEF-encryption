bits 64
section .bss
filedescriptor1 resb 8
file1size resb 8
section .data
FDNXS db " Does not exist.", 0x00
fileexists db "Opened file < ", 0x00
ipfs db "Input file size is = ", 0x00
bytessize db " bytes", 0x00
section .text

file_open:
	mov rax, 2
	mov rdi, qword [filename]
	mov rsi, 0
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
	
	push newline
	push 0
	push bytessize
	push 0
	mov qword [file1size], rax
	push rax
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

