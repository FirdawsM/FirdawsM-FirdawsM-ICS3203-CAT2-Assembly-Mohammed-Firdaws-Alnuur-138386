# FirdawsM-FirdawsM-ICS3203-CAT2-Assembly-Mohammed-Firdaws-Alnuur-138386
This repository contains four practical assembly programming tasks for the ICS3203 CAT 2 assignment. Each program demonstrates specific skills in assembly language, including control flow, array manipulation, modular programming, and hardware simulation.

## Task 1: Control Flow and Conditional Logic
### Purpose: 
This program prompts the user for a number and classifies it as either "POSITIVE", "NEGATIVE", or "ZERO" using conditional and unconditional jumps in assembly language.
### Challenges: 
Ensuring the correct use of jump instructions (conditional and unconditional) to handle branching logic.

## Task 2: Array Manipulation with Looping and Reversal
- **Purpose**:
This program accepts an array of integers, reverses the array in place using loops, and outputs the reversed array.
- **Challenges**:
Handling memory directly for array reversal without using extra storage.
Ensuring correct loop and memory management in assembly, especially with 64-bit addressing.

## Task 3: Modular Program with Subroutines for Factorial Calculation
- **Purpose**: 
This program calculates the factorial of a number using a subroutine and the stack to preserve register values.
- **Challenges**:
Managing the stack correctly for preserving values across function calls.
Handling larger numbers and ensuring the result is properly stored and printed.

## Task 4: Data Monitoring and Control Using Port-Based Simulation
- **Purpose**:
Simulates a control system that reads a sensor value and performs actions such as turning on a motor or triggering an alarm based on the sensor value.
- **Challenges**:
- Simulating control systems using assembly and manipulating memory or ports to simulate motor control and alarm triggering.
- Ensuring the output is formatted correctly (e.g., printing sensor values and motor/alarm states).
- WSL Compatibility: An issue arose when running ELF binaries in WSL. The executable produced a "cannot execute binary file: Exec format error" due to WSL 1’s limitations with ELF binaries. This required upgrading to WSL 2 to enable compatibility with ELF files.

## Compilation and Execution
- **Prerequisites**: Install [NASM](https://www.nasm.us/) or another assembler.
### Compiling and Running the Code

To compile and run the programs, follow these steps:

1. **Assemble the Code**:
  
   nasm -f elf64 -o taskX.o taskX.asm

   Replace taskX.asm with the appropriate file 

   for each task (task1.asm, task2.asm, task3.asm, task4.asm )

- **Link the Object File**:

ld -no-pie -o taskX taskX.o

-**Make the Binary Executable**:

chmod +x taskX

-**Run the Program**:

./taskX

This will execute the program, and you can provide the necessary input as prompted by the program.
## Insights and Challenges
**Challenges Faced:**
- **Task 1**: 
Handling Memory in Assembly:

A key challenge across all tasks was dealing with memory directly in assembly, especially for tasks like reversing an array or handling large numbers (like calculating factorials). This required a deep understanding of memory addressing and register management.
Assembly Looping:

- **Task 2**: (array reversal) required using loops to manipulate the array in place. This posed challenges with managing the array’s indices and ensuring correct pointer increments and decrements during the reversal process.

- **Task 3**: involved calculating the factorial using subroutines. Managing the stack correctly to preserve registers between function calls was crucial. Failure to manage this properly could lead to incorrect results or crashes.

- **Task 4:** 

- WSL Compatibility Issues:

WSL 1 does not support running ELF binaries natively, resulting in the "Exec format error" when trying to execute the binary. After upgrading to WSL 2, which fully supports ELF binaries, the issue was resolved. This was an important lesson about platform compatibility when working with low-level languages like assembly.

- Correctly Printing Output:

A recurring challenge was ensuring that the output was printed correctly, especially for sensor values and control statuses (e.g., motor or alarm states). The print_hex and print_newline functions had to be adjusted to ensure proper formatting and clarity in the output.
Subroutine Management 
