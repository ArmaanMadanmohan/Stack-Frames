/*
 * Test.c
 * Provides functionality relating to unit testing and testing the relationship between the return address and base pointer.
 */
 
#include <stdio.h>
#include <stdlib.h>
#include "StackFrame.h"
#include "Test.h"


/**
 *  Main function to execute tests
 */
int main() {
   testGetBasePointer();
   testGetReturnAddress();
   testRelationship();
}


/**
 * Function to test the getBasePointer() method.
 */
void testGetBasePointer() {
   void * expectedOutput = __builtin_frame_address(0);
   unsigned long actualOutput = getBasePointer();
   assert((unsigned long) expectedOutput == actualOutput, "testGetBasePointer");
}


/**
 * Function to test the getReturnAddress() method.
 */
void testGetReturnAddress() {
   void * expectedOutput = __builtin_return_address(0);
   unsigned long actualOutput = getReturnAddress();
   assert((unsigned long) expectedOutput == actualOutput, "testGetReturnAddress");
}

/**
 * Function to test the relationship between the base pointer and return address of callee (i.e. the location in the caller's stack frame that the callee returns to)
 */
void testRelationship() {
   void * expectedOutput = (char *)getBasePointer() + BYTES_PER_LINE; // Dereferences and increments the base pointer
   unsigned long actualOutput = getReturnAddress();
   assert(*(unsigned long*) expectedOutput == actualOutput, "testRelationship");
}
