;0x0000 - 0x3fff = RAM
;0x4000 - 0x5fff = Open Bus (Invalid Memory Addresses)
;0x6000 = I/O Register B
;0x6001 = I/O Register A
;0x6002 = Data Direction Register B
;0x6003 = Data Direction Register A
;0x6004 = T1 Low Order Latches/Counter
;0x6005 = T1 High Order Counter
;0x6006 = T1 Low Order Latches
;0x6007 = T1 High Order Latches
;0x6008 = T2 Low Order Latches/Counter
;0x6009 = T2 High Order Counter
;0x600a = Shift Register
;0x600b = Auxiliary Control Register
;0x600c = Peripheral Control Register
;0x600d = Interrupt Flag Register
;0x600e = Interrupt Enable Register
;0x600f = I/O Register A sans Handshake (I do not believe this computer uses Handshake anyway.)
;0x6010 - 0x7fff - Mirrors of the sixteen VIA registers
;0x8000 - 0xffff = ROM




; ----- START CONSTANTS -----
;----- START VIA -----
PORTB = $6000 ; B 8 bit port on VIA
PORTA = $6001 ; A 8 bit port on VIA
DDRB = $6002 ; DATA DIRECTION REGISTER for port B
DDRA = $6003 ; DATA DIRECTION REGISTER for port B
T1CL = $6004
T2Ch = $6005
ACR = $600B
IER = $600E
;----- END VIA -----
;----- START LCD -----
E = %10000000 ; enable bit is on top bit on port A of VIA
RW = %01000000 ; ReadWite bit on port A on VIA
RS = %00100000 ; register select bit on PORT A on VIA
;----- END LCD -----
;----- START ACIA(UART) -----
ACIA_DATA = $5000
ACIA_STATUS = $5001
ACIA_CMD = $5002
ACIA_CTRL = $5003
;----- END ACIA -----
;----- END CONSTANTS -----
 .org $8000 ; start point at hex 8000: I wouldn't touch or move this
; ----- START RESET -----
reset: ; on CPU restart
 lda #$ff
 txs
 jsr lcd_start

 lda #00
 sta ACIA_STATUS ; soft reset ACIA

 lda #$1f ; 8-bits per word; no parity; one stop bit; baud 19200 (ACIA)
 sta ACIA_CTRL

 lda #$0b ; no parity; no echo, no interrupts
 sta ACIA_CMD
 ldx #$00
send_msg:
 lda message,x
 beq rx_wait
 jsr send_char
 inx
 jmp send_msg
rx_wait:
 lda ACIA_STATUS    ;check if rx buffer status flag
 and #$08
 beq rx_wait ; loop if rx buffer empty

 lda ACIA_DATA
 jsr print_char
 jmp rx_wait

message: .asciiz "Hi! Human"
; ----- END RESET -----
; ----- START MAIN -----
main:
;----- END MAIN -----
; This done loop is to be called when the main is done
doneloop:
 jmp doneloop
;----- START SUB ROUTINES -----
;----- START LCD DISPLAY -----
lcd_instruction: ; takes info from register A and sends it to the display as configuration
 jsr lcd_wait
 sta PORTB ; sends config out port B to display
 lda #0 ; Clear register select(RS)/ReadWrite(RW)/enable(E)
 sta PORTA
 lda #E ; set LCD enable to yes to send instruction
 sta PORTA
 lda #0 ; clear RS/RW/E on display to allow the display to see bits on bus
 sta PORTA
 rts

print_char: ; prints contents of A register to screen
 jsr lcd_wait
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA
 rts

lcd_wait: ; waits for the LCD display to be ready for more instructions
 pha ; takes value from A and puts it on stack as to make sure it doesn't get corrupted 
 lda #%00000000 ; Port B is all inputs
busylcd:
 sta DDRB
 lda #RW
 sta PORTA
 lda #(RW | E)
 sta PORTA
 lda PORTB
 and #%10000000 ; taking info from the lcd anding it with this binary allows the detection of the busy flag
 bne busylcd ; restarts busylcd loop if busy flag is set
 lda #RW
 sta PORTA
 lda #%11111111 ; port B is output
 sta DDRB
 pla ; resets A register to value bofore sub routine was called
 rts
lcd_clear: ; clears the lcd display
 pha ; pushes a to stack to keep it from being corrupted by the sub routine
 lda #$00000001 ; binary instruction to clear the display
 jsr lcd_instruction
 jsr lcd_instruction
 jsr lcd_instruction
 jsr lcd_instruction
 jsr lcd_instruction                             ; stupid way to deal with slow lcd clear time but i really don't care
 jsr lcd_instruction
 jsr lcd_instruction
 pla ; restores a to before sub routine call
 rts
lcd_start:
 pha
 lda #%11111111 ; load hex FF instantly only 3 pins are output and port A (% allows binary)
 sta DDRB ; sets data direction to all outputs for port B (1=output:0=input)
 lda #%11100000 ; same stuff as above but 
 sta DDRA      ; only top 3 pins are output and port A
 lda #%00111000 ; sets up the LCD logic for 8bit mode
 jsr lcd_instruction
 lda #%00001110 ; Display on, Cursor on. blink off
 jsr lcd_instruction
 lda #%00000110 ; incriment/shift the cursor. don't shift display
 jsr lcd_instruction
 pha

send_char:
 sta ACIA_DATA
 pha
 phx
tx_delay:
 ldx #$ff   ; deleay determined by baud rate and cpu clok equation is below to set proper number
 tx_delay_1:; ((1/[BAUD RATE]) * ([CPU clok in Hz]) * 10)/5.208 = value to load into X; be sure to round to the nearest whole number
 dex
 bne tx_delay_1
 plx
 pla
 rts
;----- END SERIAL PORT -----
;----- END SUB ROUTINES -----
;---end stuff + INTURUPTS---
nmi:
 rti
irq:
 rti

 .org $fffa ; reset vector
 .word nmi
 .word reset
 .word irq