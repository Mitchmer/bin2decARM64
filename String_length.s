//============================================================================
//  Mitch Merrell
//  CS3B - Lab 4-1 String_length and putstring functions
//  Date Created: 09/09/2025
//  Date Last Modified: 09/12/2025
//============================================================================

.global String_length       // provide global access to this function
    .text                   // code body start

//****************************************************************************
//  String_length function
//============================================================================
//  This function, given a pointer to a null-terminated string, will return
//  the string's length.
//============================================================================
//  Input: A pointer to a null-terminated string (C-String), stored in X0
//  Output: An integer value of the length of the string in X0
//============================================================================
//  Registers Modified:
//  X0: contains the pointer to the address of the string, and at the end of
//      the function will contain the string's length to return
//  X1: contains current char to compare
//  X2: counter to keep track of string length
//****************************************************************************
//  Function Algorithm/Pseudocode:
//      1. set counter (X2) to 0
//      2. while loop:
//          2a. load into X1 the data pointed to by the address in X0 + X2
//          2b. check if that character is null (value is 0)
//          2c. if it isn't null (and therefore not equal to zero), increment 
//              X2 by 1 and go back to beginning of loop.
//          2d. if it is null, (equal to zero), exit loop.
//      3. move value in X1 to X0
//      4. return from String_length
//============================================================================
String_length:              // function entry point
    MOV X2, #0              // set counter to 0

string_length_loop:         // start of while loop
    LDRB W1, [X0, X2]       // load the byte at the address in X0 offset by
                            // the current value of X0: This is the current
                            // character to be examined.
    CMP X1, #0              // compare the current character to 0
    B.EQ exit_loop          // if it's null (zero) exit the loop.
                // could replace these two lines with CBZ W1, string_length_loop
                            
    ADD X2, X2, #1          // if it's NOT zero, increment counter in X2
    B string_length_loop    // jump back to beginning of loop

exit_loop:                  // end of while loop
    MOV X0, X2              // replace X0 with the counted in X2; this is
                            // the same as the length of the passed string
    RET                     // return from the function

    .data
.end                        // code body end    

