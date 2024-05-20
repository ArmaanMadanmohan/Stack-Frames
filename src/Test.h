/*
 * Test,h
 *
 * Header file for Test module that provides functionality relating to unit testing and testing the relationship between the return address and base pointer.
 *
 */
 
#ifdef NDEBUG

#define assert(expression, testName) ((void)0)

#else

#define assert(expression, testName) \
   if (expression) { \
       printf("%s: Passed\n", testName); \
   } else { \
       printf("%s: Failed\n", testName); \
   }
#endif

/**
 * Function to test the getBasePointer() method.
 */
void testGetBasePointer();

/**
 * Function to test the getReturnAddress() method.
 */
void testGetReturnAddress();

/**
 * Function to test the relationship between the base pointer and return address of callee (i.e. the location in the caller's stack frame that the callee returns to)
 */
void testRelationship();
