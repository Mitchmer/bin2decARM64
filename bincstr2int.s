//============================================================================
//  Mitch Merrell
//  CS3B - bincstr2int function
//  Date Created: 10/10/2025
//  Date Last Modified: 10/13/2025
//============================================================================

.global bincstr2int             // provide global access to function
    .text                       // code body start
    .EQU    BASE_NUMBER, 2      // specifies base number for conversion
//****************************************************************************
//  bincstr2int function
//============================================================================
//  Provided a pointer to a C-String representing a valid signed binary number,
//  converts it to the decimal equivalent. Function assumes the caller has
//  performed the checks necessary to ensure the C-String is strictly
//  composed of only binary digits.
//============================================================================
//  Input: N/A
//  Output: N/A
//============================================================================
//  Registers:
//  X0: Must point to a null-terminated string that is a valid signed 64-bit
//          binary number.
//  X0: Upon function return, this will contain the decimal result 
//  X1: Stores current character
//  X2: Accumulates the number as its converted
//  X6: contains the base number 2 for multiplication during the conversion 
//      process
//  X7: "Boolean" register which is a 0 if number is positive, 1 if
//      negative.
//****************************************************************************
//  Function Algorithm/Pseudocode:
//      1. Clear X1, X2, and X7 to intitialize deafult values
//      2. Check if first char is a 1, signifying a negative number
//          a. if yes, set X7 to "True" (#1)
//              i. convert the string to a one's complement representation
//                  by swapping each '1' and '0' to the other value
//          b. If it's not a 1, set X7 to 0 (it's positive).
//      3. Do the following in a loop:
//          b. multiply the accumulated number by 2 to shift digits left
//          c. to convert from the ASCII value of the current char, subtract
//              '\0' from the character
//          d. subtract this number from the accumulated number and increment 
//              the pointer to the next char.
//          c. if the char is null (ASCII value 0), exit loop, otherwise jump
//              back to beginning
//      4. If the boolean flag is 1, number is negative and is currently a
//          one's complement representation that has been negated
//          a. subtract 1 from the accumulated number to finish conversion
//      5. If the flag is 0, number is positive
//          a. Negate the accumulated number
//      6. Move the number into X0 for the result
//      8. Return from function
//============================================================================
bincstr2int:
    MOV X1, #0                  // Clear the X1 register
    MOV X2, #0                  // Clear the X2 register
    MOV X7, #0                  // Set X7 to 0 (false) for "positive"
    LDRB W1, [X0]               // load first char into X1 
    CMP W1, #'1'                // check if first char is '1'
    B.NE endif_negative         // if not a '1', jump to the conversion loop label
    STR LR, [SP, #-16]!         // save return address to stack
    BL onescomplement           // if it is negative, swap digits to ones complement
    LDR LR, [SP], #16           // load return address from stack
    LDRB W1, [X0]               // load first NEW char after conversion
    MOV X7, #1                  // set X7 to 1 (true) for "negative"

endif_negative:                 // post-negative check set up
    MOV X6, #BASE_NUMBER        // store 10 in X6 for multiplication
    ADD X0, X0, #1              // increment pointer to point at the next char
       
convert_loop:                   // loop for accumulating the binary number from each digit
    MUL X2, X2, X6              // otherwise, multiply X2 by 2 (base 2)
    SUB W1, W1, #'0'            // get the decimal value of ASCII char by subtracting '0' from the current char
    SUB X2, X2, X1              // subtract current char number from the accumulated number in X2
    LDRB W1, [X0], #1           // load next char and increment pointer
    CMP W1, #0                  // check if the char is null (ASCII value equal to zero)
    B.NE convert_loop           // if it isn't, go back to beginning of loop
    CMP X7, #1                  // check if X7 is "True" (1), meaning the number is negative
    B.EQ prepare_negative       // if it's negative, jump to finishing the conversion 
    NEGS X2, X2                 // if it's positive negate the number (to make it positive)
    B prepare_return            // jump to the end of the function
   
prepare_negative:               // if it's negative, the number is now a negated one's complement
    SUB X2, X2, #1              // subtract a one to return to original value

prepare_return:                 // final preparations before returning from function
    MOV X0, X2                  // move X2 into X0 for returning the converted number
    RET                         // return from function

    .data                       // data section start
.end                            // code body end    

