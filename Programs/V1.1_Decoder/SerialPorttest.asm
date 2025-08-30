; same as the other Serialport code but this makes auto text scrolling

; ADDRESS CONSTANTS
ROMOFFSET = $8000
VIA_DDRA = $4463
VIA_DDRB = $4462
VIA_PORTB = $4460
UART_DATA = $4470
UART_STATUS = $4471
UART_COMMAND = $4472
UART_CONTROL = $4473
  .org $0000
  .word $0000
  .org $4180
reset:
  sei
  lda #$ff
  sta VIA_DDRB
  sta VIA_DDRB	; set all via ports to output to protect VIA
  
  sta UART_STATUS	; soft reset UART
  lda #%00011111	; 8 bits per word, no parity, ----BAUD == 19200----
  sta UART_CONTROL
  lda #%00001011	; turns basically everything off because we have nothing configed
  sta UART_COMMAND
  ldy #$00
  lda #$5d
  sta $00			; $0000 is the constant to compare y to
  ; RECIEVING DATA
RX_WAIT:  
  lda UART_STATUS
  and #%00001000	; check rx buffer status flag
  beq RX_WAIT	; wait until recieve buffer is full


  lda UART_DATA
  sta VIA_PORTB
  sta UART_DATA


  ldx #$c9
Wait:
  dex
  bne Wait
  

  iny
  cpy $00
  beq NEWLINE
  jmp RX_WAIT + ROMOFFSET

NEWLINE:
  lda #$0A
  sta UART_DATA
  ldx #$c9
Wait2:
  dex
  bne Wait2

  lda #$0D
  sta UART_DATA
  ldx #$c9
Wait3:
  dex
  bne Wait3
  ldy #$00
  jmp RX_WAIT + ROMOFFSET


  .org $7ffc
  .word reset + ROMOFFSET
  .org $7ffe
  .word $eaea
  ; 41
