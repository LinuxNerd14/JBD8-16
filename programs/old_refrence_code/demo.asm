 .org $8000 ; start point at hex 8000

reset: ; on CPU restart
 lda #$ff ;load FF instantly
 sta $6002 ; stores A to hex 6002(VIA data direction register B)

 lda #$50
 sta $6000 ; VIA register B

loop: ; loop label
 ror ; rotate A bits to the right
 sta $6000 ; VIA register B

 jmp loop ; jump back to label loop

 .org $fffc ; reset vector
 .word reset
 .word $0000 ; buffer