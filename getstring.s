//============================================================================
//  Mitch Merrell
//  CS3B - getstring function
//  Date Created: 10/08/2025
//  Date Last Modified: 10/11/2025
//============================================================================

.global getstring           // provide global access to function
    .text                   // code body start

    .EQU STDIN, 0           // alias for the stdin file descriptor
    .EQU SYS_READ, 63       // alias for a read() system call

//****************************************************************************
//  getstring function
//============================================================================
//  Reads a string of characters up to a specified length from the console
//  and saves it in the given buffer as a C-String (null-terminated).
//============================================================================
//  Input: Reads input from the keyboard through the Linux system call #63
//  Output: N/A
//============================================================================
//  Registers:
//  X0: Holds a pointer to the first bye of the buffer which will contain the
//      string. This will be preserved through the function, such that X still
//      points to the beginning of the buffer when the function ends. This
//      register will also be used to store the file descriptor during the 
//      Linux call to read. X0 will also hold the number of bytes read from
//      the read() call
//  X1: A decimal number of the maximum length of the buffer pointed to by
//      X0 (length will account for a null character). Will also be used to
//      store the buffer pointer during the Linux call to read.
//  X2: Stores the buffer (character) limit during the Linux call to read.
//  X3: Holds characters for comparison and replacement
//  X7: Preserves the original pointer in case of input overflow
//  X8: Stores the call code 63 during for the Linux call to read.
//  LR: Contains the return address of this function.
//****************************************************************************
//  Function Algorithm/Pseudocode:
//      1. Move data in registers to prepare for the Linux call to read
//          a. Move the buffer (character) limit in X1 into X2
//              i. decrement buffer limit by 1 to account for a null terminator
//          b. Move the buffer pointer in X0 into X1
//          c. Store the file descriptor 0 (stdin) into X0
//          d. Store the call code 63 into X8
//          e. perform the read call
//      2. When read is complete, X0 holds the number of bytes read
//          c. move the character to a position equal to the number of bytes read
//              away from the starting position and check the character in the position
//              immediately behind it.
//              ii. if it's a newline, decrement the pointer to that position
//      3. Replace the character at the pointer with a null terminator
//      4. Move the original pointer back to X0
//      5. Return from function
//============================================================================

getstring:                  // function start
    
    MOV X7, X0              // preserve pointer
    ADD X2, X1, #-1         // move buffer limit to X2 for system call
    MOV X1, X0              // load buffer into X1 for system call
    MOV X8, #SYS_READ       // Linux call code to read
    MOV X0, #STDIN          // File descriptor 
    SVC 0                   // perform Linux supervisor call
    
    // X0 now has read # of bytes
    ADD X1, X1, X0          // offset pointer by # of bytes
    LDRB W3, [X1, #-1]      // load char from buffer at the (n - 1) position
    CMP W3, #'\n'           // check if a newline
    B.NE null_termination   // jump if not a newline
    ADD X1, X1, #-1         // if it is a newline, decrement pointer by 1
null_termination:           // terminate string with a null character  
    MOV X3, #0              // prepare null terminator
    STRB W3, [X1]           // replace/append with null terminator
    
    MOV X0, X7              // Move pointer back to X0
    RET LR                  // return from function

    .data                   // data segment start
.end                        // code body end    

