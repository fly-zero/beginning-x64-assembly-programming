function4: function4.o circle.o rect.o
	gcc -g -o function4 $^ -no-pie

%.o: %.asm
	nasm -f elf64 -g -F dwarf $< -l %.lst