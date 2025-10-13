// Pseudocode:
//	Once the user inputs a c-string and hits enter it 
//	go through the getstring and be checked through
//	the check_key for valid characters.
//	q - quits the program
//	c - clears the program
//	0's - get stored in the buffer
//	1's - get stored into the buffer

check_key:
    
   	 STP     X29, X30, [SP, #-16]!
   	 MOV     X29, SP
    
   	 // Check for 'c' - clear buffer
   	 CMP     W0, #'c'
   	 B.EQ    clear
    
   	 // Check for 'q' - quit program  
   	 CMP     W0, #'q'
   	 B.EQ    quit
    
   	 // Check for '1' - store binary digit
   	 CMP     W0, #'1' 
  	 B.EQ    bin
    
   	 // Check for '0' - store binary digit
   	 CMP     W0, #'0' 
   	 B.EQ    bin
    
   	 // Check for newline - finish
    	CMP     W0, #'\n'
   	 B.EQ    finish
    
    	// Ignore all other characters
   	 MOV     X0, #0
   	 B       exit

clear:
   	 MOV     X2, #0          // Reset index to 0
   	 MOV     X0, #0          // Continue reading
   	 B       exit

quit:
    	MOV     X0, #2          // Return quit code
   	 B       exit

bin:	
	CMP	X2, X3		// Check to see if buffer is full
	B.GE	exit		// if it is full then ignore	

	STRB 	W0, [X1, X2]	// stores into the buffer
	ADD	X2, X2, #1	// increments the index by 1
	MOV	X0, #0		// coninue reading
	B	exit

finish:
	MOV 	X0, #1		// returns
	
exit:
	LDP	X29, X30, [SP], #16	// restores the pointer and address
	RET
