 ; This test is to check the bare minimum functionality for the V1 decoder of the computer. It tests CPU, ROM, and Decoder by flashing the CS and RAND lights.
 ;ROM size in hex is 8000 and to the CPU starts at C182
 .org $0000
 .word $0000
 .org $4180 ;c180 to the cpu then the code immedialty follows
reset: ; on CPU starts
 sei
 cld
 lda #$FF
 ;sta $443E	;CS 
 sta $443F	;RAND
 sta $4440	;VERA
 sta $4460	;VIA
 sta $4470	;UART
 sta $4474	;MISC
 sta $4480	;SCM
 jmp $c184 ; jump back to label "reset" to first addr in ROM 


 .org $7ffc ; places the word in little endian c182 at 7FFC and 7FFD
 .word $c180    ; when the proccesor reads this it jumps to that address c182 happens to be the start of ROM for pogram excecution
; 8000 hex = FFFF to the computer
 .org $7FFE
 .word $FFFF
