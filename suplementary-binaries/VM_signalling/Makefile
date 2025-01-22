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
	@for d in ../../overlay/VM_overlay_*/root; do \
	echo "Copying $(TARGET1) to $$d/..."; \
	cp $(TARGET1) $$d/; \
	done

# Build the second target
$(TARGET2): $(SRC2)
	$(CC) $(CFLAGS) $^ -o $@
	@for d in ../../overlay/VM_overlay_*/root; do \
	echo "Copying $(TARGET2) to $$d/..."; \
	cp $(TARGET2) $$d/; \
	done
# Clean up the binaries
clean:
	rm -f $(TARGET1) $(TARGET2)

.PHONY: all clean
