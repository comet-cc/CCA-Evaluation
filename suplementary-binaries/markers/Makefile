# Build target
TARGET := marker
SRC := marker.c

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@
	@for d in ../../overlay/VM_overlay_*/root; do \
	echo "Copying $(TARGET) to $$d/..."; \
	cp $(TARGET) $$d/; \
	done
	@for d in ../../overlay/hypervisor_overlay_*/root; do \
	echo "Copying $(TARGET) to $$d/..."; \
	cp $(TARGET) $$d/; \
	done
clean:
	rm -f $(TARGET)

.PHONY: all clean

