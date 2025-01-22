# Build target
TARGET := memory_touch
SRC := memory_touch.c

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@
	cp $(TARGET) ../../overlay/VM_overlay_*/root/.
clean:
	rm -f $(TARGET)

.PHONY: all clean

