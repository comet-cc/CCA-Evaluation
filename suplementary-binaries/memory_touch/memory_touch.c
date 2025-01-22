#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>
#include <unistd.h>

#define PAGE_SIZE sysconf(_SC_PAGESIZE)

int main(int argc, char *argv[]) {
    if (argc != 2 && argc != 3) {
        fprintf(stderr, "Usage: %s <memory size in MB> with optional cleanup flag -c \n", argv[0]);
        return 1;
    }

    long mem_size = atol(argv[1]) * 1024 * 1024;
    printf("Attempting to allocate and touch %ld MB of memory...\n", mem_size / (1024 * 1024));

    char *memory = mmap(NULL, mem_size, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
    if (memory == MAP_FAILED) {
        perror("Failed to mmap memory");
        return 1;
    }

    //Touch each page in the allocated memory
    for (long i = 0; i < mem_size; i += PAGE_SIZE) {
        memory[i] = 0;
    }

    printf("Successfully touched all allocated pages.\n");

    // Cleanup
//    if (strcmp(argv[2], "-c") == 0)
     munmap(memory, mem_size);

    return 0;
}

