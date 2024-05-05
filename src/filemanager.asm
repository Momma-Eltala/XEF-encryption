bits 64
section .bss
perm resb 1
filedescriptor1 resb 8
filedescriptor2 resb 8
fileheader resb 4
file1size resb 8
offsetoffile resb 8
tempo1 resb 8
tempo2 resb 8
section .data
askownertext db " is a file that exist. would you like to write over it? (N/or y) : ", 0x00
FDNXS db " Does not exist.", 0x00
fileexists db "Opened file < ", 0x00
ipfs db "Input file size is = ", 0x00
bytessize db " bytes", 0x00
exitbecausenotpermited db "Stopping program because not permited to overwrite ", 0x00
header db 0x01, "XEF"
filer db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
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
		call headermake

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
				

filewrite:
	;RAX | will be used to store where we will write, the offset of the file
	;RDI | string location
	;RDX | how how many bytes to write, if 0 will find out on its own will add a null at the end
	;This is a call function

	mov qword [offsetoffile], rax
	mov qword [tempo1], rdi
	mov qword [tempo2], rdx
	
	mov rax, 8
	mov rdi, qword [filedescriptor2]
	mov rsi, qword [offsetoffile]
	mov rdx, 0
	syscall

	mov rax, qword [tempo2]
	cmp rax, 0
	jne ignorefindinglength
	call findlengthofstringforXEF
	
	ignorefindinglength:
	mov rax, 1
	mov rdi, qword [filedescriptor2]
	mov rsi, qword [tempo1]
	mov rdx, qword [tempo2]
	syscall
	
	ret
headermake:
	mov rax, 1
	mov rdi, 4
	mov rsi, header 
	mov rdx, 4
	syscall

	mov rax, 8
	mov rdi, qword [filedescriptor2]
	mov rsi, 0
	mov rdx, 0
	syscall

	ret

findlengthofstringforXEF:
	xor rcx, rcx
	mov cl, 0
	xor rdx, rdx
	mov rax, qword [tempo1]

	findlengthofstringforXEFloop:

	cmp cl, byte [rax]
	je findlengthofstringforXEFdone
	inc rax
	inc rdx
	jmp findlengthofstringforXEFloop 

	findlengthofstringforXEFdone:
	inc rdx
	mov qword [tempo2], rdx
	ret
