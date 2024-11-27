# Assembly Language Programs
## Instructions for Compiling and Running
### Prerequisites
1. **Assembler** - NASM (Netwide Assembler) for compiling assembly code.
2. **Linker** - LD (GNU linker) for linking object files to create the executable
### Compilation and Execution:
1. **Install Necessary Tools**
```bash
sudo apt update
sudo apt install nasm      
sudo apt install binutils  
sudo apt install gcc       
```
2. **Compile the Assembly Code** 
```bash
nasm -f elf32 -o output_file.o input_file.asm
```
- **input_file.asm** - Replace with the name of your assembly source file.
- **output_file.o** - Replace with the desired name of the object file.
- **-f elf32** - Specifies the output format (32-bit ELF format).
3. **Link the Object File**
```bash
ld -m elf_i386 -o output_program output_file.o
```
- **output_program** -  Replace with the desired name for your final executable.
- **output_file.o** - Replace with the name of the object file created earlier.
- **-m elf_i386** - Specifies that the program is for 32-bit ELF architecture.
4. **Run the Program**
```bash
./output_program
```
- **output_program** - Replace with the name of the executable you created in step 3.
## 1. Control Flow and Conditional Logic
### Overview
This program is designed to prompt the user to input a number and classify it as either "POSITIVE", "NEGATIVE", or "ZERO" based on the entered value. The program makes use of assembly language concepts such as conditional and unconditional jumps to handle the different cases effectively.

### Program Breakdown
- **Input Prompt** - The program prompts the user to enter a number.

- **Branching Logic** - The program uses conditional jumps to check if the number is positive, negative or zero.

- **Classification** - Based on the comparison results, the program prints an appropriate message:

1. "The number is POSITIVE."

2. "The number is NEGATIVE."

3. "The number is ZERO."

### Insights and Challenges
#### Key Concepts:
1. **Jump Instructions**

- **Conditional Jumps** - The program uses je (jump if equal) for checking if the number is zero, and jg (jump if greater) to check if the number is positive. These conditional jumps help in determining the program flow based on the comparison results.
- **Unconditional Jumps** - The program uses unconditional jmp to transition between different stages (e.g., from the positive case to exit).
2. **System Calls** - The program interacts with the operating system using syscalls for reading input, writing output, and exiting the program. These are low-level operations typical in assembly programming.

#### Challenges:
- **Handling Input** - Reading and processing user input in assembly can be tricky. We used the read syscall to read user input, then manually handled newline removal and conversion from ASCII to integers.
- **Branching Logic** - Ensuring that the correct jump is taken for each condition requires careful use of comparison instructions and jump operations. Using both conditional and unconditional jumps allows for more flexible control flow.
### Why Jump Instructions Were Chosen:
1. **Conditional Jumps** - The conditional jumps (je, jg) are necessary for branching the program based on the comparison between the input number and zero. This allows the program to respond to different cases (positive, negative, or zero) without excessive use of if-else structures.
2. **Unconditional Jumps** - The unconditional jmp is used to exit the program or skip unnecessary code after a message is displayed. It ensures smooth program flow without unnecessary checks.

## 2. Array Manipulation with Looping and Reversal
## Overview
This assembly program accepts 5 integers from the user, reverses the array in place using loops, and prints the reversed array without using additional memory.
## Code Breakdown
- **Input Handling** - Prompts the user for 5 space-separated integers and stores them in an array.
- **Array Reversal** - Uses a loop to swap the first and last elements, progressively moving inward to reverse the array in place.
- **Output** - The reversed array is printed by converting integers to strings and outputting them one by one.

## Challenges
- **Memory Handling** - Reversing the array in place required direct memory manipulation, which posed challenges in managing memory and pointers.

- **Input Parsing** - Converting space-separated characters to integers involved handling ASCII values manually.

- **Printing Output** - Converting integers to strings for output was tricky and required handling division and remainder for digit extraction.

## Key Concepts
- **In-place Reversal** - Reversing the array without extra memory allocation.
- **System Calls** - Using Linux system calls for input and output operations.

## 3. Factorial Calculation Program

## Overview
This assembly program calculates the factorial of a number (6) using a subroutine. It preserves register values using the stack and outputs the result as a string.
## Code Breakdown
1. **Factorial Calculation** - calculates 6! using a loop in the factorial subroutine and stores the result in eax.
2. **Register Preservation** - registers are saved and restored using the stack to avoid overwriting values during the calculation.
3. **String Conversion** - result in eax is converted to a string and displayed using sys_write.
4. **Stack Management** - registers are pushed to and popped from the stack within the subroutine to preserve their values.
## Key Concepts
1. **Modular Programming** - Factorial calculation is done in a subroutine.
2. **Stack Handling** - Registers are saved and restored using the stack.
3. **System Calls** - Uses Linux system calls (sys_write, sys_exit) for output and program exit.
## Challenges
- **Stack Management** - Ensuring registers are properly preserved using the stack.
- **Number Conversion** - Converting the result to a string involved handling division and modulus operations.

## 4. Data Monitoring and Control

### Overview
This program simulates a control system based on a water level sensor. The program reads a sensor value and performs actions like turning on/off a motor and triggering an alarm based on the water level.

### Key Actions
1. **Motor**
- Turns ON if water level < 30.
- Turns OFF if water level is between 30 and 75, or >= 75.
2. **Alarm**
- Turns ON if water level >= 75.
- Turns OFF if water level is < 75.
### Code Functions
1. **Sensor Value** - A value (e.g., 80) is stored and read to simulate the sensor.

2. **Subroutines** - Control the motor and alarm, printing corresponding messages ("Motor is ON", "Alarm is OFF", etc.).
   
3. **Exit** - The program terminates after executing the actions.
### Example Outputs:
- High water level (80) - Motor OFF, Alarm ON.
- Moderate water level (50) - Motor OFF, Alarm OFF.
- Low water level (20) - Motor ON, Alarm OFF.

### Stack and Memory Manipulation
Registers and memory locations are used to simulate motor and alarm control actions based on sensor input. Each sensor reading triggers a corresponding system state.

### Challenges
1. **Memory Manipulation** - Managing how values are stored and used to control system behavior.
2. **Action Decision Making** - Accurately determining the appropriate action (motor/alarm) based on the sensor's value.



