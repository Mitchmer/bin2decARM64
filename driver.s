//============================================================================
//  Mitch Merrell, Osvaldo Medina Hernandez | Bin2Dec Project Group 5
//  CS3B - Bin2Dec Group Project
//  Date Created: 10/08/2025
//  Date Last Modified: 10/08/2025
//===== if just a function, don't include this next part =====================
//  *** PROGRAM DESCRIPTION ****
//  Algorithm/Pseudocode:
//      ALGORITHM GOES HERE
//============================================================================

.global _start
    .text                   // code body start

_start:
    .EQU    SYS_EXIT, 93    // service code for program exit

    MOV X0, #0              // Prepare a 0 return code
    MOV X8, #SYS_EXIT       // Linux system call code for exit
    SVC 0                   // Supervisor call to terminate program

    .data
.end                        // code body end    
 
