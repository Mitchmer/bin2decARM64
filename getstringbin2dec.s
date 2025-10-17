// Osvaldo Medina
// CS3B - Lab6-1 - getstring
// 10/11/25
//*****************************************************************************************
// getstring
//	Function getstring: Will read a string of characaters up to to a specified length
//	from the console and save it in a specified buffer as a C-string (i.e. null
//	terminated).
//
//	X0: Points to the first byte of the buffer to receive the string. This must be 
//	    preserved i.e. X0 should still point to the buffer when this function returns).
//	X1: The maximum length of the buffer pointer to by X0 (note this length
//	    should account for the null termination of the read string (i.e. C-String)
//	LR: Must contain the return address (automatic when BL
//	    is used for the call)
//	All AAPCS mandated registers are preserved  
//****************************************************************************************
// This function is used to read a line from the keyboard and to store it into the buffer
// The buffer recieves the input string to be stored in memory while also having a limit.
// If the limit is reached it will no longer store anymore characters in the buffer.
// Using linux read() to read characters and also has the newline so that when the user
// presses enter the console goes to the next line after the input is recieved.
// It is null terminated so that there is a valid C-string.
//***************************************************************************************

.text
.global getstringbin2dec

getstringbin2dec:

	STP	X19, X20, [SP, #-16]!	// push X19 and X20 to the stack
	STP	X21, X30, [SP, #-16]!	// push X21 and LR to stack
		
	MOV	X19, X0			// X19 = buffer pointer
	MOV	X20, X1			// X20 = buffer length
	
	MOV	X0, #0			// X0 = stdin
	MOV	X1, X19			// X1 = buffer address in order to store input
	SUB	X2, X20, #1		// X2 = max bytes that can be read
	MOV	X8, #63			// X8 = read
	SVC	#0			// reads input from the KBD

	MOV	X21, X0			// Stores the bytes read into X21 
	
	CBZ	X21, finish		// If no bytes are left then jumps to finish

	MOV	X22, #0			// index counter

	MOV	X1, X19
	MOV	X2, X21
	MOV	X3, X20
	BL	check_key
	
	MOV	X21, X2
	
newline_check:
	
	CMP	X22, X21		// checks to see if reached end of input
	B.GE	finish			// if so then goes to finish
	
	LDRB	W23, [X19, X22]		// loads current character
	CMP	W23, #'\n'		// newline
	B.EQ	found_newline		// if there is a newline then go to found_newline
	ADD	X22, X22, #1		// increments the index
	B	newline_check		// loops back
	
found_newline:
	
	MOV	W23, #0			// null terminator
	STRB	W23, [X19, X22]		// replaces '\n' to '\0'
	B	finish			// Goes to finish
	
finish:
	
	MOV	W23, #0			
	STRB	W23, [X19, X21]		// terminates after the last char

	MOV 	X0, X19			// restores X0 to point at the buffer
	
	LDP	X29, X30, [SP], #16	// adjusts the stack by restoring LR
	RET
