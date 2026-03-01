---
description: Wiki
icon: file-lines
---

# F32-ASM Instruction Types

This page describes what instruction types [Broken link](/broken/pages/bYd0rCj72zWulnWs2jaN "mention") has and how they are mapped in 32bit word. This page is made to provide better understanding about how is F32-ASM code is represented and converted into binary.

## R-Type (Register-Register)

Usually used for arithmetic or logical operations that _only_ involve registers.

Binary format:

| Bit ranges | Field  | Description                         |
| ---------- | ------ | ----------------------------------- |
| 0-6        | opcode | Operation code (instruction class)  |
| 7-11       | rd     | Destination register                |
| 14-12      | funct3 | Operation subtype                   |
| 15-19      | rs1    | Source register 1                   |
| 20-24      | rs2    | Source register 2                   |
| 25-31      | funct7 | Type of the operation (ADD vs SUB)  |

{% hint style="info" %}
`funct3` and `funct7` are describing fields of the instruction. They name allso carries information about how long the field is. funct3 is 3 bits long and funct7 is 7 bits long. \
\
Those "`funct`" fields are usually used for distinguishing instruction subtypes like ADD/SUB, LB(Load Byte)/ LH(Load Halfword), etc. That have same category but slightly different functionality.
{% endhint %}

***

## I-Type (Immediate)

Instructions with a _small constant_ (immediate), and one or two registers.

| Bit ranges | Field      | Description                        |
| ---------- | ---------- | ---------------------------------- |
| 0-6        | opcode     | Operation code (instruction class) |
| 7-11       | rd         | Destination register               |
| 14-12      | funct3     | Operation subtype                  |
| 15-19      | rs1        | Source register 1                  |
| 20-31      | imm\[0:11] | 12 bit immediate signed value      |

{% hint style="info" %}
Immidiate value is a constant value that you put in assembly operation. (instead of referencing register or memory address we just put hardcoded data inside). The immidiate value is broken down into multiple pieces when converted to a binary representation of instruction. Here we use format:

```
imm[ start : end ]
```

Which represents ranges of immidiate binary value pieces. For instance if we have 8bit immidiate value: `11000011` (where right-most bit is LSB) and we want to index first half of the value we would write it as: `imm[0:3]`<br>

"Breaking Into Pieces" is made to preserve places of some other fields like: `funct3` (almost always aat 12-14 range), `rs1`, `rs2`, etc. To keep them constant. CPU later reconstructs the immidiate value once the format of the instruction is discovered.
{% endhint %}

***

## S-Type (Store)

Store instructions that write register values into memory.

| Bit ranges | Field      | Description                        |
| ---------- | ---------- | ---------------------------------- |
| 0-6        | opcode     | Operation code (instruction class) |
| 7-11       | imm\[0:4]  | Lower bits of 12-bit immediate     |
| 14-12      | funct3     | Operation subtype                  |
| 15-19      | rs1        | Source register 1                  |
| 20-24      | rs2        | Source register 2                  |
| 25-31      | imm\[11:5] | Upper bits of 12-bit immediate     |

***

## B-Type (Branch)

Instructions with a _large immediate_, typically 20 bits.

| Bit ranges | Field      | Description                        |
| ---------- | ---------- | ---------------------------------- |
| 0-6        | opcode     | Operation code (instruction class) |
| 10–7       | imm\[8:11] | Part of branch offset              |
| 11         | imm\[4]    | Part of branch offset              |
| 12-14      | funct3     | Branch type                        |
| 15-19      | rs1        | Source register 1                  |
| 20-24      | rs2        | Source register 2                  |
| 25-30      | imm\[5:10] | imm\[10:5]                         |
| 31         | imm\[12]   | Sign bit                           |

***

## U-Type (Upper Immediate)

Instructions with a _large immediate_, typically 20 bits.

| Bit ranges | Field       | Description                        |
| ---------- | ----------- | ---------------------------------- |
| 0-6        | opcode      | Operation code (instruction class) |
| 7-11       | rd          | Destination Register               |
| 12-31      | imm\[12:31] | 20-bit immediate                   |

***

## J-Type (Jump)

Unconditional jumps with link.

| Bit ranges | Field       | Description                        |
| ---------- | ----------- | ---------------------------------- |
| 0-6        | opcode      | Operation code (instruction class) |
| 7-11       | rd          | Destination register               |
| 12–19      | imm\[12:19] | part of the immediate              |
| 20         | imm\[11]    | part of the immediate              |
| 21-30      | imm\[1:10]  | part of the immediate              |
| 31         | imm\[20]    | part of the immediate              |

***

## OPCODES

| Instruction Class | Opcode (binary) |
| ----------------- | :-------------: |
| LOAD              |     0000011     |
| STORE             |     0100011     |
| OP (R-Type ALU)   |     0110011     |
| OP-IMM            |     0010011     |
| LUI Instruction   |     0110111     |
| AUIPC Instruction |     0010111     |
| BRANCH            |     1100011     |
| JAL               |     1101111     |
| JALR              |     1100111     |
| SYSTEM            |     1110011     |
