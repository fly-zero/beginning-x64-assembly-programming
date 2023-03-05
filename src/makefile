subdirs = 04-1 04-3 04-5 07-1 07-2 07-3 10-1 11-1 12-2 14-1 15-1 \
          16-1 16-4 17-1 18-1 19-1 19-2 21-1 22-1 23-1 23-3 24-1 \
          24-2 25-1 27-1 28-1 28-2 29-1 31-1 31-2

.PHONY: all clean
all clean: $(subdirs)

.PHONY: $(subdirs)
$(subdirs):
	$(MAKE) -C $@ $(MAKECMDGOALS)