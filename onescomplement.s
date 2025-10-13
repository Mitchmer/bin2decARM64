//============================================================================
//  Mitch Merrell
//  CS3B - Title
//  Date Created: XX/XX/XXXX
//  Date Last Modified: XX/XX/XXXX
//===== if just a function, don't include this next part =====================
//  *** PROGRAM DESCRIPTION ****
//  Algorithm/Pseudocode:
//      ALGORITHM GOES HERE
//============================================================================

.global onescomplement
    .text                   // code body start

//****************************************************************************
//  onescomplement
//============================================================================
//  Converts a given cstring to the ones complement, by changing all '0's to
//  '1's and all '1's to '0's
//============================================================================
//  Input: N/A
//  Output: N/A
//============================================================================
//  Registers:
//  X0: pointer to a cstring 
//  X1:
//  X2:
//  X8:
//****************************************************************************
//  Function Algorithm/Pseudocode:
//      ALGORITHM GOES HERE
//============================================================================
onescomplement:
    // while current char != '\0'
    MOV X7, X0              // preserve pointer
process_loop:
    LDRB W2, [X7]        // load first char and increment pointer
    CMP W2, #0               // check if it's null
    B.EQ endloop            // iftrue, exit loop
    CMP W2, #'0'            // check if it's ASCII 0
    B.NE process_one          // if not, jump to next check
    MOV W2, #'1'            // Otherwise, move an ASCII 1 to prepare to store
    STRB W2, [X7], #1           // store byte and increment pointer
    B process_loop          // jump back to beginning of loop
process_one:
    MOV W2, #'0'            // otherwise prepare an ASCII 1
    STRB W2, [X7], #1
    B process_loop
endloop:
    RET LR
    .data
.end                        // code body end    

// all functions/,acros must be documented with header comments that describe
// functionality, inpuyts, outputs, and registers used (see lab descriptions
// that require you to write functions for examples)

// all labels must be left-aligned not tabbed in

// the .global and .end directives must be left-aligned while all other
// directives (e.g. .text, .data) must be tabbed once

// All code is tabbed once (use 4 spaces for tabs)

// Each line of code must be commented and instructions and registers must be 
// upper case e.g. MOV X0, x1  not mov x0, x1)

// Label/variable namnes must adhere to Hungarian Notation
 
