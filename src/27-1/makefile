mxcsr: mxcsr.o print_mxcsr.o print_hex.o
	gcc -o mxcsr $^ -no-pie

%.o: %.asm
	nasm -f elf64 -g -F dwarf $< -l %.lst

%.o: %.c
	gcc -g -c $< -o $@