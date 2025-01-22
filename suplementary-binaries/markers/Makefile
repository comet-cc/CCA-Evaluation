# Build target
TARGET := marker
SRC := marker.c

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@
	cp $(TARGET) ../../hypervisor_overlay1/root/.
	cp $(TARGET) ../../VM_overlay1/root/. 
	cp $(TARGET) ../../hypervisor_overlaysig/root/.
	cp $(TARGET) ../../VM_overlaysig/root/. 
	cp $(TARGET) ../../hypervisor_overlay3/root/.
	cp $(TARGET) ../../VM_overlay3/root/. 

clean:
	rm -f $(TARGET)

.PHONY: all clean

