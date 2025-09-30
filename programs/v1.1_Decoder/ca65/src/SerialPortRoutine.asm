; This program is designed to take whatever input from the serial port and then:
; 	Writes the infromation to VIA port B
; 	Echo the same value back out of the Serial Port
; This starts up the computer and initilizes the UART and the VIA.
; When the computer is ready a ":" is sent out the serial port
;

; ADDRESS CONSTANTS
VIA_DDRA = $4463
VIA_DDRB = $4462
VIA_PORTB = $4460
UART_DATA = $4470
UART_STATUS = $4471
UART_COMMAND = $4472
UART_CONTROL = $4473
  .PC02
reset:
  sei
  lda #$ff
  sta VIA_DDRB
  sta VIA_DDRA	; set all via ports to output to protect VIA
  
  sta UART_STATUS	; soft reset UART
  lda #%00011111	; 8 bits per word, no parity, ----BAUD == 19200----
  sta UART_CONTROL
  lda #%00001011	; turns basically everything off because we have nothing configed
  sta UART_COMMAND

  lda #$3A		; Sends a ":"(represented by 3A) out of the serial port in order to let the user know the computer is ready
  sta UART_DATA
  jsr WAIT 
  ; RECIEVING DATA
RX_WAIT:  
  lda UART_STATUS
  and #%00001000	; check rx buffer status flag
  beq RX_WAIT	; wait until recieve buffer is full


  lda UART_DATA
  sta VIA_PORTB
  sta UART_DATA

  jsr WAIT
  jmp RX_WAIT
WAIT:
  pha
  txa
  pha
  ldx #$c9
wait2:
  dex
  bne wait2
  pla
  tax
  pla
  rts
  ; 41
.segment "VECTORS"
		.word	$0F00
		.word	$C180
		.word	$0000
