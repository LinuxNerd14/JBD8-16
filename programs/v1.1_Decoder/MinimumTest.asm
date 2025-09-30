 .org $0000
 .word $0000
 .org $4180 ;c180 to the cpu then the code immedialty follows
reset: ; on CPU starts
 sei
 cld
 lda #$ea
 sta $0000	;OS
 lda $0000	;OS
 ldx #$11
 stx $1111	;
 ldx $1111
 ldy #$ff
 sty $2222
 ldy $2222
 lda #$99
 sta $443d
 lda $443d
 jmp $c180 ; jump back to label "reset" to first addr in ROM


 .org $7ffc ; places the word in little endian c182 at 7FFC and 7FFD
 .word $c180    ; when the proccesor reads this it jumps to that address c182 happens to be the start of ROM for pogram excecution
; 8000 hex = FFFF to the computer
 .org $7FFE
 .word $FFFF
