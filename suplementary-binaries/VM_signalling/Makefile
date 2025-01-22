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
	cp $(TARGET1) ../../VM_overlaysig/root/.
	cp $(TARGET1) ../../VM_overlay1/root/.
	cp $(TARGET1) ../../VM_overlay3/root/.

# Build the second target
$(TARGET2): $(SRC2)
	$(CC) $(CFLAGS) $^ -o $@
	cp $(TARGET2) ../../VM_overlaysig/root/.
	cp $(TARGET2) ../../VM_overlay1/root/.
	cp $(TARGET2) ../../VM_overlay3/root/.

# Clean up the binaries
clean:
	rm -f $(TARGET1) $(TARGET2)

.PHONY: all clean
