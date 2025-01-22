#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>

void write_state(const char *state_file, const char *state, const char *fileName) {
    FILE *file = fopen(state_file, "w");
    if (file != NULL) {
        fprintf(file, "systemState: %s\n", state);
        fprintf(file, "fileName: %s\n", fileName ? fileName : "");
        fclose(file);
    } else {
        perror("Could not open state file");
    }
}

char *read_state(const char *state_file) {
    static char state[20];
    FILE *file = fopen(state_file, "r");
    if (file != NULL) {
        fscanf(file, "systemState: %s", state);
        fclose(file);
    } else {
        perror("Could not open state file");
    }
    return state;
}

void write_text_lines(const char *state_file, const char *lines[], int num_lines) {
    for (int i = 0; i < num_lines; i++) {
	while (strcmp(read_state(state_file), "processed") != 0) {
        sleep(5);
    }
        write_state(state_file, "query", lines[i]);
        printf("System state updated to 'query' with line: %s\n", lines[i]);
    }
}

int main(int argc, char *argv[]) {

    if (argc < 3){
	printf("Input Error \n");
	return 1;
    }

    char *state_file = argv[1];
    const char **lines = (const char **)&argv[2];
    int num_lines = argc - 2;
    // Print the paths to verify they're correct
    printf("State File: %s\n", state_file);
    write_state(state_file, "processed", "");
    write_text_lines(state_file, lines, num_lines);
    printf("End of text queries \n");
    return 0;
}

