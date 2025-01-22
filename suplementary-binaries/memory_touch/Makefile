# Build target
TARGET := memory_touch
SRC := memory_touch.c

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@
	cp $(TARGET) ../../VM_overlaysig/root/.
	cp $(TARGET) ../../VM_overlay1/root/.
	cp $(TARGET) ../../VM_overlay3/root/.

clean:
	rm -f $(TARGET)

.PHONY: all clean

