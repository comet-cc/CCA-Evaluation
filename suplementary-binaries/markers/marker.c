#include "benchmark.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
void print_help() {
    printf("Usage: program [-h] [-f number]\n");
    printf("Options:\n");
    printf("  -h          Display this help message\n");
    printf("  -f number   Perform an operation specified by the number\n");
}

void perform_operation(int num) {
    switch (num) {

        case 1:
                CCA_TRACE_START;
		CCA_MARKER_CREATION_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_CREATION_START\n");
		break;
	case 2:
                CCA_TRACE_START;
		CCA_MARKER_CREATION_END();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_CREATION_END\n");
		break;
        case 3:
                CCA_TRACE_START;
		CCA_MARKER_DESTRUCTION_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_DESTRUCTION_START\n");
		break;
        case 4:
                CCA_TRACE_START;
		CCA_MARKER_DESTRUCTION_END();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_DESTRUCTION_END\n");
		break;
        case 5:
                CCA_TRACE_START;
		CCA_MARKER_MEMORY_DELEGATE1_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_MEMORY_DELEGATE1_START\n");
		break;
        case 6:
                CCA_TRACE_START;
		CCA_MARKER_MEMORY_DELEGATE1_END();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_MEMORY_DELEGATE1_END\n");
		break;
        case 71:
                CCA_TRACE_START;
		CCA_MARKER_REALM_VM_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_REALM_VM_START\n");
		break;
        case 72:
                CCA_TRACE_START;
		CCA_MARKER_NW_VM_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_NW_VM_START\n");
		break;
        case 73:
                CCA_TRACE_START;
		CCA_MARKER_NW_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_NW_START\n");
		break;
        case 74:
                CCA_TRACE_START;
		CCA_MARKER_REALM_VM_QEMU_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_REALM_VM_QEMU_START\n");
		break;
        case 75:
                CCA_TRACE_START;
		CCA_MARKER_NW_VM_QEMU_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_NW_VM_QEMU_START\n");
		break;
	case 9:
                CCA_TRACE_START;
		CCA_MARKER_MEMORY_DELEGATE2_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_MEMORY_DELEGATE2_START\n");
		break;
        case 10:
                CCA_TRACE_START;
		CCA_MARKER_MEMORY_DELEGATE2_END();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_MEMORY_DELEGATE2_END\n");
		break;
        case 11:
                CCA_TRACE_START;
		CCA_MARKER_MEMORY_DELEGATE3_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_MEMORY_DELEGATE3_START\n");
		break;
        case 12:
                CCA_TRACE_START;
		CCA_MARKER_MEMORY_DELEGATE3_END();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_MEMORY_DELEGATE3_END\n");
		break;
        case 13:
                CCA_TRACE_START;
		CCA_MARKER_MEMORY_DELEGATE4_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_MEMORY_DELEGATE4_START\n");
		break;
        case 14:
                CCA_TRACE_START;
		CCA_MARKER_MEMORY_DELEGATE4_END();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_MEMORY_DELEGATE4_END\n");
		break;
        case 15:
                CCA_TRACE_START;
		CCA_MARKER_MEMORY_DELEGATE5_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_MEMORY_DELEGATE5_START\n");
		break;
        case 16:
                CCA_TRACE_START;
		CCA_MARKER_MEMORY_DELEGATE5_END();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_MEMORY_DELEGATE5_END\n");
		break;
        case 17:
                CCA_TRACE_START;
                CCA_MARKER_CREATION_AFTER_ACTIVATION_END();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_CREATION_AFTER_ACTIVATION_END\n");
		break;
        case 18:
                CCA_TRACE_START;
                CCA_MARKER_CREATION_BEFORE_ACTIVATION_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_CREATION_BEFORE_ACTIVATION_START\n");
		break;
        case 50:
                CCA_TRACE_START;
		CCA_MARKER_READ_INPUT_START();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_READ_INPUT_START \n");
		break;
        case 51:
                CCA_TRACE_START;
		CCA_MARKER_READ_INPUT_STOP();
   		CCA_TRACE_STOP;
		printf("CCA_MARKER_READ_INPUT_STOP \n");
		break;

        default:
		printf("Unknown operation: %d\n", num);
		break;
   }
}

int main(int argc, char *argv[]) {
    int opt;
    int operation_number = -1;

    // Parse command-line options
    while ((opt = getopt(argc, argv, "hf:")) != -1) {
        switch (opt) {
            case 'h':
                print_help();
                exit(EXIT_SUCCESS);
            case 'f':
                operation_number = atoi(optarg);
                perform_operation(operation_number);
                break;
            default:
                fprintf(stderr, "Usage: %s [-h] [-f number]\n", argv[0]);
                exit(EXIT_FAILURE);
        }
    }

    // If no operation was specified
    if (operation_number == -1) {
        fprintf(stderr, "Error: No operation number specified.\n");
        print_help();
        exit(EXIT_FAILURE);
    }

    return 0;
}

