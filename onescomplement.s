//============================================================================
//  Mitch Merrell
//  CS3B - onescomplement function
//  Date Created: 10/12/2025
//  Date Last Modified: 10/13/2025
//============================================================================

.global onescomplement      // provide global access to function
    .text                   // code body start

//****************************************************************************
//  onescomplement
//============================================================================
//  Converts a given cstring to its one's complement, by changing all '0's to
//  '1's and all '1's to '0's
//============================================================================
//  Input: N/A
//  Output: N/A
//============================================================================
//  Registers:
//  X0: pointer to a binary cstring 
//  X1: loads character for conversion
//  X7: preserves original pointer for modifcation
//****************************************************************************
//  Function Algorithm/Pseudocode:
//      1. save original pointer for modification
//      2. loop the following:
//          a. load current character and check if null:
//              i. if null, exit loop
//          b. check if character is an ASCII '0'
//              i. if true, replace it with an ASCII '1'
//                  1. increment pointer and jump back to beginning of loop
//              ii. otherwise its '1' and replace with ASCII '0'
//                  1. increment pointer and jump back to beginning of loop
//      3. return from function
//============================================================================
onescomplement:             // function access point
    MOV X7, X0              // preserve pointer

process_loop:               // loop to process binary string
    LDRB W1, [X7]           // load first char
    CMP W1, #0              // check if it's null
    B.EQ endloop            // if true, exit loop
    CMP W1, #'0'            // check if it's ASCII '0'
    B.NE process_one        // if not, jump to next check
    MOV W1, #'1'            // Otherwise, move an ASCII '1' to prepare to store
    STRB W1, [X7], #1       // store byte and increment pointer
    B process_loop          // jump back to beginning of loop

process_one:                // section to process a '1'
    MOV W1, #'0'            // prepare an ASCII '0'
    STRB W1, [X7], #1       // replace '1' with a '0'
    B process_loop          // jump back to beginning of loop

endloop:                    // end of loop
    RET LR                  // return from function

    .data                   // data section start
.end                        // code body end    

