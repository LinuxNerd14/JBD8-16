;START
  .org $0000
  .word $0000
  .org $4180
ROMOFFSET = $8000
;ADDRESSES
PORTB = $4460
PORTA = $4461
DDRB = $4462
DDRA = $4463
; LCD CONSTANTS
LCD_E = %10000000 ; enable bit on LCD on port a to control read/write
LCD_RW = %01000000 ; Read/Write bit on the LCD port a, used to select wheather to read or write
LCD_RS = %00100000 ; Register Select on the LCD port a, turning this on allows the send of characters
LCD_8BIT = %00111000 ; Sets the display for 8 bit mode, to be the first thing set on port B

;Code
reset:	; Run on reset
; SET UP THE DISPLAY
  lda #$FF
  sta DDRB	;set all the pins on PortB to output

  lda #%11100000
  sta DDRA	;set the top 3 bits to output on portA inorder to control LCD properly
  
  lda #LCD_8BIT
  sta PORTB	;sets the LCD for fast 8 bit operation
  jsr LCD_SEND_CONFIG + ROMOFFSET

  lda #%00001110 ; Confing display settings, see docs page 43 table 13
  sta PORTB
  jsr LCD_SEND_CONFIG + ROMOFFSET

  lda #%00000110 ; Cofing more display settings
  sta PORTB
  jsr LCD_SEND_CONFIG + ROMOFFSET


; SEND TEXT
  lda #"H"
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET
  lda #"E"
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET
  lda #"L"
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET
  lda #"L"
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET
  lda #"O"
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET
  lda #","
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET
  lda #" "
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET
  lda #"W"
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET
  lda #"O"
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET
  lda #"L"
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET
  lda #"D"
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET
  lda #"!"
  sta PORTB
  jsr LCD_SEND_CHAR + ROMOFFSET

  sta $4470

  ; LCD DATA SEND routine, call after sending data to PORTB
LCD_SEND_CONFIG:
  lda #$00
  sta PORTA	;turns off all the control bits
  lda #LCD_E
  sta PORTA	;turn on the enable bit to send config data
  lda #$00
  sta PORTA	;turns off all the control bts
  rts
LCD_SEND_CHAR:
  lda #$00
  sta PORTA	;turns off all the control bits
  lda #(LCD_E | LCD_RS)
  sta PORTA	;turn on the enable bit and the RS bit to send a character 
  lda #$00
  sta PORTA	;turns off all the control bts
  rts

;END
  .org $7ffc
  .word $c180
  .org $7ffe
  .word $ffff
