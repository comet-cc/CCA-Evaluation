# Build target
TARGET := marker
SRC := marker.c

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@
	cp $(TARGET) ../../overlay/hypervisor_overlay_*/root/.
	cp $(TARGET) ../../overlay/VM_overlay_*/root/.
clean:
	rm -f $(TARGET)

.PHONY: all clean

