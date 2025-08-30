 ; This test is to check the bare minimum functionality for the V1 decoder of the computer. It tests CPU, ROM, and Decoder by flashing the CS and RAND lights.
 ;ROM size in hex is 8000 and to the CPU starts at C182
 
 .org $0000 ;c182 to the cpu then the code immedialty follows
reset: ; on CPU restart
 lda #$ff ;load FF instantly
 sta $0000 ; stores A to whaterver is at the CS address
 sta $0001
 sta $0000 ; stores A to whaterver is at the CS address
 sta $0001
 sta $0000 ; stores A to whaterver is at the CS address
 sta $0001
 sta $0000 ; stores A to whaterver is at the CS address
 sta $0001
 sta $0000 ; stores A to whaterver is at the CS address
 sta $0001
 sta $0000 ; stores A to whaterver is at the CS address
 sta $0001
 sta $0000 ; stores A to whaterver is at the CS address
 sta $0001
 jmp $0000 ; jump back to label "reset" to continue looping 


 .org $7FFC ; places the word in little endian c182 at 7FFC and 7FFD
 .word $C182    ; when the proccesor reads this it jumps to that address c182 happens to be the start of ROM for pogram excecution
 .word $0000