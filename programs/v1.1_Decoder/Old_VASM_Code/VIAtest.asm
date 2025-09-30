  ; Writes FF to Register A on the VIA
PORTA = $4461
PORTB = $4460
DDRA = $4463
DDRB = $4462
  ; START
  .org $0000
  .word $0000
  .org $4180
  lda #%11111111
  sta DDRA
  sta DDRB
  sta PORTA
  sta PORTB
  sta $5000
  lda #%00000000
  sta PORTA
  sta PORTB
  jmp $c180
  ;END
  .org $7ffc
  .word $c180
  .org $7ffe
  .word $ffff
