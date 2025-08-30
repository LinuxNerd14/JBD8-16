;ROM size in hex is 8000 and to the CPU starts at C182 | RAM starts at 0041 to 447F inclusive
 
 .org $0000 ;c182 to the cpu then the code immedialty follows
reset: ; on CPU restart
 ldx #$0a
 lda #$00 ;load 00 instantly
 sta $0041 ;store 00 at the first address in OS RAM
loop:   ; only pokes RAND if X == A
 lda $0041  ; load from RAM
 inc   ;incriment data from RAM
 sta $0041  ;store the incrimented data back to RAM
 cpx $0041   ;compare value in reg X to accumulator
 beq rand ; if data in X and A are the same jump to poke RAND otherwise continue to poke CS
 stx $5000  ;poke SCM
 jmp loop

rand:
 stx $0001  ;poke RAND
 lda #$00
 sta $0041
 jmp loop


 jmp $0000 ; jump back to label "reset" to continue looping 


 .org $7FFC ; places the word in little endian c182 at 7FFC and 7FFD
 .word $C182    ; when the proccesor reads this it jumps to that address c182 happens to be the start of ROM for pogram excecution
 .word $0000