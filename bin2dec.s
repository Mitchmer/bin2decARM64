//============================================================================
//  Mitch Merrell, Osvaldo Medina Hernandez | Bin2Dec Project Group 5
//  CS3B - bin2dec function
//  Date Created: 10/08/2025
//  Date Last Modified: 10/21/2025
//============================================================================
//  Overview: Converts a given binary number, as a string, into its equivalent 
//  decimal value and displays it to the console.
//----------------------------------------------------------------------------
//  The user will be able to use their keyboard to input a binary number up
//  to 16 digits, as well as combining those digits with the following
//  characters into a single, continuous string:
//      'c' to clear (or ignore) the all previous digits and commands in the
//          string
//      'q' to immediately terminate the program
//  When ready to execute the conversion, the user will press the 'Enter' key
//  to submit the entire string. The string is then processed by this function
//  and the first continuous sequence of 16 or less binary digits not
//  immediately preceeded by a 'c', 'q', or 'Enter' will be converted into 
//  its equivalent decimal value. If 'c' or 'q' is present within the string,
//  the program will either ignore the previous input or terminate the program.
//  i.e. an input of '1101101c1001' will produce a decimal '9' since the 
//  presence of a 'c' caused the program to discard the preceeding '1101101'.
//============================================================================
//  Input: Calls getstring function to receive keyboard input from user
//  Output: Calls putstring to display equivalent decimal value to the console
//============================================================================
//  Function Algorithm/Pseudocode:
//      1. Get input from user
//          a. call getstring to retrieve up to 64 bits
//      2. Process returned string
//      3. Call check_key() function to analyze and parse input string
//      4. Check return code from check_key()
//          a. 0: parse was successful, continue to number conversion
//          b. 1: 'q' was found, jump to program termination
//          c. Any other return code means the input was invalid
//              i. jump back to beginning of program 
//      5. Call bincstr2int with the number string as a parameter
//      6. Check sign of number
//      7. if it's negative:
//          a. pass "->" to putstring
//          b. otherwise, pass "->+" to putstring
//      8. Call int2cstr and pass converted number as a parameter
//      9. pass converted number to putstring to display
//      10. Call post_key() to wait for additional input + 'Enter'
//      11. Check return code from post_key()
//          a. 0: user wants to start over, go back to beginning of program
//          b. 1: 'q' was entered, jump to end of program for termination
//============================================================================

.global _start                      // provide global access to program start point
    .text                           // code body start
    .EQU SYS_EXIT, 93               // alias for the call code to terminate
    .EQU BUFFER_SIZE, 64            // alias for the size of the buffer

_start:                             // program start point

input_loop:                         // start of main input loop
    LDR X0, =szInitialInputPrompt   // load initial input prompt
    BL putstring                    // display prompt
    LDR X0, =szBinaryBuffer         // prepare binary string buffer for getstring
    BL getstring                    // get binary string from user
    LDR X0, =szBinaryBuffer         // load buffer into X0 for check_key input
    MOV X1, #BUFFER_SIZE            // prepare buffer size for check_key
    BL check_key                    // call check_key to process
    CMP X0, #0                      // check value returned from check_key
    B.EQ process_string             // if it's a zero, string is valid and can be processed
    CMP X0, #1                      // check value returned from check_key if not zero
    B.EQ end_program                // it it's a 1, terminate program
    B input_loop                    // if anything else, jump back to beginning of loop

process_string:                     // begin processing binary string
    LDR X0, =szBinaryBuffer         // load buffer for bincstr2int
    BL bincstr2int                  // convert binary c-string to integer
    MOV X19, X0                     // preserve integer
    LDR X0, =szArrow                // prepare arrow for display
    BL putstring                    // display arrow
    CMP X19, XZR                    // check the sign of the number
    B.LT endif_negative             // skip sign display if less than
    LDR X0, =szPlus                 // else load a plus sign
    BL putstring                    // display the plus sign

endif_negative:                     // end of if-else negative check 
    MOV X0, X19                     // prepare integer to convert to c-string
    LDR X20, =szIntegerBuffer       // load integer output buffer 
    MOV X1, X20                     // prepare buffer for int2cstr
    BL int2cstr                     // convert integer to cstring
    MOV X0, X20                     // prepare output string for display
    BL putstring                    // display number
    LDR X0, =szEOL                  // prepare newline character for display
    BL putstring                    // display newline character

post_loop:                          // loop of post-conversion input
    LDR X0, =szPostKeyPrompt        // prepare post-conversion prompt
    BL putstring                    // display post-conversion prompt to user
    LDR X0, =szBinaryBuffer         // prepare buffer to pass to post_key
    MOV X1, #BUFFER_SIZE            // prepare buffer size for post_key
    BL post_key                     // go to post key function
    CMP X0, #0                      // compare return code to 0
    B.EQ input_loop                 // if it's a 0, go back to beginning of program
                                    // otherwise, move to end of program

end_program:                        // program end section
    MOV X0, #0                      // prepare return code 0
    MOV X8, #SYS_EXIT               // prepare system call code for program exit
    SVC 0                           // Linux supervisor call to terminate program

    .data                           // data section

szTestString: .asciz "1000000000000000" // -32768
szInitialInputPrompt: .asciz "Enter a sequence of binary digits, 'c' to clear, and/or 'q' to quit: " // initial input prompt
szPostKeyPrompt: .asciz "Enter a 'c' to start over, or 'q' to quit: " // secondary input prompt
szArrow: .asciz "-> "               // arrow for conversion display
szPlus: .asciz "+"                  // sign for positive numbers
szArrowBuffer: .skip 4              // buffer to store arrow + sign
szBinaryBuffer: .skip BUFFER_SIZE   // buffer for string input
szIntegerBuffer: .skip BUFFER_SIZE  // buffer for integer output
szPostKeyBuffer: .skip 4            // buffer to pass to post key for user input
szEOL: .asciz "\n"                  // newline character for display 

.end                                // code body end    
