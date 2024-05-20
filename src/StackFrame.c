/*
 * StackFrame.c
 *
 * Source file for StackFrame module that provides functionality relating to
 * stack frames and printing out stack frame data.
 *
 */

#include <stdio.h>
#include "StackFrame.h"


/**
 * Gets hold of the base pointer in the stack frame of the function that called getBasePointer
 * (i.e. the base pointer in getBasePointer's caller's stack frame).
 * @return the base pointer of getBasePointer's caller's stack frame
*/
unsigned long getBasePointer() {
    unsigned long basePointer;

    // Copies the base pointer of the caller function to the value basePointer; same as base pointer of first stack frame
    asm("movq (%%rbp), %0;" : "=r"(basePointer)); 
    return basePointer;
}

/**
 * Gets hold of the return address in the stack frame of the function that called getReturnAddress
 * (i.e. the return address to which getReturnAddress's caller will return to upon completion).
 *
 * @return The return address of getReturnAddress's caller
 */
unsigned long getReturnAddress() {
    unsigned long returnAddress;

    // Dereferences the value pointed to by the base pointer and copies it to the return register (rax). 
    // Offsets the value by 8 bytes to retrieve the return address. 
    asm("movq (%%rbp), %%rax\n\tmovq 8(%%rax), %0" : "=r"(returnAddress)); 
    return returnAddress;
}

/**
 * Prints out stack frame data (formatted as hexadecimal values) between two given base pointers in the call stack.
 *
 * @param basePointer the later basePointer (lower memory address)
 * @param previousBasePointer a previous base pointer (higher memory address)
*/
void printStackFrameData(unsigned long basePointer, unsigned long previousBasePointer) {
    unsigned long currentAddress = basePointer;
    //
    while (currentAddress < previousBasePointer) {
        unsigned char *bytes = (unsigned char*) currentAddress; // Casts current address to unsigned char pointer
        printf("%016lx:   %016lx   --   ", currentAddress, *(unsigned long*) currentAddress);
        for (int i = 0; i < BYTES_PER_LINE; i++) { 
            printf("%02x ", bytes[i]); // Prints bytes in hexadecimal format
        }
        printf("\n");
        
        if (currentAddress == basePointer) {
            printf("-------------\n"); // Prints stack frame separator
        }
        currentAddress += BYTES_PER_LINE; // Increments the current address by the constant (8 bytes) to iterate through memory addresses.
    }
}

/**
 * Prints contents of the stack frames, from the top of the stack to the bottom (current stack frame to higher in the call stack).
 * @param number The number of stack frames (including the current one) to print.
*/
void printStackFrames(int number) {
    unsigned long basePointer = getBasePointer();

    for (int i = 0; i <= number; i++) { 
        unsigned long previousBasePointer = *((unsigned long*) basePointer); // Dereferences basePointer to obtain address of previous stack frame's base pointer
        printStackFrameData(basePointer, previousBasePointer);
        basePointer = previousBasePointer; // Updates base pointer to the caller's stack frame
    }
}
