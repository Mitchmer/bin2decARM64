//============================================================================
//  Mitch Merrell
//  CS3B - int2cstr function
//  Date Created: 09/22/2025
//  Date Last Modified: 09/30/2025
//============================================================================

.global int2cstr            // provide global access to function
    .text                   // code body start

//****************************************************************************
//  int2cstr function
//============================================================================
//  Provided a signed interger, this function will convert it to a C-String
//  (null-terminated string) which will be stored in memory and pointed to by
//  a provided pointer that must be large enough to hold the converted value.
//  Usually a string of 21 bytes is more than sufficient to allow for a sign
//  as well as the largest possible value a word could be. 
//============================================================================
//  Input: N/A
//  Output: N/A
//============================================================================
//  Registers:
//  X0: Contains the binary (signed) value to be converted to a C-String
//  X1: Must point to an address large enough to hold the converted value
//  X2: Points the address of the "current digit" being processed
//  X3: Contains the value of X0, as well as the resulting modifications
//      during digit processing
//  X4: Holds temporary characters, such as '-','0', and is used as temporary
//      number storage during digit processing
//  X5: Temporary storage acesed during digit processing
//  X6: Stores the base number during digit processing as the divisor
//  LR: Contains the return address
//  Registers X0-X8 are not preserved.
//****************************************************************************
//  Function Algorithm/Pseudocode:
//      1. Clear the buffer
//      2. Copy number for modification during division
//      2. Check if number is positive
//          a. if it's zero, just store a '0' into X1 and skip to return
//          a. if negative, store an ASCII '-' in X2 and offset
//          b. else, negate number
//      3. Load X1 into X2 to store the "current" character/digit
//      3. "Digit" loop (computing remainders) do while X3 is not equal to 0:
//          a. divide X4 by NUM_BASE -> gives rest of digits minus last
//              i. store result in X3
//          b. Calculate remainder using X4 = X4 - (X3 * BASE_NUMBER)
//              i. negate X4 (to make digit positive) and add '0' to convert
//                  to ASCII
//              ii. store X4 into X2 and offset
//      4. Store a '\0' (null character) into X2 and offset by -1
//      5. Reverse digits loop while X1 < X2 (these are addresses):
//          a. swap X1 and X2
//          b. increment X1 and decrement X2
//      6. Return from function
//============================================================================
int2cstr:                   // function start
    .EQU    SYS_EXIT, 93    // service code for program exit
    .EQU    NUM_BASE, 10    // base 10 digits
    
    MOV X3, #0              // store a 0 value to clear buffer
    LDR X3, [X1]            // clear buffer
    MOV X3, X0              // copy number in X0 to X3 to be modified
    MOV X2, X1              // copy address of X1 into X2 to differentiate between buffer start and current character

// Checking the sign of the number     
    CMP X3, #0              // compare against 0 to check sign
    B.EQ is_zero            // handle instance where number is 0
    B.GE sign_else          // else if the number is positive, jump to the false condition
    MOV W4, #'-'            // else the number is negative, and move ascii '-' into W4 to prepare for store 
    STRB W4, [X2], #1       // store '-' into first byte and offset to next byte
    ADD X1, X1, #1          // increment X1 pointer to next byte
    B sign_end_if           // jump to the end of if logic
is_zero:                    // if number is 0, just return a '0\0' (rest of register is already 0, accounts for \0)
    MOV X4, #'0'            // move a '0' into W4 to prepare for store to memory
    STR X4, [X1]            // store '0' to memory
    B end_function          // skip to the end of the function  
sign_else:                  // false statement (the number is positive)
    NEG X3, X3              // negate number
sign_end_if:                // end of if statement

// Converting the digits of the number to characters
    MOV X6, #NUM_BASE       // move the number base into X6 to prepare for division
digit_loop:                 // beginning of loop to parse digits of number into characters
    //CMP X3, #0              // check if X3 is 0 (last digit/remainder was stored)
    //B.EQ digit_loop_end     // if is 0, loop is done and jump to end of loop
    MOV X4, X3              // otherwise, move X3 to X4 for preparation to modify
    SDIV X3, X4, X6         // divide X4 by NUM_BASE and store into X3 (which now has 1 less digit)
    MUL X5, X3, X6          // store (X3 * BASE_NUM) in X5 
    SUB X4, X4, X5          // store X4 - (X3 * BASE_NUM) in X4, this is the remainder
    NEG X4, X4              // negate the remainder (to make it positive)
    ADD X4, X4, #'0'        // add ASCII value of '0' to X4 to convert to ASCII number
    STRB W4, [X2], #1       // store characer into X2 (the current character "digit") and offset
    // if leftover is 0, end loop
    CMP X3, #0  // NEW
    B.NE digit_loop // NEW
    // B digit_loop            // jump back to top of loop
digit_loop_end:             // end of digit conversion loop
    STRB W3, [X2], #-1      // store a null into the last character slot, and decrement offset to point X2 at the last "digit"

// Reverse the order of character digits
// At this point, 
// X1 is pointing to the first non-sign character
// X2 is pointing to the last character that isn't '\0'
// however, all of the digits are in reverse order so we'll being swapping them, 
// starting on the outermost characters and working inwards
reverse_digit_loop:         // beginning of loop to reverse order of digit characters
    CMP X1, X2              // compare X1 - X2 (addresses)
    B.GE end_function       // if X1 is greater than or equal to X2, loop is done and jump to end of function
    LDRB W3, [X1]           // store X1's char (left-most) into W3
    LDRB W4, [X2]           // store X2's char (right-most) into W4
    STRB W3, [X2], #-1      // store W3 into X2 and decrement pointer
    STRB W4, [X1], #1       // store W4 into X1 and increment pointer
    B reverse_digit_loop    // jump back to start of loop 
end_function:               // label for jumping to end of the function 
    RET                     // return to caller
    .data                   // data section start
.end                        // code body end    
 
