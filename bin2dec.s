//============================================================================
//  Mitch Merrell, Osvaldo Medina Hernandez | Bin2Dec Project Group 5
//  CS3B - bin2dec function
//  Date Created: 10/08/2025
//  Date Last Modified: 10/09/2025
//============================================================================

.global _start
    .text                   // code body start

//****************************************************************************
//  bin2dec function
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
//  Registers:
//  X0: 
//  X1:
//  X2:
//  X8:
//****************************************************************************
//  Function Algorithm/Pseudocode:
//      1. Get input from user
//      2. clear input_length and number_length counters to 0
//      3. clear the number string buffer
//      4. while input_length < 64
//          a. check the current character and increment pointer
//          b. if it's a '0' '1' AND number_length counter < 16:
//              i. store the current character in the number string buffer
//              ii. increment the number_length counter
//          c. if it's a 'q':
//              i. clear the input string
//              ii. terminate the program
//          d. if it's a 'c':
//              i. clear the number string buffer
//              ii. set the number_length counter to 0
//          e. if it's an 'Enter':
//              i. exit the loop
//          f. increment input_length counter
//          g. jump back to the beginning of length
//      5. Call cstr2int with the number string as a parameter
//      6. Call int2cstr and pass converted number as a parameter
//      7. check first character for sign
//      8. if it's a '-':
//          a. pass "->" to putstring
//          b. otherwise, pass "->+" to putstring
//      9. pass converted number to putstring
//      10. wait for additional input + 'Enter'
//          a. read input
//          b. loop through string given
//              i. check current char and increment pointer
//              ii. if it's a 'c':
//                  1. clear the input string
//                  2. go back to the beginning of program
//              iii. if it's a 'q':
//                  1. terminate program
//============================================================================
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
 
