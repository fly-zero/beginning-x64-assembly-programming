fromc: fromc.c rect.o circle.o sreverse.o adouble.o asum.o
	gcc -o fromc $^ -no-pie

%.o: %.asm
	nasm -f elf64 -g -F dwarf $< -l %.lst