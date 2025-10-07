# Programming Reference Guide for the JBD8-16 Computer

## Table of Contents:

1. Introduction

2. System Overview

3. Programming

## 1: Introduction

- **What this computer is**  
  A short description of the computer, its purpose (general-purpose? educational? experimental?), and why it’s interesting to program.

- **Target audience**  
  Clarify whether it’s meant for beginners in assembly, hobbyists, or advanced programmers.

## 2: System Overview

- **CPU**: Name (e.g., WDC 65C02, 6502, custom CPU), clock speed, instruction set basics.

- **Memory map**: A clear diagram or table showing where RAM, ROM, I/O devices, banked memory, etc. live in the address space.

- **I/O devices**: Serial port, display, input devices, etc. (what they are, where they are mapped, how to access them).

- **Special features**: Memory banking, random number generator, interrupt handling, etc.

## 3: Programming

#### Overview

This computer can be programmed in straight up in 65C02 assembly or C using cc65. The opcodes for assembly can be found in the documentation for the CPU [here](https://www.westerndesigncenter.com/wdc/documentation/w65c02s.pdf) or you can [also go here]([6502.org Tutorials: 65C02 Opcodes](http://www.6502.org/tutorials/65c02opcodes.html)) for a more human-readable explanation and description of 65C02 assembly. Programming in C is not implemented yet but will be soon. The "programs" directory is organized by memory decoder version since differences in it fundamentally change the programming of the computer. As of now the latest is V1.1 but use whatever is appropriate for your hardware.

### Making Programs

#### 65C02 Assembly

Writing code is a three-step process. In order: writing the program; compiling the program; padding the program. After these steps are completed, you should hopefully have a valid binary file that you can write to either the EEPROM or a micro SD card. 
The compiler of choice is [ca65](https://cc65.github.io/doc/ca65.html) and its sibling ld65. ca65 compiles the program and ld65 being the [linker](https://en.wikipedia.org/wiki/Linker_(computing)), links it and thus produces a binary file. 

###### Writing a Program
In the future there will be two places to put programs on the computer. A micro SD card and the EEPROM. Right now only the EEPROM currently works and thus we will be writing a program assuming we are writing to the EEPROM.
For every version of the decoder, there will be the necessary configuration files in the decoder directory. There you will find in ca65 directory a MemoryMap.cfg which tells ld65 where all the sections of memory are(you can learn more [here](https://www.cc65.org/doc/ld65-5.html) and the programmer's quick reference will have memory locations). There is also a pad.sh file that will be used later.
Once there, make a program file that ends with a .asm(you can use any random file extension but .asm is the norm in this project) and open it with your favorite code editor.
I will not tell you how to write assembly as you can [just go here](http://www.6502.org/tutorials/65c02opcodes.html) but I will tell you what you need for this computer.
If you use the MemoryMap.cfg that I provide which I recommend for beginners then you will need some certain things in your code namely:
~~~(65C02 asm)
.segment "VECTORS"
		.word	$<NMIB>
		.word	$<RESET VECTOR>
		.word	$<IRQB>
~~~
This goes at the end of your program and tells ld65 where three vectors are. I will give a brief explanation of these vectors descending by importance.
* **The Reset Vector**(pin 40) tells the CPU where to go to start program execution after the CPU is told to reset by a low signal to pin 40 after 7 clock cycles. For this computer this is always at the start of ROM(for the v1.1 decoder that address happens to be $C180).
* **IRQB**(interrupt request, pin 4) This is where the CPU goes whenever an interrupt request is submitted (as long as interrupts weren't blocked by the opcode SEI). Interrupts come in from other parts of the computer(like the serial port ship also known as the UART) by a low signal input to pin 4 and the interrupt stays low until properly handled. Thus, any code running after an interrupt should be designed to resolve these interrupts. For example: The UART triggers an interrupt because the UART has received data. The code at the IRQB vector then takes the data from the UART and tells the UART that the data has been acquired, and thus the UART stops triggering an interrupt thus handling the interrupt. When making code for handling interrupts it is important to know that all of the other parts of the computer share the same IRQB line. This means when the CPU sees an interrupt the CPU does not know from where it is coming from thus you need to write your IRQB handler to deal with this.
* **NMBI**(None Maskable Interrupt) This is where the CPU goes after receiving an NMBI. This is very similar to IRQB but it can't be blocked by the opcode SEI and the signal is different. IRQB holds the interrupt signal until the interrupt is handled. NMBI sends a single interrupt signal then stops. NMBI is a VERY powerful feature and thus is dangerous. It will interrupt anything at any moment. Thus a time sensitive operation can be completely ruined by this interrupt. Plan accordingly. Fortunately for you the computer does not have the NMBI functional (yet). An example where this feature would be very useful is power lose protection. A sensor in the power supply detects either a power spike or power loss. This interrupts the CPU through NMBI thus ignoring any current operations. The code at the NMBI is made as an emergency shutdown (i.e dumping RAM to storage) before the computer runs out of power (obviously this would require a power supply specially designed for this but this is only an example).
* To know more, look at page nine [here](https://www.westerndesigncenter.com/wdc/documentation/w65c02s.pdf).
  
#### C

Not implemented yet.

### Installing Programs

#### Writing to the EEPROM

~~~bash
minipro -p 28c256 -uP -w FILE_NAME
~~~

#### Writing to the Micro SD Card

Not implemented yet.
