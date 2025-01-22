#include <stdio.h>
#include <stdlib.h>

void updateSystemStateToProcessed(const char *filePath) {
    FILE *file = fopen(filePath, "w");
    if (file == NULL) {
        printf("Unable to open file for writing.\n");
        return;
    }

    fprintf(file, "systemState: processed\n");
    fclose(file);
    printf("System state updated to 'processed'.\n");
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <file_path>\n", argv[0]);
        return 1;
    }

    const char *filePath = argv[1];
    updateSystemStateToProcessed(filePath);
    return 0;
}
