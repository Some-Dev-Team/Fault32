---
icon: table
---

# F32-ASM Primitive

## Instructions

***

### Memory

<table><thead><tr><th width="152.20001220703125" align="center">Operation Name</th><th>Arguments</th><th>Description</th></tr></thead><tbody><tr><td align="center">lb</td><td><code>rd</code>, <code>imm(rs1)</code></td><td>Load signed byte at memory address <code>rs1 + imm</code> into <code>rd</code>. Sign-extends to 32bit.</td></tr><tr><td align="center">lbu</td><td><code>rd</code>, <code>imm(rs1)</code></td><td>Load unsigned byte at memory address <code>rs1 + imm</code> into <code>rd.</code> Zero-extends to 32bit.</td></tr><tr><td align="center">lh</td><td><code>rd</code>, <code>imm(rs1)</code></td><td>Load signed halfword at memory address <code>rs1 + imm</code> into <code>rd</code>. Sign-extends to 32bit.</td></tr><tr><td align="center">lhu</td><td><code>rd</code>, <code>imm(rs1)</code></td><td>Load unsigned halfword at memory address <code>rs1 + imm</code> into <code>rd</code>. Zero-extends to 32bit.</td></tr><tr><td align="center">lw</td><td><code>rd</code>, <code>imm(rs1)</code></td><td>Load word from memory into <code>rd</code>. </td></tr><tr><td align="center">sb</td><td><code>rs2</code>, <code>imm(rs1)</code></td><td>Store byte from <code>rs2</code> into memory at <code>rs1 + imm</code></td></tr><tr><td align="center">sh</td><td><code>rs2</code>, <code>imm(rs1)</code></td><td>Store halfword from <code>rs2</code> into memory at <code>rs1 + imm</code></td></tr><tr><td align="center">sw</td><td><code>rs2</code>, <code>imm(rs1)</code></td><td>Store word from <code>rs2</code> into memory at <code>rs1 + imm</code></td></tr></tbody></table>

{% hint style="info" %}
`imm(rs1)`  means it will add value of `rs1` to provided immidiate and use the result as address.
{% endhint %}

***

### Airthmetic

#### Register-Register

<table><thead><tr><th width="152.20001220703125" align="center">Operation Name</th><th width="297.888916015625">Arguments</th><th>Description</th></tr></thead><tbody><tr><td align="center">add</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Add <code>rs1 + rs2</code> , store in <code>rd</code>. Signed.</td></tr><tr><td align="center">sub</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Subtract <code>rs1 - rs2</code> , store in <code>rd</code>. Signed.</td></tr><tr><td align="center">and</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Bitwise AND of <code>rs1</code> and <code>rs2</code> into <code>rd</code>.</td></tr><tr><td align="center">or</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Bitwise OR of <code>rs1</code> and <code>rs2</code> into <code>rd</code>.</td></tr><tr><td align="center">xor</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Bitwise XOR of <code>rs1</code> and <code>rs2</code> into <code>rd</code>.</td></tr><tr><td align="center">sll</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Logical left shift <code>rs1</code> by amount in lower 5 bits of <code>rs2</code>, store in <code>rd</code>.</td></tr><tr><td align="center">srl</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Logical right shift <code>rs1</code> by amount in lower 5 bits of <code>rs2</code>, store in <code>rd</code>.</td></tr><tr><td align="center">sra</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Arithmetic (signed) right shift <code>rs1</code> by amount in <code>rs2</code>, store in <code>rd</code>.</td></tr><tr><td align="center">slt</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Set <code>rd = 1</code> if <code>rs1 &#x3C; rs2</code> (signed), else 0.</td></tr><tr><td align="center">sltu</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Set <code>rd = 1</code> if <code>rs1 &#x3C; rs2</code> (unsigned), else 0.</td></tr><tr><td align="center">mul</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Multiply rs1 and rs2, then store result in rd.  (unsigned)</td></tr><tr><td align="center">div</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Divide rs1 and rs2, then store result in rd. (unsigned)</td></tr><tr><td align="center">rem</td><td><code>rd</code>, <code>rs1</code>, <code>rs2</code></td><td>Calculate remainder for rs1 and rs2, then store result in rd.</td></tr></tbody></table>

#### Immidiate

<table><thead><tr><th width="152.20001220703125" align="center">Operation Name</th><th>Arguments</th><th>Description</th></tr></thead><tbody><tr><td align="center">addi</td><td><code>rd</code>, <code>rs1</code>, <code>imm</code></td><td>Add immediate: <code>rd = rs1 + imm</code>. Signed.</td></tr><tr><td align="center">andi</td><td><code>rd</code>, <code>rs1</code>, <code>imm</code></td><td>Bitwise AND of <code>rs1</code> and <code>imm</code> into <code>rd</code>.</td></tr><tr><td align="center">ori</td><td><code>rd</code>, <code>rs1</code>, <code>imm</code></td><td>Bitwise OR of <code>rs1</code> and <code>imm</code> into <code>rd</code>.</td></tr><tr><td align="center">xori</td><td><code>rd</code>, <code>rs1</code>, <code>imm</code></td><td>Bitwise XOR of <code>rs1</code> and <code>imm</code> into <code>rd</code>.</td></tr><tr><td align="center">slli</td><td><code>rd</code>, <code>rs1</code>, <code>shamt</code></td><td>Logical left shift <code>rs1</code> by immediate <code>shamt</code> (0–31), store in <code>rd</code>.</td></tr><tr><td align="center">srli</td><td><code>rd</code>, <code>rs1</code>, <code>shamt</code></td><td>Logical right shift <code>rs1</code> by immediate, store in <code>rd</code>.</td></tr><tr><td align="center">srai</td><td><code>rd</code>, <code>rs1</code>, <code>shamt</code></td><td>Arithmetic right shift <code>rs1</code> by immediate, store in <code>rd</code>.</td></tr><tr><td align="center">slti</td><td><code>rd</code>, <code>rs1</code>, <code>imm</code></td><td>Set <code>rd = 1</code> if <code>rs1 &#x3C; imm</code> (signed), else 0.</td></tr><tr><td align="center">sltui</td><td><code>rd</code>, <code>rs1</code>, <code>imm</code></td><td>Set <code>rd = 1</code> if <code>rs1 &#x3C; imm</code> (unsigned), else 0.</td></tr><tr><td align="center">lui</td><td><code>rd</code>, <code>imm</code></td><td>Loads a 20-bit immediate value into the upper 20 bits of <code>rd</code>.<br>The lower 12 bits of the register are set to zero.</td></tr><tr><td align="center">auipc</td><td><code>rd</code>, <code>imm</code></td><td>Adds a 20-bit immediate value (shifted left by 12 bits) to the current program counter value (PC) and writes the result into <code>rd</code>.</td></tr></tbody></table>



***

### Branching

<table><thead><tr><th width="152.20001220703125" align="center">Operation Name</th><th>Arguments</th><th>Description</th></tr></thead><tbody><tr><td align="center">beq</td><td><code>rs1</code>, <code>rs2</code>, <code>label</code></td><td>Branch if equal: jump to <code>label</code> if <code>rs1 == rs2</code>.</td></tr><tr><td align="center">bne</td><td><code>rs1</code>, <code>rs2</code>, <code>label</code></td><td>Branch if not equal.</td></tr><tr><td align="center">blt</td><td><code>rs1</code>, <code>rs2</code>, <code>label</code></td><td>Branch if less than (signed).</td></tr><tr><td align="center">bge</td><td><code>rs1</code>, <code>rs2</code>, <code>label</code></td><td>Branch if greater/equal (signed).</td></tr><tr><td align="center">bltu</td><td><code>rs1</code>, <code>rs2</code>, <code>label</code></td><td>Branch if less than (unsigned).</td></tr><tr><td align="center">bgeu</td><td><code>rs1</code>, <code>rs2</code>, <code>label</code></td><td>Branch if greater/equal (unsigned).</td></tr></tbody></table>

***

### Unconditional / Calls

<table><thead><tr><th width="152.20001220703125" align="center">Operation Name</th><th>Arguments</th><th>Description</th></tr></thead><tbody><tr><td align="center">jal</td><td><code>rd</code>, <code>label</code></td><td>Jump and link: set <code>rd = PC + 4</code>, jump to <code>label</code>.</td></tr><tr><td align="center">jalr</td><td><code>rd</code>, <code>rs1</code>, <code>label</code></td><td>Jump to address <code>rs1 + imm</code> , store return address in <code>rd</code>.</td></tr></tbody></table>

***

### Other

<table><thead><tr><th width="152.20001220703125" align="center">Operation Name</th><th align="center">Arguments</th><th>Description</th></tr></thead><tbody><tr><td align="center">nop</td><td align="center">-</td><td>No operation. CPU does nothing for one cycle.</td></tr><tr><td align="center">ecall</td><td align="center">-</td><td>Environment/system call. Triggers OS/exception handler.</td></tr><tr><td align="center">ebreak</td><td align="center">-</td><td>Breakpoint.</td></tr></tbody></table>

***

## Language Features

_(coming soon)_

### Syntax

### Labels

### Sections

### Data definitions

### Constants / Symbols

### Expressions

