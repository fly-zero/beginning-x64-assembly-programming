c_src_list   = $(wildcard *.c)
asm_src_list = $(wildcard *.asm)
obj_list     = $(patsubst %.asm, %.o, $(asm_src_list)) $(patsubst %.c, %.o, $(c_src_list))
lst_list     = $(patsubst %.asm, %.lst, $(asm_src_list))

all: $(target)

$(target): $(obj_list)
	@printf "\e[1;33m%-12s\e[0m %s\n" linking `readlink -f "$@"`
	@gcc -o $@ $^ -no-pie

%.o: %.asm
	@printf "\e[1;32m%-12s\e[0m %s\n" compiling `readlink -f "$<"`
	@nasm -f elf64 -g -F dwarf $< -l $(@:%.o=%.lst)

%.o: %.c
	@printf "\e[1;32m%-12s\e[0m %s\n" compiling `readlink -f "$<"`
	@gcc -c -g3 $(c_flags) $< -o $@

.PHONY: clean
clean:
	@printf "\e[1;32m%-12s\e[0m %s\n" cleaning `pwd`
	@rm -rf $(target) $(obj_list) $(lst_list)