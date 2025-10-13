// Osvaldo Medina
// CS3B - Lab6-1 - driver6-1
// 10/11/25
//********************************************************************
// This driver program will utilize the getstring 
// in order to output a user given string.
// First it prepares to read the input with a maximum of 8 characters
// then calls the function getstring that will read the characters
// from the keyboard. Then once either enter or the buffer is full 
// it will stop storing onto the buffer and output using enter.
// After enter is pressed it will relay the message that was given
// Afterwards exit the program.

.data

newline: .asciz	"\n"
buffer:	.skip 24


.text

.global _start

_start:

	LDR	X0, =buffer	// X0 = address of input buffer
	MOV	X1, #20		// X1 = buffer length
	BL	getstring	// call getstring
		
	MOV 	X0, #1		// X0 = stdout
	LDR	X1, =buffer	// X1 = address of buffer
	MOV	X2, #16		// X2 = max number of bytes
	MOV	X8, #64		// X8 = syscall 64 to write
	SVC	#0		// prints the string

	MOV	X0, #1		// X0 = stdout
	LDR	X1, =newline	// X1 = address of newline
	MOV	X2, #1		// X2 = length of 1 byte
	MOV	X8, #64		// X8 = write
	SVC	0		// prints the newline

	MOV	X8, #93		// X8 = exit
	MOV	X0, #0		// X0 = return
	SVC	#0		// program ends
