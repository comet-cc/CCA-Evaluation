#include <stdio.h>

// Inline assembly macros for ARM architecture
#define STR(s) #s
#define CCA_MARKER(marker) __asm__ volatile("MOV XZR, " STR(marker))

#define CCA_TRACE_START __asm__ volatile("HLT 0x1337")
#define CCA_TRACE_STOP  __asm__ volatile("HLT 0x1337")

#define CCA_MARKER_START() CCA_MARKER(0x1000)
#define CCA_MARKER_END()   CCA_MARKER(0x1001)

#define CCA_MARKER_INFERENCE_INITIALISATION_START() CCA_MARKER(0x2000)
#define CCA_MARKER_INFERENCE_INITIALISATION_END()   CCA_MARKER(0x2001)

#define CCA_MARKER_READ_INPUT_START() CCA_MARKER(0x2100)
#define CCA_MARKER_READ_INPUT_STOP()  CCA_MARKER(0x2101)

#define CCA_MARKER_READ_INPUT_ADDR_START() CCA_MARKER(0x1800)
#define CCA_MARKER_READ_INPUT_ADDR_STOP()  CCA_MARKER(0x1801)

#define CCA_MARKER_NEW_INFERENCE_START() CCA_MARKER(0x2200)
#define CCA_MARKER_NEW_INFERENCE_STOP()  CCA_MARKER(0x2201)

#define CCA_MARKER_WRITE_OUTPUT_START() CCA_MARKER(0x2300)
#define CCA_MARKER_WRITE_OUTPUT_STOP()  CCA_MARKER(0x2301)

#define CCA_MARKER_UPDATE_STATE_START() CCA_MARKER(0x2400)
#define CCA_MARKER_UPDATE_STATE_STOP()  CCA_MARKER(0x2401)

// Function prototypes that expose the assembly macros

void marker_start() {
    CCA_TRACE_START;
    CCA_MARKER_START();
    CCA_TRACE_STOP;
}

void marker_end() {
    CCA_TRACE_START;
    CCA_MARKER_END();
    CCA_TRACE_STOP;
}

void inference_initialisation_start() {
    CCA_TRACE_START;
    CCA_MARKER_INFERENCE_INITIALISATION_START();
    CCA_TRACE_STOP;
}

void inference_initialisation_end() {
    CCA_TRACE_START;
    CCA_MARKER_INFERENCE_INITIALISATION_END();
    CCA_TRACE_STOP;
}

void read_input_start() {
    CCA_TRACE_START;
    CCA_MARKER_READ_INPUT_START();
    CCA_TRACE_STOP;
}

void read_input_stop() {
    CCA_TRACE_START;
    CCA_MARKER_READ_INPUT_STOP();
    CCA_TRACE_STOP;
}

void read_input_addr_start() {
    CCA_TRACE_START;
    CCA_MARKER_READ_INPUT_ADDR_START();
    CCA_TRACE_STOP;
}

void read_input_addr_stop() {
    CCA_TRACE_START;
    CCA_MARKER_READ_INPUT_ADDR_STOP();
    CCA_TRACE_STOP;
}

void new_inference_start() {
    CCA_TRACE_START;
    CCA_MARKER_NEW_INFERENCE_START();
    CCA_TRACE_STOP;
}

void new_inference_stop() {
    CCA_TRACE_START;
    CCA_MARKER_NEW_INFERENCE_STOP();
    CCA_TRACE_STOP;
}

void write_output_start() {
    CCA_TRACE_START;
    CCA_MARKER_WRITE_OUTPUT_START();
    CCA_TRACE_STOP;
}

void write_output_stop() {
    CCA_TRACE_START;
    CCA_MARKER_WRITE_OUTPUT_STOP();
    CCA_TRACE_STOP;
}

void update_state_start() {
    CCA_TRACE_START;
    CCA_MARKER_UPDATE_STATE_START();
    CCA_TRACE_STOP;
}

void update_state_stop() {
    CCA_TRACE_START;
    CCA_MARKER_UPDATE_STATE_STOP();
    CCA_TRACE_STOP;
}
