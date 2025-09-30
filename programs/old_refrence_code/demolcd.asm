;x0000 - 0x3fff = RAM
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





; VIA addresses
PORTB = $4460 ; B 8 bit port on VIA
PORTA = $4461 ; A 8 bit port on VIA
DDRB = $4462 ; DATA DIRECTION REGISTER for port B
DDRA = $4463 ; DATA DIRECTION REGISTER for port B

; LCD information
E = %10000000 ; enable bit is on top bit on port A of VIA
RW = %01000000 ; ReadWite bit on port A on VIA
RS = %00100000 ; register select bit on PORT A on VIA
 
 .org $0000
 .word $0000
 .org $4180 ; start point at hex 8000

reset: ; on CPU restart

 ; ----- START LCD SETUP -----

 lda #%11111111 ; load hex FF instantly only 3 pins are output and port A (% allows binary)
 sta DDRB ; sets data direction to all outputs for port B (1=output:0=input)

 lda #%11100000 ; same stuff as above but 
 sta DDRA      ; only top 3 pins are output and port A

 lda #%00111000 ; sets up the LCD logic for 8bit mode
 sta PORTB ; sends config out port B to display
 lda #0 ; Clear register select(RS)/ReadWrite(RW)/enable(E)
 sta PORTA
 lda #E ; set LCD enable to yes to send instruction
 sta PORTA
 lda #0 ; clear RS/RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #%00001110 ; Display on, Cursor on. blink off
 sta PORTB ; sends config out port B to display
 lda #0 ; Clear register select(RS)/ReadWrite(RW)/enable(E)
 sta PORTA
 lda #E ; set LCD enable to yes to send instruction
 sta PORTA
 lda #0 ; clear RS/RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #%00000110 ; incriment/shift the cursor. don't shift display
 sta PORTB ; sends config out port B to display
 lda #0 ; Clear register select(RS)/ReadWrite(RW)/enable(E)
 sta PORTA
 lda #E ; set LCD enable to yes to send instruction
 sta PORTA
 lda #0 ; clear RS/RW/E on display to allow the display to see bits on bus
 sta PORTA

 ; ----- END LCD SETUP -----

 lda #"H"
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #"e"
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #"l"
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #"l"
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #"o"
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #","
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #" "
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #"W"
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #"o"
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #"r"
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #"l"
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #"d"
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

 lda #"!"
 sta PORTB
 lda #RS ; clear RW/E bits but enables RS to send letter
 sta PORTA
 lda #(RS | E) ; set LCD enable to yes to send instruction and also sets RS to enable
 sta PORTA
 lda #RS ; clear RW/E on display to allow the display to see bits on bus
 sta PORTA

loop: ; loop label
 jmp loop ; jump back to label loop


;---end stuff---
 .org $7ffc ; reset vector
 .word $c180
 .org $7ffe
 .word $ffff ; buffer
