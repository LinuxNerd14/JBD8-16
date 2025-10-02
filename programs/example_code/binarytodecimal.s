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
;----- END VIA -----
;----- START LCD -----
E = %10000000 ; enable bit is on top bit on port A of VIA
RW = %01000000 ; ReadWite bit on port A on VIA
RS = %00100000 ; register select bit on PORT A on VIA
;----- END LCD -----
;----- END CONSTANTS
;----- START VARIABLES -----
value = $0200 ; 2 byte
mod10 = $0202 ; 2 byte
message = $0204 ; 6 bytes
;----- END VARIABLES -----
 .org $8000 ; start point at hex 8000: I wouldn't touch or move this
; ----- START RESET -----
reset: ; on CPU restart
; ----- START LCD SETUP -----
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
 jsr lcd_clear
; ----- END LCD SETUP -----
; ----- END RESET -----
; ----- START MAIN -----
main:
 lda #0
 sta message

; Initialize value to be the number to convert
 lda number
 sta value
 lda number + 1
 sta value + 1

divide:
; Initialize the remainder to zero
 lda #0
 sta mod10
 sta mod10 + 1
 clc

 ldx #16
divloop:
; Rotate quotient and remainder
 rol value
 rol value + 1
 rol mod10
 rol mod10 + 1

; A,Y = dividend - divisor
 sec
 lda mod10
 sbc #10
 tay ; save low byte in Y
 lda mod10 + 1
 sbc #0
 bcc ignore_result ; branch if dividend is < divisor
 sty mod10
 sta mod10 + 1

ignore_result:
 dex
 bne divloop
 rol value ; shift in the last bit of the quptient
 rol value + 1


 lda mod10
 clc
 adc #"0"
 jsr push_char

 ;if value != 0, thebn continue dividing
 lda value
 ora value + 1
 bne divide ; branch if value not zero

 ldx #0
 print:
 lda message,x ; load message + value at X into A
 beq doneloop
 jsr print_char
 inx
 jmp print
;----- END MAIN -----
; This done loop is to be called when the main is done
doneloop:
 jmp doneloop

number: .word 1729
;----- START SUB ROUTINES -----
; Add the character in the A register to the beginning of the
;null-terminated string 'message'
push_char:
 pha ; push new first character onto the stack
 ldy #0

charloop:
 lda message,y ; Get char string and put into X
 tax
 pla
 sta message,y ; Pull char off stack and add it to the string
 iny
 txa
 pha ; Push char from string onto stack
 bne charloop

 pla
 sta message,y ; Pulls the null off the stack and add to the end of the string

 rts
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
;----- END LCD DISPLAY-----
;----- END SUB ROUTINES -----
;---end stuff---
 .org $fffc ; reset vector
 .word reset
 .word $0000 ; buffer