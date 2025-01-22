# Build target
TARGET := NW_signalling
SRC := NW_signalling.c

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@
	cp $(TARGET) ../../overlay/hypervisor_overlay_*/root/.
clean:
	rm -f $(TARGET)

.PHONY: all clean

