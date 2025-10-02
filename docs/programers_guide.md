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
minipro -p 28c256 -up -w FILE_NAME

#### Overview

This computer can be programmed in straight up in 65C02 assembly or C using cc65. The opcodes for assembly can be found in the documentation for the CPU [here](https://www.westerndesigncenter.com/wdc/documentation/w65c02s.pdf) or you can [also go here]([6502.org Tutorials: 65C02 Opcodes](http://www.6502.org/tutorials/65c02opcodes.html)) for a more human-readable explanation and description of 65C02 assembly. Programming in C is not implemented yet but will be soon. The "programs" directory is organized by memory decoder version since differences in it fundamentally change the programming of the computer. As of now the latest is V1.1 but use whatever is appropriate for your hardware.

### Making Programs

##### 65C02 Assembly

Writing code is a three-step process. In order: writing the program; compiling the program; padding the program. After these steps are completed, you should hopefully have a valid binary file that you can write to either the EPROM or a micro SD card. 
The compiler of choice is [ca65](https://cc65.github.io/doc/ca65.html) and its sibling ld65. ca65 compiles the program and ld65 links it and thus produces a 

#### C

    Not implemented yet.

### Installing Programs

#### Writing to the EPROM

##### Writing to the Micro SD Card

    Not implemented yet.
