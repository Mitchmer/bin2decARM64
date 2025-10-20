//****************************************************************************************************************
//  Pseudocode:
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
//	Scan for last found 'c' in the input
//		loops through the buffer looking for a 'c' if found set found_c flag and
//		add one to the current index within the buffer
//
//	Determine copy start position
//		If 'c' is found after_c 
//		if no then begin copyying from the buffer
//
//	The processing loop (loop_check) will continue to loop until the null terminator
//	First - loads in the current char 
//	Goes through the cases:
//		'q' - Jumps to verify this command "check_command"
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
//	Restore the original frame pointer and return address return to the calling function with the result code 
//	
//********************************************************************************************************************
.data
quit_msg: .asciz "Program has ended\n"
flush_char: .byte 0

.text
.global check_key

check_key: 
 
   	STP     X29, X30, [SP, #-16]!	// Saves X29 and X30 to the stack
   	MOV     X29, SP			// sets frame pointer to SP

    	MOV	X3, X1			// Store max length 
	MOV	X2, #0			// Read index
	MOV	X10, #0			// Write index
	MOV	X2, #0			// index counter
	MOV	X9, #0			// binary digit count
	MOV	X12, #0			// last 'c' position
	MOV	X13, #0			// found 'c' flag

find_last_c:
	LDRB	W4, [X0, X2]		// Loads byte at the current read  index 
	CBZ	W4, finding_c		// null terminator
	CMP	W4, #'c'		// compare current byte to 'c'
	BEQ	found_c			// if equal then mark as found
	ADD	X2, X2, #1		// Increment read index
	CMP	X2, X3			// check for max length
	B.LT	find_last_c		// if not continue 
	B	finding_c		// else done scanning

found_c:
	MOV	X13, #1			// Set flag 'c' found
	MOV	X12, X2			// Store position of 'c'
	ADD	X12, X12, #1		// MOve to positon after 'c'
	ADD	X2, X2, #1		// conitnue scanning to find last 'c'
	CMP	X2, X3			
	B.LT	find_last_c

finding_c:
	CMP	X13, #1			// Check to see if found 'c'
	BEQ	after_c			// If yes copy after last c found
	MOV	X2, #0			// if no 'c' found copy everything

loop_check:
	LDRB	W4, [X0, X2]		// loads in the current char
	CBZ	W4, done_copy		// when it equals a null terminator it ends
    
   	 // Check for 'q' - quit program  
   	 CMP     W4, #'q'		// compare char with 'q'
   	 B.EQ    check_command		// if equal, jump to check_command
    
   	 // Check for '1' - store binary digit
   	 CMP     W4, #'1' 		// compare char with '1'
  	 B.EQ    process_bin		// if equal jump to process_bin
    
   	 // Check for '0' - store binary digit
   	 CMP     W4, #'0' 		// compare char with '0'
   	 B.EQ    process_bin		// if equal jump to process_bin
    
   	 // Check for newline - finish
    	CMP     W4, #'\n'		// compare char with '\n' newline
   	B.EQ    done_copy		// if equal jump to check_result
    	
    	B valid		// Jump to handl_invalid for any other char

after_c:
	MOV	X2, X12			// start copying from position after last 'c'
	B	loop_check		// jump to loop_check

check_command:
	ADD	X2, X2, #1		// Increments index to the next character
	LDRB	W4, [X0, X2]		// Loads next char from the buffer
	CBZ	W4, valid		// If null terminator then jump to valid
	CMP	W4, #'\n'		// compares to newline
	B.EQ	valid			// If newline then jump to valid
	B	handle_invalid		// anything else is handle_invalid

valid:
	// Check the command
	LDRB	W4, [X0, #0]		// Load first char of the buffer
	CMP	W4, #'c'		// compares with 'c'
	B.EQ	found_clear		// if equal jump to found_clear
	CMP	W4, #'q'		// compare with 'q'
	B.EQ	valid_quit		// if equal jump to valid_quit

process_bin:
	STRB	W4, [X0, X10]		// Store valid char at write index
	ADD	X10, X10, #1		// Increment write index
	ADD	X9, X9, #1		// increment binary digit count
	ADD	X2, X2, #1		// increment read index
	B	loop_check		// Jump back to loop_check
done_copy:
	MOV	W4, #0			
	STRB	W4, [X0, X10]		// Null terminate the buffer		
	CBZ	X9, handle_invalid	// If no binary digits then invalid
	BEQ	found_clear		// if 'c' is found jump to found_clear
	MOV	X0, #0			// Normal binary input
	B	exit			// Jump to exit

check_quit:
	ADD	X2, X2, #1		// Check next char to confirm quit
	LDRB	W4, [X0, X2]		// W4 = 'q'
	CBZ	W4, valid_quit		// Compare to 0
	CMP	W4, #'\n'		// if next char is newline valid quit
	BEQ	valid_quit
	B	valid_quit		// if there are more char after then invalid
	
valid_quit:
	MOV	X0, #1			// quit code
	B	exit
found_clear:
	MOV	X0, #0			// Buffer cleared/processed after 'c'
	B	exit
handle_invalid:
	MOV	X5, X0			// Clear buffer on invalid input
	MOV	X6, #0
	MOV	X7, #0
clear_invalid:
	STRB	W6, [X5, X7]		// Write null byte to buffer
	ADD	X7, X7, #1
	CMP	X7, X3
	B.LT	clear_invalid
	
	MOV	X0, #3			// Return code 3 for invalid input
	B exit
exit:
	LDP	X29, X30, [SP], #16	// Restore X29 and X30 form stack
	RET				// return from check_key function
