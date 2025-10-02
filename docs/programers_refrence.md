Quick Refrence guide for addresses:
See docs for details
VIA:
	$4460 = In/Oout Register B
	$4461 = In/Out Register A 
	$4462 = Data Direction for register B
	$463 = Data Direction for register A
	$4464 = Timer 1 Low-Order Latches and Low-Order Counter 
	$4465 = T1 High-Order Counter
	$4466 = T1 Low-Order Latches
	$4467 = T1 High-Order Latches
	$4468 = T2 Low-Order Latches and Low-Order Counter
	$4469 = T2 High-Order Counter
	$446a = Shift Register
	$446b = Auxiliary Control Register
	$446c = Peripheral Control Register
	$446d = Interrupt Flag Register
	$446e = Interrupt Enable Register
	$446f = Same as 4461 except for no handshake

SERIAL PORT:
	$4470 = UART Data
	$4471 = UART Status
	$4472 = UART Command
	$4473 = UART control



TO FIX THE HARDWARE BUG. Wait a certain time based on cpu clock speed.
This equation sets the value needed for the below code to set the perfect delay. If in doubt, just max it out.
~~~
X = ((1/[BAUD RATE]) * ([CPU clock in Hz]) * 10)/5.208
~~~
~~~
tx_delay:
 ldx #$ff   ; deleay determined by baud rate and cpu clok equation is below to set proper number
tx_delay_1:; ((1/[BAUD RATE]) * ([CPU clok in Hz]) * 10)/5.208 = value to load into X; be sure to round up to the nearest whole number
 dex
 bne tx_delay_1
~~~

    


Fixed table in hex, inclusive   sector size
ROM     C180 > FFFF             16000 
SCM     4480 > C17F             32000 
MISC    4474 > 447F             12
UART    4470 > 4473             4
VIA     4460 > 446F             16
VERA    4440 > 445F             32
RAND    443F                    1
CS      443E                    1(ACTIVE HIGH in hardware)
OS      0000 > 443D             17470

In Binary , inclusive(Only useful for hardware development)
ROM     1100-0001-1000-0000  >  1111-1111-1111-1111
SCM     0100-0100-1000-0000  >  1100-0001-0111-1111
MISC    0100-0100-0111-0100  >  0100-0100-0111-1111
UART    0100-0100-0111-0000  >  0100-0100-0111-0011
VIA     0100-0100-0110-0000  >  0100-0100-0110-1111
VERA    0100-0100-0100-0000  >  0100-0100-0101-1111
RAND    0100-0100-0011-1111
CS      0100-0100-0011-1110
OS      0000-0000-0000-0000  >  0100-0100-0011-1101xx

