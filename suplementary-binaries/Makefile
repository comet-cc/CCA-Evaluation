# Main Makefile for the project

# Cross compiler settings
CC := aarch64-linux-gnu-gcc
CFLAGS := -Wall

# List of module directories
MODULES := VM_signalling NW_signalling NW_signalling_LLM markers memory_touch 

# Export compiler settings
export CC CFLAGS

# Default target
all: $(MODULES)

# Build targets for each module
$(MODULES):
	$(MAKE) -C $@

# Clean targets for each module
clean:
	for dir in $(MODULES); do \
		$(MAKE) -C $$dir clean; \
	done

.PHONY: all clean $(MODULES)
