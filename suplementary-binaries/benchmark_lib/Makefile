# Build target
TARGET := benchmark_lib.so
SRC := benchmark_lib.c

# Compiler flags for building a shared library
CFLAGS := -fPIC -shared

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@

# Clean up
clean:
	rm -f $(TARGET)

.PHONY: all clean
