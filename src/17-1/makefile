bits3: bits3.o printb.o
	gcc -g -o $@ $^ -no-pie

bits3.o: bits3.asm
	nasm -f elf64 -g -F dwarf $< -l bits3.lst

printb.o: printb.c
	gcc -c -g $< -o $@