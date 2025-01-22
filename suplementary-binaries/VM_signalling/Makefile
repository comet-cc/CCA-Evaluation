# Source files and target binaries
TARGET1 := check_state_get_addr
TARGET2 := update_state
SRC1 := check_state_get_addr.c
SRC2 := update_state.c

# Default target
all: $(TARGET1) $(TARGET2)

# Build the first target
$(TARGET1): $(SRC1)
	$(CC) $(CFLAGS) $^ -o $@
	cp $(TARGET) ../../overlay/VM_overlay_*/root/.
# Build the second target
$(TARGET2): $(SRC2)
	$(CC) $(CFLAGS) $^ -o $@
	cp $(TARGET) ../../overlay/VM_overlay_*/root/.
# Clean up the binaries
clean:
	rm -f $(TARGET1) $(TARGET2)

.PHONY: all clean
