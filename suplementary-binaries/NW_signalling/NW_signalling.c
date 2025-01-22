#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>

void remove_files(const char *target_folder, const char *format) {
    DIR *dir;
    struct dirent *ent;
    char filePath[1024];

    if ((dir = opendir(target_folder)) != NULL) {
        while ((ent = readdir(dir)) != NULL) {
            if (strstr(ent->d_name, format)) {
                sprintf(filePath, "%s/%s", target_folder, ent->d_name);
                remove(filePath);
            }
        }
        closedir(dir);
    } else {
        perror("Could not open directory");
    }
}

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

void copy_files(const char *source_folder, const char *target_folder, const char *state_file, const char *format) {
    DIR *dir;
    struct dirent *ent;
    struct dirent **namelist;
    int n;
    char sourcePath[1024];
    char targetPath[1024];

    if ((dir = opendir(source_folder)) != NULL) {
        n = scandir(source_folder, &namelist, NULL, alphasort);
        if (n < 0) {
            perror("scandir");
            closedir(dir);
            return;
        }

        for (int i = 0; i < n; i++) {
            ent = namelist[i];
            if (strstr(ent->d_name, format)) {
                snprintf(sourcePath, sizeof(sourcePath), "%s/%s", source_folder, ent->d_name);
                snprintf(targetPath, sizeof(targetPath), "%s/%s", target_folder, ent->d_name);

                while (strcmp(read_state(state_file), "processed") != 0) {
                    sleep(5);
                }

                FILE *src = fopen(sourcePath, "rb");
                FILE *dst = fopen(targetPath, "wb");
                if (src != NULL && dst != NULL) {
                    char buffer[1024];
                    size_t bytes;
                    while ((bytes = fread(buffer, 1, sizeof(buffer), src)) > 0) {
                        fwrite(buffer, 1, bytes, dst);
                    }
                    fclose(src);
                    fclose(dst);
                    printf("Copied %s to %s\n", sourcePath, targetPath);
                    write_state(state_file, "query", targetPath);
                    printf("System state updated to 'query' and fileName to %s\n", targetPath);
                } else {
                    if (src) fclose(src);
                    if (dst) fclose(dst);
                    perror("Failed to copy file");
                }
            }
            free(namelist[i]);
        }
        free(namelist);
        closedir(dir);
    } else {
        perror("Could not open source directory");
    }
}

int main(int argc, char *argv[]) {

    if (argc < 5){
	printf("Input Error \n");
	return 1;
    }

    char *source_folder = argv[1];
    char *target_folder =argv[2];
    char *state_file = argv[3];
    const char *format = argv[4];
    // Print the paths to verify they're correct
    printf("Source Folder: %s\n", source_folder);
    printf("Target Folder: %s\n", target_folder);
    printf("State File: %s\n", state_file);
    printf("File Format: %s\n", format);
    remove_files(target_folder, format);
    write_state(state_file, "processed", "");
    copy_files(source_folder, target_folder, state_file, format);
    printf("End of writing input to the shared memory \n");
    return 0;
}

