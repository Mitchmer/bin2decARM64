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
//	Char index = 0 
//	binary count = 0
//
//	The processing loop (loop_check) will continue to loop until the null terminator
//	First - loads in the current char 
//	Goes through the cases:
//		'c' - Jumps to verify this command "check_command"
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
//	
//	check_result: 
//	If - no binary digits are found then it is an invalid input
//	 will jump to invalid
//	
//	checks first char again to look for 'c' or 'q'
//	otherwise will return the valid binary code
//	
//	Invalid input - Set up pointers and counters 
//			Replace each char in the buffer with null bytes 
//			Moves to the next position 
//			continues doing so until entire buffer is cleared
//			
//			calls the flush_buff
//
//			Return 3 is invalid input
//
//	found_clear: - Saves the buffer in memory
//			Prepares the number 0 
//			Goes through the buffer one position at a time and puts a 0 in 
//			the current position
//			Moves to the next positiona nd repeats until it has erased
//			the entire buffer
//
//	Flush_buff - Save registers that are used 
//		     Set the file descriptor for keyboard input
//		     Set up a temp 1 byte buffer for reading char
//		     
//	flush_loop - Makes the system call to read 1 char from keyboard
//		     check the result 
//			if: read fails then break out of the loop
//			if: the char reads a newline break out of the loop
//			else: continue reading next char
//		    Restore the registers we saved
//		    Return to the calling function
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

	MOV	X2, 0			// index counter
	MOV	X9, 0			// binary digit count

loop_check:
	LDRB	W4, [X0, X2]		// loads in the current char
	CBZ	W4, exit		// when it equals a null terminator it ends

   	 // Check for 'c' - clear buffer
   	 CMP     W4, #'c'		// compares char with 'c'
   	 B.EQ    check_command		// if equal jump to check_command
    
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
   	B.EQ    check_result		// if equal jump to check_result
    	
    	B handle_invalid		// Jump to handl_invalid for any other char

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
	B.EQ	found_quit		// if equal jump to found_quit

process_bin:
	// If it over 16 digits then skip these digits
	CMP	X9, #16			// Compare to binary cound with 16
	B.GE	skip_digit		// If greater than or equal to 16 jump to skip digit
	ADD	X9, X9, #1		// increments the binary count

skip_digit:
	ADD	X2, X2, #1		// Increment char index
	CMP	X2, X3			// compare index with max_lenght
	B.LT	loop_check		// If less than continue loop
	B	check_result		// Jumps to check_result if not

check_result:
	CBZ	X9, handle_invalid 	// If no binary digits found then jump to handle_invalid
	LDRB	W4, [X0, #0]	   	// laod first char of the buffer
	CMP	W4, #'c'		// compare with 'c'
	B.EQ	found_clear		// if equal jump to found_clear
	CMP	W4, #'q'		// compare with 'q'
	B.EQ	found_quit		// if equal jump to found_quit
	
	MOV	X0, #0			// sets return code to 0 
	B exit				// jump to exit

found_clear:
	MOV	X5, X0			// buffer pointer
	MOV	X6, #0			// null byte
	MOV	X7, #0			// index
clear:
	STRB	W6, [X5, X7]		// clear buffer
	ADD	X7, X7, #1		// increments the clearing index to move to next char
	CMP	X7, X3			// compares current index with max buffer length
	B.LT	clear			// if index is less than max length continue to loop
	
	MOV	X0, #2			// set return code to 2 
	B	exit			// branch to exit to retunr from function
	
found_quit:
	MOV	X0, #1			// Set return code to 1
	B	exit			// Jump to exit

handle_invalid:
	MOV	X5, X0			// Store buffer pointer to X5
	MOV	X6, #0			// Set null byte valyue in X6
	MOV	X7, #0			// Initialize clear index to 0


clear_loop:
	STRB	W6, [X5, X7]		// store null byte at buffer [X7]
	ADD	X7, X7, #1		// Increment clear index
	CMP	X7, X3			// compare clear inxed with max_length
	B.LT	clear_loop		// if less than continue clearing

	BL	flush_buff		// call the flush_buff function 
	MOV	X0, #3			// set return code to 3
	B	exit			// jump to exit
	

flush_buff:
	STP	X29, X30, [SP,#-16]!	// Push X29 and X30 onto the stack
	MOV	X29, SP			// Set frame pointer
	STP	X19, X20, [SP, #-16]!	// Push X19 and X20 onto stack

	MOV	X19, #0			// Set STDin file descriptor 0 in X19
	LDR	X20, =flush_char	// Load address of flush_char into X20

flush_loop:
	LDR	X1, =flush_char		// Set buffer address for read
	MOV	X2, #1			// Set read length to 1 byte
	MOV	X0, #0			// Set file descriptor to STDin
	MOV	X8, #63			// Set syscall number for read
	SVC	0			// execute read syscall
	
	CMP	X0, 0			// compare bytes read wth 0
	B.LE	flush_done		// if less than or equal to jump to flush_done

	LDR	X1, =flush_char		// Load flush_char into X1
	LDRB	W7, [X1]		// Load char form flush_char buffer
	CMP	W7, #10			// Compare with newline
	B.EQ	flush_done		// If equal jump to flush_done
	B	flush_loop		// otherwise continue
	
flush_done:
	LDP	X19, X20, [SP], #16	// Restore X19 and X20 from stack
	LDP	X29, X30, [SP], #16	// Restore X29 and X30 form stack
	RET				// return from flush_buff function

end:
	MOV	X8, #93			
	MOV	X0, #0
	SVC	0

exit:
	LDP	X29, X30, [SP], #16	// Restore X29 and X30 form stack
	RET				// return from check_key function
