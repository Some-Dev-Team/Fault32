---
description: Module
icon: file-code
layout:
  width: default
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
  metadata:
    visible: true
  tags:
    visible: true
---

# Utils

## Dependencies

* Roblox's [HttpService](https://create.roblox.com/docs/reference/engine/classes/HttpService)

## What is this module for?

Provide reusable utility code.

This module contains general-purpose helper functions used across systems, including unique ID generation and bit-level conversions.

## Functions

***

### GenerateUniqueID

```luau
Utils.GenerateUniqueID(): string
```

Parameters: -

Returns:

* `id` -  a string value that contains unique ID.

**Description:**\
Generates unique ID, usually used for for debugging or identifying devices/objects within complex systems.

Example of usage:

```luau
local uniqueID = Utils.GenerateUniqueID()
```

***

### BitsToDecimal

```luau
Utils.BitsToDecimal(bitTable: { number }): number
```

**Parameters:**&#x20;

* `bitTable` - a value that contains table of numbers (1s or 0s) that represent bits. Where first element of the table is least significant bit.

**Returns:**

* `result` - a number

**Description:**\
Converts a table of numbers that represent bits to a single decimal number.&#x20;

**Example of usage:**

{% hint style="info" %}
Bits should be stored stored LSB-first (index 1 in the table is the least significant bit).
{% endhint %}

```luau
local myDecimal = Utils.BitsToDecimal({1, 1, 0, 0}) -- this will return 3 (0011 = 3)
```

***

### DecimalToBits

```luau
Utils.DecimalToBits(
    num: number, 
    bitCount: number?, 
    tbl: { number }?
): { number }
```

**Parameters:**&#x20;

* `num` - a number value that will be converted to bits.
* `bitCount` - _\[optional]_ count of bits that resulting table should contain.
* `tbl` - _\[optional]_ a reference to another table that result will be written to.

**Returns:**

* `result` - a table of numbers (0s or 1s) that represent bits.

**Description:**\
Converts a single decimal number to a table of numbers that represent bits. If `bitCount` provided it will contain exactly same number of bits in resulting table. If `tbl`  reference is provided it will modify its values with result of the conversion.&#x20;

{% hint style="info" %}
Bits are stored stored LSB-first (index 1 in the resulting table is the least significant bit).
{% endhint %}

**Notes**

* `bitCount` is optional and auto-calculated if omitted.
* If `bitCount` is smaller than required, it will be overridden to the minimum.
* If `tbl` is provided, its length must match `bitCount` (or minimum bit count needed to store the `num` if `bitCount` is set to `nil`), otherwise an error is thrown.
*   Here is how minimum amount of bits needed is calculated:&#x20;

    ```luau
    math.floor(math.log(num, 2)) + 1
    ```



**Examples of usage:**

```luau
-- Automatic bit count

local bits = Utils.DecimalToBits(13)

-- 13 in binary is 1101
-- bits = {1, 0, 1, 1}

print(table.concat(bits, ", "))
```

```luau
-- Explicit bitCount

local bits = Utils.DecimalToBits(5, 8)

-- 5 in binary is 101
-- bits = {1, 0, 1, 0, 0, 0, 0, 0}

print(table.concat(bits, ", "))
```

```luau
-- Reusing an existing table

local buffer = table.create(8, 0)

Utils.DecimalToBits(10, 8, buffer)

-- 10 in binary is 1010
-- buffer = {0, 1, 0, 1, 0, 0, 0, 0}

print(table.concat(buffer, ", "))
```
