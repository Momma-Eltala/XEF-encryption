main: ./src/main.asm makebin
	nasm -f elf64 -O0 -g ./src/main.asm -o ./bin/main.o 

makebin: ./bin/main.o
	ld ./bin/main.o -o ./bin/main

clean:
	rm ./bin/main
	rm ./bin/main.o
