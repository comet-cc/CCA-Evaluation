# Build target
TARGET := memory_touch
SRC := memory_touch.c

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@
	@for d in ../../overlay/VM_overlay_*/root; do \
	echo "Copying $(TARGET) to $$d/..."; \
	cp $(TARGET) $$d/; \
	done
clean:
	rm -f $(TARGET)

.PHONY: all clean

