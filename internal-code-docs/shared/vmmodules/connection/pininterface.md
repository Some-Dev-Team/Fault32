---
description: Object
icon: brackets-curly
---

# PinInterface

### Dependencies

* [pin.md](pin.md "mention")
* [wire.md](wire.md "mention")
* [pininterfacetypes.md](pininterfacetypes.md "mention")

### What is this module for?

Represents a **runtime pin interface**. Combines multiple pins into logical sets (single or groups) and allows connecting them to other interfaces with automatic wire creation. Handles pin mode flipping for opposite directions and group masking for variable bus sizes.

***

### Properties

#### PinInterface.Description

* **Type:** [`PinInterfaceTypes.PinInterfaceDesc`](pininterfacetypes.md#pininterfacedesc)&#x20;
* **Description:** Original interface description containing pin sets, canonical direction, and flip rules.

#### PinInterface.RuntimeDirection

* **Type:** [`PinInterfaceTypes.InterfaceDirection`](pininterfacetypes.md#interfacedirection)&#x20;
* **Description:** Current runtime direction of the interface (Input or Output). Determines how pins are resolved and connected.

#### PinInterface.PinReferences

* **Type:** `{ [string]: Pin | { Pins: {Pin}, RegisterList: {number} } }`
* **Description:** References to the actual pin objects created for this interface. Groups contain arrays of pins and their registers.

#### PinInterface.Wires

* **Type:** `{Wire}`
* **Description:** List of [`Wire`](wire.md) objects created when connecting this interface to another interface.

***

### Functions

#### PinInterface.new

```luau
PinInterface.new(
    description: PinInterfaceTypes.PinInterfaceDesc,
    PinReferences: table,
    direction: PinInterfaceTypes.InterfaceDirection
): PinInterface
```

**Parameters:**

* `description` — Interface metadata describing pin sets.
* `PinReferences` — Table of actual pin objects corresponding to `PinSets`.
* `direction` — Runtime direction of this interface (Input or Output).

**Returns:**

* `PinInterface` — New interface object with pins validated and ready to connect.

**Description:**\
Creates a new runtime interface. Validates all pin sets and ensures pin modes match the description (including flips for opposite direction).

**Example:**

```luau
local myInterface = PinInterface.new(desc, pins, PinInterfaceTypes.InterfaceDirections.Output)
```

***

#### PinInterface.CreatePinsFromDescription

```luau
PinInterface.CreatePinsFromDescription(
    description: PinInterfaceTypes.PinInterfaceDesc,
    direction: PinInterfaceTypes.InterfaceDirection,
    mask: PinInterfaceTypes.GroupMask?
): table
```

**Parameters:**

* `description` — Interface metadata.
* `direction` — Runtime direction of interface.
* `mask` — Optional group mask for resizing or overriding pin types.

**Returns:**

* `pins` — Table of newly created pins, matching the structure of the description. Groups contain `Pins` array and `RegisterList`.

**Description:**\
Generates pins for all sets in the description. Automatically handles mode flipping and optional mask application for variable groups.

**Example:**

```luau
local pins = PinInterface.CreatePinsFromDescription(desc, PinInterfaceTypes.InterfaceDirections.Input)
```

***

#### PinInterface:ConnectToInterface

```luau
pinInterface:ConnectToInterface(otherInterface: PinInterface): {Wire}
```

**Parameters:**

* `otherInterface` — Interface to connect to. Must have opposite `RuntimeDirection`.

**Returns:**

* `{Wire}` — List of `Wire` objects connecting pins between interfaces.

**Description:**\
Automatically connects all matching pin sets between two interfaces. Handles single pins and groups, creating multiple wires for pin groups. Checks group size compatibility according to `AllowVariableCount` and `AllowBiggerBus`.

**Example:**

```luau
local wires = myInterface:ConnectToInterface(otherInterface)
```

***

#### PinInterface.CreateGroupMask

```luau
PinInterface.CreateGroupMask(count: number, overrideType: Pin.PinMode): PinInterfaceTypes.GroupMask
```

**Parameters:**

* `count` — Number of pins in the group. Must be > 0.
* `overrideType` — Pin mode to override each pin.

**Returns:**

* `GroupMask` — Table suitable for passing to `CreatePinsFromDescription` to resize/override groups.

**Example:**

```luau
local mask = PinInterface.CreateGroupMask(8, Pin.Modes.Output)
local pins = PinInterface.CreatePinsFromDescription(desc, direction, mask)
```
