PORTA = $4461
PORTB = $4460
DDRA = $4463
DDRB = $4462
ROMOFFSET = $8000
  ; START
  .org $0000
  .word $0000
  .org $4180
reset:
  sei
  lda #$FF
  sta DDRB
  lda #%00000000
  sta $00
loop:
  lda $00
  inc
  sta PORTB
  sta $00
  jmp loop + ROMOFFSET
  ;END
  .org $7ffc
  .word $c180
  .org $7ffe
  .word $ffff

