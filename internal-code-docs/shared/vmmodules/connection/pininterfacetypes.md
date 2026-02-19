---
description: Module
icon: file-code
---

# PinInterfaceTypes

### Dependencies

* `VMModules.Connection.Pin` — Used for `PinMode` definitions.

### What is this module for?

Defines constants, enums, and type descriptors for `PinInterface` systems. Used to describe the structure of pin interfaces, group variants, and allowed directions. This module does **not handle runtime logic**, only provides type metadata.

***

### Properties

#### PinInterfaceTypes.Variants

* **Type:** `{ Single = 0, Group = 1 }`
* **Description:**\
  Defines whether a pin set represents a single pin or a group of pins (bus).

**Example:**

```luau
print(PinInterfaceTypes.Variants.Single) -- 0
print(PinInterfaceTypes.Variants.Group)  -- 1
```

#### PinInterfaceTypes.InterfaceDirections

* **Type:** `{ Input = 0, Output = 1 }`
* **Description:**\
  Represents the canonical direction of the interface. Used to determine which side drives signals.

**Example:**

```luau
print(PinInterfaceTypes.InterfaceDirections.Input)  -- 0
print(PinInterfaceTypes.InterfaceDirections.Output) -- 1
```

***

### Types

#### GroupVariant

* **Type:** `PinInterfaceTypes.Variants.Group`
* **Description:** Marks a pin set as a group (bus).

#### SingleVariant

* **Type:** `PinInterfaceTypes.Variants.Single`
* **Description:** Marks a pin set as a single pin.

#### InterfaceDirection

* **Type:** `PinInterfaceTypes.InterfaceDirections.Input | PinInterfaceTypes.InterfaceDirections.Output`
* **Description:** Defines whether the interface is driving signals out (`Output`) or receiving signals (`Input`).

#### PinDesc

* **Fields:**
  * `Variant: SingleVariant` — Must be a single pin.
  * `Mode: Pin.PinMode` — Input, Output, or Bidirectional mode.

#### PinGroupDesc

* **Fields:**
  * `Variant: GroupVariant` — Must be a group of pins.
  * `Pins: { [number]: PinDesc }` — Array describing individual pins.
  * `AllowVariableCount: boolean` — Whether other interfaces can connect with different sizes.
  * `AllowBiggerBus: boolean` — Whether smaller arrays can connect to larger buses.

#### PinInterfaceDesc

* **Fields:**
  * `PinSets: { [string]: PinDesc | PinGroupDesc }` — Named sets of pins, e.g., `ADDR`, `DATA`.
  * `FlipOnOpposite: boolean` — Whether input/output flips when connected to an interface in opposite direction.
  * `CanonicalDirection: InterfaceDirection` — Original interface direction.

#### GroupMask

* **Fields:**
  * `[string]: { Count: number, OverrideMode: Pin.PinMode }` — Used to resize or override types of pin groups when generating pins from description.
