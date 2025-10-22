//***************************************************************************
// Osvaldo Medina 
// CS3B - post_key function
// Date: 10/21/2015
//***************************************************************************
// The post_key function handles the post condition of what the user would
// like to do after the conversion is handled. The user has the option of 
// either 'c' or 'q'. When the user inputs 'q' this will terminate the 
// program. When the user inputs a 'c' this will clear the buffer. Then
// return back to the bin2dec program
//***************************************************************************
//  Set up the information on the stack
// Then await for an input
// Reads only one char from the user
// If char is - 'q' then shut down program
// If char is - 'c' then proceed to clear the buffer
// else - awaits for a valid input again
// 
//	clear_buffer: 
//		 Goes through each char of the buffer
//		 Writes the value of 0 at the every positon of the buffer
//		Continues until the entire buffer is cleared
//	Afterwards returns back to the program
//	If 'q' - program ends completely 
//
//***************************************************************************
.data					        // start of data section
flush_char:    .byte 0			// flush_char = 0
	
.text					        // start of code section
.global post_key			    // provide global access to function

post_key:				        // function start
    STP X19, X20, [SP, #-16]!   // preserve X19, X20 to stack
    MOV X19, X0                     // move buffer pointer to X19
    MOV X20, X1                     // move buffer length to X20
	
    STP X29, X30, [SP, #-16]!   	// Save the frame pointer and return address on stack
    MOV X29, SP			// Set up new frame pointer
 
wait_input:				// if 'q' - quit and if 'c' - clear
    MOV X0, SP                  	// Temporary buffer on stack
    MOV X1, #4                  	// Read max 4 bytes 
    BL getstring                	// Call getstring

    LDRB W4, [SP]               	// Load entered character

    	
    CMP W4, #'q'			// compares to 'q'
    B.EQ quit_program		// If equal jump to quit_program

    CMP W4, #'c'			// compare to 'c'
    B.EQ clear_buffer		// If equal jump to clear_buffer

    B wait_input			// else jump to wait_input

clear_buffer:				// clears the buffer
        
    MOV X5, X19                  	// X2 = pointer to buffer
    MOV X6, #0                  	// Zero
    MOV X7, #0                  	// Index
clear_loop:				// sets every byte to 0
	LDRB W8, [X5, X7]		// load byte
    STRB W6, [X5, X7]           	// Set byte to 0
    ADD X7, X7, #1                  // Increment index
    CMP X7, X20                   	// X3 = buffer length
    B.LT clear_loop			// If less than buffer length loop again to load next byte

	B post_exit			// Jump to post_exit
	
post_exit:				// Exits the function
    // Return to main to loop again
    LDP X29, X30, [SP], #16		// Restore frame pointer and link register
    LDR X19, [SP], #16      	// restore X19
    MOV X0, #0			// Set return value to 0
    RET				// Return to function

quit_program:				// Exits the function
    LDP X29, X30, [SP], #16		// Restore frame pointer and line register
    LDP X19, X20, [SP], #16      	// restore X19, X20
    // Exit program
    MOV X0, #1                  	// Set return value to 1
    RET				// Exit program

