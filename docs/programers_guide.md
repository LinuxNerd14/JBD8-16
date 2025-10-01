# Programing Refrence Guide for the JBD8-16 Computer

## Table of Contents:

1. Introduction

2. System Overview

3. Programing Model

4. How to write and run programs

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

## 3: Programing Model

- **Registers**: List CPU registers, their purpose, and usage.

- **Instruction set**: If standard (like 6502), link to an existing reference; if custom/modified, document only your additions.

- **Interrupts/Resets**: Document how the reset vector works, how interrupts are triggered, and where the programmer should put their code.

- **Stack and calling conventions**: If you want to define how subroutines should pass arguments/return values, write that down.

## 4: How to write and run programs

- **Assembler/Compiler**: What toolchain should the programmer use (e.g., ca65, custom assembler)?

- **Workflow**: How to write code, assemble it, and load it onto your machine (ROM flashing, serial upload, etc.).

- **Hello World**: A minimal working program that prints something, blinks an LED, or shows output on your system.








