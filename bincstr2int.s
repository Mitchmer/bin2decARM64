//============================================================================
//  Mitch Merrell
//  CS3B - Lab 5-3 cstr2int function
//  Date Created: 10/02/2025
//  Date Last Modified: 10/02/2025
//============================================================================

.global cstr2int                // provide global access to function
    .text                       // code body start
    .EQU    BASE_NUMBER, 2      // specifies base number for conversion
//****************************************************************************
//  cstr2int function
//============================================================================
//  Provided a pointer to a C-String representing a valid signed integer,
//  converts it to a quad integer. If under/overflow occurs, then the overflow
//  flag must be set and a value of 0 returned.
//============================================================================
//  Input: N/A
//  Output: N/A
//============================================================================
//  Registers:
//  X0: Must point to a null-terminated string that is a valid signed 64-bit
//          decimal number.
//  X0: Upon function return, this will contain the signed quad result 
//  X1: Stores current character
//  X2: Accumulates the number as its converted
//  X5: Used to check for multiplication overflow with UMULH 
//  X6: contains 10 for multiplication during the conversion process
//  X7: "Boolean" register which is a 0 if number is positive, 1 if
//      negative.
//****************************************************************************
//  Function Algorithm/Pseudocode:
//      1. Clear X1, X2, and X7 to intitialize deafult values
//      2. Check if first char is a hyphen
//          a. if yes, set X7 to "True" (#1) and increment pointer
//          b. If it's not, set X7 to 0.
//      3. Do the following as a loop:
//          a. check for multiplication overflow
//              i. if overflow, jump to overflow handling section
//          b. otherwise, multiply the result in X2 by 10 to shift digits left
//          c. to convert from the ASCII value of the current char, subtract
//              '\0' from the character
//          d. subtract this number from X2 and increment X0 pointer to next
//              char.
//              i. If the subtraction overflowed, jump to "overflow" section
//          c. if the char is null (ASCII value 0), exit loop, otherwise jump
//              back to beginning
//      4. If X7 is 1, number is negative and is done; jump to end of function
//          to prepare for return
//      5. If X7 is 0, number is positive
//          a. Negate number in X2
//              i. If negation overflowed, jump to "overflow" section
//      6. Move X2 to X0 and jump to end of function
//      7. OVERFLOW HANDLING: if any operation resulted in overflow:
//          a. Move #0 into X0
//          b. Move 0x4000000000000000 into X2
//          c. Add X2 to X2 to set overflow flag
//      8. Return from function
//============================================================================
cstr2int:
    MOV X1, #0                  // Clear the X1 register
    MOV X2, #0                  // Clear the X2 register
    MOV X7, #0                  // Set X7 to 0 (false) for "positive"
    LDRB W1, [X0], #1           // load first char into X1 
    CMP W1, #'-'                // check if first char is '-'
    B.NE endif_negative         // if not a '-', jump to the conversion loop label
    MOV X7, #1                  // else, set X7 to 1 (true) for "negative"
    LDRB W1, [X0], #1           // load next character after hyphen and increment X0 pointer by 1

endif_negative:
    MOV X6, #BASE_NUMBER        // store 10 in X6 for multiplication

convert_loop:
    NEGS X5, X2                 // copy and negate X2 to X5 for a multiplication overflow check
    B.VS overflow               // if negation sets overflow, jump to overflow label
    UMULH X5, X5, X6            // otherwise, check if X2 * 10 would overflow
    CMP X5, #0                  // check if UMULH produced a 0
    B.NE overflow               // if X5 is nonzero, jump to overflow
    MUL X2, X2, X6              // otherwise, multiply X2 by 10

    SUB W1, W1, #'0'            // get the decimal value of ASCII char by subtracting '0' from the current char
    SUBS X2, X2, X1             // subtract current char number from the accumulated number in X2
    B.VS overflow               // if subtraction results in overflow, jump to overflow section
    LDRB W1, [X0], #1           // load next char and increment pointer
    CMP W1, #0                  // check if the char is null (ASCII value equal to zero)
    B.NE convert_loop           // if it isn't, go back to beginning of loop

    CMP X7, #1                  // check if X7 is "True" (1), meaning the number is negative
    B.EQ prepare_return         // if it's negative, go straight to returning from the function 
    NEGS X2, X2                 // otherwise, negate X2
    B.VS overflow               // if the negation sets the overflow flag, jump to overflow label

prepare_return:
    MOV X0, X2                  // move X2 into X0 for returning the converted number
    B end_function              // jump to the end of function

overflow:
    MOV X0, #0                  // move a decimal 0 into X0 for return value
    MOV X2, #0x4000000000000000 // move extremely large number into X2 to prepare to manually set overflow flag
    ADDS X2, X2, X2             // manually set overflow by adding X2 to itself

end_function:                   // section for returning from function
    RET                         // return from function

    .data                       // data section start
.end                            // code body end    

