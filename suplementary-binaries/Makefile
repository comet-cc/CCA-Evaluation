# Main Makefile for the project

# Cross compiler settings
CC := /opt/toolchains/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-gcc
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
