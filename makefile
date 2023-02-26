ifndef V
	MAKEFLAGS += -s
endif

.PHONY: all clean src
all clean: src
	$(MAKE) -C $< $(MAKECMDGOALS)