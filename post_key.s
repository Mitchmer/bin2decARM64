// Set up the information on the stack
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
.data
flush_char:    .byte 0

.text
.global post_key

post_key:
    	STP X29, X30, [SP, #-16]!   	// Save the frame pointer and return address on stack
    	MOV X29, SP			// Set up new frame pointer
	
	MOV X19, X0			// Saves buffer pointer in register	
wait_input:
	SUB SP, SP, #0
       	MOV X0, SP                  	// Temporary buffer on stack
    	MOV X1, #2                  	// Read max 2 bytes 
    	BL getstring                	// Call getstring

    	LDRB W4, [SP]               	// Load entered character

    	
    	CMP W4, #'q'			// compares to 'q'
    	BEQ quit_program		// If equal jump to quit_program

       	CMP W4, #'c'			// compare to 'c'
    	BEQ clear_buffer		// If equal jump to clear_buffer

	ADD SP, SP, #0
      	B wait_input			// else jump to wait_input

clear_buffer:
	MOV X5, X19
       	MOV X5, X2                  	// X2 = pointer to buffer
    	MOV X6, #0                  	// Zero
    	MOV X7, #0                  	// Index
clear_loop:
       	STRB W6, [X5, X7]           	// Set byte to 0
    	ADD X7, X7, #1
    	CMP X7, X3                   	// X3 = buffer length
    	B.LT clear_loop

	ADD SP, SP, #8
	B post_exit

post_exit:
	MOV X0, #0
    	// Return to main to loop again
    	LDP X29, X30, [SP], #16
    	RET

quit_program:
	ADD, SP, SP, #8
        LDP X29, X30, [SP], #16
    	// Exit program
    	MOV X0, #1                  
    	RET

