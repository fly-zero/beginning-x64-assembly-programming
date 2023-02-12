bits1: bits1.o printb.o
	gcc -g -o $@ $^ -no-pie

bits1.o: bits1.asm
	nasm -f elf64 -g -F dwarf $< -l bits1.lst

printb.o: printb.c
	gcc -c -g $< -o $@