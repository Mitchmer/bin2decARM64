// Psuedocode:
//	After the code has been run and outputted this will 
//	be the post conditions given to the user.
//	Options given:
//	     Q - quit the program
//	     C - clear the buffer and be ready for a new input
//		 from the user

.data
newline: .asciz "\n"
buffer: .skip 24
post_opt: .asciz "Options: c to clear, q to quit:  "
quit_msg: .asciz "Program has ended\n"

.text
 .global post_key

post_key:
	STP	X29, X30, [SP, #-16]!   // SAve frame pointer and ret address
	STP 	X19, X20, [SP, #-16]!   // Save called refisters
	MOV	X19, SP			// X19 = buffer pointer
	

post_cond:
	
	MOV 	X0, #1
	LDR	X1, =post_opt
	MOV	X2, #32
	MOV	X8, #64
	SVC	0

	MOV	X0, #0
	MOV	X1, X19
	MOV	X2, #1
	MOV	X8, #63
	SVC	0

	LDRB	W0, [X19]
	

	// Checks for 'c' - clear buffer
	CMP	W0, #'c'
	B.EQ	clear
	
	// Checks for 'q' - quit program
	CMP	W0, #'q'
	B.EQ	quit

	B	finish	

clear:
	MOV	X2, #0	
	RET
quit:
	MOV	X0, #1
	LDR	X1, =quit_msg
	MOV	X2, #30
	MOV	X8, #64
	
	SVC 	0

	B	exit
finish:
	LDP	X19, X20, [SP], #16	// Restores called registers
	LDP	X29, X30, [SP], #16	// Restores the pointer and address
	RET

exit:
	MOV	X8, #93
	MOV	X0, #0
	SVC	0
