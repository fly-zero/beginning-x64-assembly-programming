MAKEFLAGS += -s

.PHONY: all clean src
all clean: src
	@$(MAKE) -C $< $(MAKECMDGOALS)