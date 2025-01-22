# Build target
TARGET := NW_signalling_LLM
SRC := NW_signalling_LLM.c

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@
	@for d in ../../overlay/hypervisor_overlay_*/root; do \
	echo "Copying $(TARGET) to $$d/..."; \
	cp $(TARGET) $$d/; \
	done
clean:
	rm -f $(TARGET)

.PHONY: all clean

