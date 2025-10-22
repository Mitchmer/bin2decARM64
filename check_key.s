//**************************************************************************************
// Osvaldo Medina
// CS3B - check_key function
// Date: 10/21/2025
//***************************************************************************************
//  This function is responsible for checking and validating valid input from the user.
//  If the user enters a string of binary number it will look for 'q' or 'c' first. If
//  a 'q' is found then it will terminate the program. If a 'c' is found then it will 
//  set a flag for the postion of the 'c' to clear anything before the 'c'. If a '0' 
//  or '1' is found then these are valid inputs anything invalid will be cleared from 
//  the buffer. After this function has finished it will return back to bin2dec program. 
//***************************************************************************************
// Pseudocode:
//	Function - check_key
//	Input: X0 = buffer pointer, X1 = max length
//	Output: X0 = return code 
//	1 - quit
//	2 - clear the buffer
//	3 - invalid input
//
//	Saved the frame pointer and return address onto the stack
//	Sets a new frame pointer
//	Store max_length at a temp register
//	
//	Initilaized - 
//		read_index to track position of the input
//		write_index to position the copy of valid char
//		binary_count to count valid binary digits 
//		last 'c' position to store the index of the last found 'c'
//		c found flag when a 'c' is present
//
//	Scan for q if q is found then jump to valid_exit to quit
//	program immediately
//	 else - continue to scan for c 
//	
//
//	Scan for last found 'c' in the input
//		loops through the buffer looking for a 'c' if found set found_c flag
//		 and add one to the current index within the buffer
//
//	Determine copy start position
//		If 'c' is found after_c 
//		if no then begin copyying from the buffer
//
//	The processing loop (loop_check) will continue to loop until the null terminator
//	First - loads in the current char 
//	Goes through the cases:
//		'q' - Jumps to verify this command valid_exit
//		'0' - Jumps to process the binary digit
//		'1' - Jumps to process the binary digit
//		'\n' - This determines the final result
//		Any other char is an invalid input
//
//	check_command:
//		Looks at the char in buffer
//		If:
//		 char is equal to 'q' or 'c' then jump to valid
//		else:
//		Then will jump to invalid
//	
//	process_bin:
//	  If: There are already 16 binary digits then skip
//	  else: increments binary count 
//		Then moves to the next char
//	  If: it is within the buffers bounds the binary will continue on the main loop
//	  else:  Jumps to the final result 	
//	 Anything else in an invalid input
//	
//	check_result: 
//	If - no binary digits are found then it is an invalid input
//	 will jump to invalid
//	
//	checks first char again to look for 'c' or 'q'
//	otherwise will return the valid binary code
//	
//	Invalid input - Clears the buffer completely		
//
//			Return 3 is invalid input
//
//	
//
//	Restore the original frame pointer and return address return to the calling
//	function with the result code 
//	
//*****************************************************************************************
.data					// Data section
quit_msg: .asciz "Program has ended\n"	// Define the end string
flush_char: .byte 0			// Define flush_char

.text					// start of code section
.global check_key			// provide global access to function

check_key:				// function start 
 
   	STP     X29, X30, [SP, #-16]!	// Saves X29 and X30 to the stack
   	MOV     X29, SP			// sets frame pointer to SP

    	MOV	X3, X1			// Store max length 
	MOV	X2, #0			// Read index
	MOV	X10, #0			// Write index
	MOV	X2, #0			// index counter
	MOV	X9, #0			// binary digit count
	MOV	X12, #0			// last 'c' position
	MOV	X13, #0			// found 'c' flag

check_q:				
	MOV	X2, #0			// Reset read index for q

search_q:				// Searches for a q within the buffer
	LDRB	W4, [X0, X2]		// Loads byte at current index
	CBZ	W4, no_q		// If null terminator, no q found
	
	CMP	W4, #'q'		// Check if char is 'q'
	B.EQ	valid_quit		// Quit immediately

	ADD	X2, X2, #1		// Increment read index
	CMP	X2, X3			// check for max length
	B.LT	search_q		// Less than max length loop again

no_q:					
	MOV	X2, #0			// Reset read index to process now

find_last_c:				// Finds the 'c' within the buffer
	LDRB	W4, [X0, X2]		// Loads byte at the current read  index 
	CBZ	W4, finding_c		// null terminator
	CMP	W4, #'c'		// compare current byte to 'c'
	B.EQ	found_c			// if equal then mark as found
	ADD	X2, X2, #1		// Increment read index
	CMP	X2, X3			// check for max length
	B.LT	find_last_c		// if not continue 
	B	finding_c		// else done scanning

found_c:				// Once a 'c' is found with set a flag at the position
	MOV	X13, #1			// Set flag 'c' found
	MOV	X12, X2			// Store position of 'c'
	ADD	X12, X12, #1		// Move to positon after 'c'
	ADD	X2, X2, #1		// conitnue scanning to find last 'c'
	CMP	X2, X3			// compare to max length
	B.LT	find_last_c		// less than max length go to next byte

finding_c:				// looks for a the 'c' then copys anything after the 'c'
	CMP	X13, #1			// Check to see if found 'c'
	B.EQ	after_c			// If yes copy after last c found
	MOV	X2, #0			// if no 'c' found copy everything

loop_check:				// looks for valid char such as '0' or '1' if not then invalid
	LDRB	W4, [X0, X2]		// loads in the current char
	CBZ	W4, done_copy		// when it equals a null terminator it ends

   	// Check for '1' - store binary digit
   	CMP     W4, #'1' 		// compare char with '1'
  	B.EQ    process_bin		// if equal jump to process_bin
    
   	// Check for '0' - store binary digit
   	CMP     W4, #'0' 		// compare char with '0'
   	B.EQ    process_bin		// if equal jump to process_bin
    
   	// Check for newline - finish
    	CMP     W4, #'\n'		// compare char with '\n' newline
   	B.EQ    done_copy		// if equal jump to check_result
    	
    	B handle_invalid		// Jump to handl_invalid for any other char

after_c:				// copys anything after the last found 'c'
	MOV	X2, X12			// start copying from position after last 'c'
	B	loop_check		// jump to loop_check

valid:					// valid char stored into loops for 'c' or 'q'
	// Check the command
	LDRB	W4, [X0, #0]		// Load first char of the buffer
	CMP	W4, #'c'		// compares with 'c'
	B.EQ	found_clear		// if equal jump to found_clear
	CMP	W4, #'q'		// compare with 'q'
	B.EQ	valid_quit		// if equal jump to valid_quit

process_bin:				// Initializes the valid chars into the buffer
	STRB	W4, [X0, X10]		// Store valid char at write index
	ADD	X10, X10, #1		// Increment write index
	ADD	X9, X9, #1		// increment binary digit count
	ADD	X2, X2, #1		// increment read index
	B	loop_check		// Jump back to loop_check

done_copy:				// once copy is performed look for null terminator or 'c'
	MOV	W4, #0			// Sets W4 to 0 
	STRB	W4, [X0, X10]		// Null terminate the buffer		
	CBZ	X9, handle_invalid	// If no binary digits then invalid
	B.EQ	found_clear		// if 'c' is found jump to found_clear
	MOV	X0, #0			// Normal binary input
	B	exit			// Jump to exit

	
valid_quit:				// Exits the function
	MOV	X0, #1			// quit code
	B	exit			// jump to exit
	
found_clear:				// Exits the function 			
	MOV	X0, #0			// Buffer cleared/processed after 'c'
	B	exit			// jump to exit

handle_invalid:				// Clears buffer if there are invalid input
	MOV	X5, X0			// Clear buffer on invalid input
	MOV	X6, #0			// Set X6 to 0
	MOV	X7, #0			// Set index counter to 0

clear_invalid:				// Clears the entire buffer 
	STRB	W6, [X5, X7]		// Write null byte to buffer
	ADD	X7, X7, #1		// Increment index by 1
	CMP	X7, X3			// Compare to buffer length
	B.LT	clear_invalid		// If less than length loop to next byte
	
	MOV	X0, #3			// Return code 3 for invalid input
	B exit				// jumps to exit

exit:					// Exits the function
	LDP	X29, X30, [SP], #16	// Restore X29 and X30 form stack
	RET				// return from check_key function
