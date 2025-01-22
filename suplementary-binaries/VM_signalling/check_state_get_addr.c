#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h> // For sleep function

char* checkSystemStateAndGetFilename(const char *filePath) {
    while (1) {
        FILE *file = fopen(filePath, "r");
        if (file == NULL) {
            printf("Error opening file\n");
            return NULL;
        }

        char line[256];
        char state[50] = "";
        char fileName[100] = "";

        while (fgets(line, sizeof(line), file)) {
            if (strstr(line, "systemState:") != NULL) {
                strcpy(state, strchr(line, ':') + 2);
                state[strcspn(state, "\n")] = 0; // Remove newline
            } else if (strstr(line, "fileName:") != NULL) {
                strcpy(fileName, strchr(line, ':') + 2);
                fileName[strcspn(fileName, "\n")] = 0; // Remove newline
            }
            printf("Waiting for signalling file...\n");
        }
        fclose(file);

        if (strcmp(state, "query") == 0) {
            printf("System state is 'query'. Filename: %s\n", fileName);
            char *result = malloc(strlen(fileName) + 1);
            strcpy(result, fileName);
            return result;
        } else {
            printf("Waiting for system state to become 'query'...\n");
            sleep(1); // Check every 1 seconds
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <file_path>\n", argv[0]);
        return 1;
    }

    const char *filePath = argv[1];
    char *filename = checkSystemStateAndGetFilename(filePath);
    if (filename != NULL) {
        printf("Received filename: %s\n", filename);
        free(filename);
    }
    return 0;
}
