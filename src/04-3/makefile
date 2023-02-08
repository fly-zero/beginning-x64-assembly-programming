hello: hello.o
	gcc -o $@ hello.o -no-pie

hello.o: hello.asm
	nasm -f elf64 -g -F dwarf $< -l hello.lst