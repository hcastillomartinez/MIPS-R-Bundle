# MIPS-R-Bundle
Interpreter for MIPS R instruction format written in Java. Assembler also written in Java that also can be used to test the VHDL designed CPU as it sets the registers. Use the assembler to test the CPU as it also gives you the machine code of instructions.

## Objective
### CPU
The objective is to design and implement a single cycle MIPS computer in Verilog that supports MIPS assembly instructions including:
+ Memory-reference instructions load word **lw** and store word **sw**
+ Arithmetic-logical instructions **add**, **addi**, **sub**, **and**, **andi**, **or**, and **slt**
+ Jumping instructions branch-equal **beq** and jump **j**

### Assembler
The assembler was designed to be used with the CPU in that you can write your own MIPS instructions and get the machine code
to send to the CPU.
### Interpreter
The interpreter had a similar goal except it was to test ones MIPS code and see if it was functional or not.

## Design
The design I followed was this one when creating this project


![alt text](https://camo.githubusercontent.com/4c37ba0b946714e03da07c7c1a75939e1070120c/68747470733a2f2f756e646572677261642e6878696e672e6d652f56453337302f53696e676c652b4379636c652b536368656d61746963732e706e673f782d736f757263653d676974687562 "Design Choice")

