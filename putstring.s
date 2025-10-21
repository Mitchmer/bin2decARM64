//============================================================================
//  Mitch Merrell
//  CS3B - Lab 4-1 String_length and putstring functions
//  Date Created: 09/09/2025
//  Date Last Modified: 09/12/2025
//============================================================================

.global putstring           // provide global access to this function
    .text                   // code body start

//****************************************************************************
//  putstring function
//============================================================================
//  This function, given a pointer to a null-terminated string, will display
//  the string on the console.
//============================================================================
//  Input: A pointer to a null-terminated string (C-String)
//  Output: Display the string stored at the location pointed to by the input
//============================================================================
//  Registers Modified:
//  X0: Contains a pointer to a null-terminated string and, after calling the
//      String_length function, will contain the length of the string. Once
//      this length is moved to X2, this register will contain the file
//      descriptor for StdOut.
//  X1: Will contain the string pointed to by the address in X0 when preparing
//      for an output call.
//  X2: After calling String_length, the length will be moved to this register
//      to prepare for an output call.
//  X3: Will be reserved to hold the return address of this function when
//      calling the String_length function.
//  X8: Will contain the same pointer as in X0 to preserve the register when
//      calling String_length. After the function call, this register will be
//      updated to have the Linux call to output the string.
//  LR: Contains the return address of this function.
//****************************************************************************
//  Function Algorithm/Pseudocode:
//      1. Copy the pointer in X0 to X8
//      2. Move the address in LR to X3 to preserve the return address for this
//          function
//      3. Call String_length
//      4. Move contents of X3 back to LR
//      5. Move the length in X0 to X2
//      6. Move the string pointer in X8 to X1
//      7. Load X0 with the StdOut file descriptor (#1)
//      8. Load X8 with the Linux "write" call code (#64)
//      9. Call Linux to output the string
//      10. Return from putstring function 
//============================================================================
putstring:
    .EQU SYS_WRITE, 64      // Service code for write
    .EQU STDOUT,    1       // File descriptor for StdOut

    ADD X8, X0, #0          // copy the pointer from X0 to X8
    MOV X3, LR              // Save the return address before calling String_length
    BL String_length        // Get length of string for system write call

    // X0 now contains the length of the string
    MOV LR, X3              // Move preserved return address back into the LR register

    // Prepare for system write call
    MOV X2, X0              // Move value of string length to X2 for system write call
    MOV X1, X8              // Move the pointer to the string from X8 into X1
    MOV X0, STDOUT          // File descriptor for StdOut
    MOV X8, SYS_WRITE       // Linux write service code
    SVC 0                   // Perform supervisor call to display string

    RET                     // Return from function
 
    .data
.end                        // code body end    

