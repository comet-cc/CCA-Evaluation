# Build target
TARGET := NW_signalling
SRC := NW_signalling.c

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@
	cp $(TARGET) ../../hypervisor_overlaysig/root/.
	cp $(TARGET) ../../hypervisor_overlay1/root/.
	cp $(TARGET) ../../hypervisor_overlay3/root/.
clean:
	rm -f $(TARGET)

.PHONY: all clean

