---
description: Object
icon: brackets-curly
---

# Wire

### Dependencies

* [pin.md](pin.md "mention")
* [utils.md](../../modules/utils.md "mention")

### What is this module for?

Represents a virtual wire connecting multiple `Pin` instances. Aggregates driving signals from pins and updates all connected pins automatically. Supports multiple pins per wire and dynamic connect/disconnect.

***

### Properties

#### Wire.ID

* **Type:** `string`
* **Description:** Unique identifier for the wire, generated automatically on creation.

**Example:**

```luau
print(wire.ID) -- "8b1f3a..."
```

#### Wire.Pins

* **Type:** `{Pin}`
* **Description:** List of pins currently connected to the wire.

**Example:**

```luau
for _, pin in ipairs(wire.Pins) do
    print("Connected Pin ID:", pin.ID)
end
```

#### Wire.State

* **Type:** `number`
* **Description:** Current wire state, either 0 (low) or 1 (high). Updated based on connected pins driving high.

**Example:**

```luau
print("Wire state:", wire.State)
```

#### Internal Properties

| Property           | Type                                | Description                                               |
| ------------------ | ----------------------------------- | --------------------------------------------------------- |
| `_listeners`       | `{ [Pin] = (state: number) -> () }` | Functions attached to pins for listening to their output. |
| `_highDrivers`     | `{ [Pin] = true }`                  | Tracks which pins are driving the wire high.              |
| `_highDriverCount` | `number`                            | Count of pins currently driving high.                     |

***

### Functions

#### Wire.new

```luau
Wire.new(pinA: Pin, pinB: Pin): Wire
```

**Parameters:**

* `pinA` — First pin to connect.
* `pinB` — Second pin to connect.

**Returns:**

* `Wire` — New wire instance with initial pins connected.

**Description:**\
Creates a new wire, connects two initial pins, sets up listeners, and synchronizes wire state to pins.

**Example:**

```luau
local wire = Wire.new(outputPin, inputPin)
print(wire.State) -- 0 or 1 depending on outputPin
```

***

#### Wire:ConnectPin

```luau
wire:ConnectPin(pin: Pin): () -> ()
```

**Parameters:**

* `pin` — Pin to connect to this wire.

**Returns:**

* `Disconnect` — Function that removes the pin from the wire and disconnects listener.

**Description:**\
Connects a new pin to the wire. Immediately syncs the wire state to the pin and sets up internal listener for pin changes.

**Example:**

```luau
local disconnect = wire:ConnectPin(inputPin2)

-- Disconnect later
disconnect()
```

***

#### Wire:DisconnectAll

```luau
wire:DisconnectAll()
```

**Parameters:** None

**Returns:** None

**Description:**\
Disconnects all pins from the wire, removes all listeners, and clears internal state.

**Example:**

```luau
wire:DisconnectAll()
print(#wire.Pins) -- 0
```

***

#### Wire:SyncPinsToWire

```luau
wire:SyncPinsToWire()
```

**Parameters:** None

**Returns:** None

**Description:**\
Updates all connected pins with the current wire state. Typically called internally whenever wire state changes.

**Example:**

```luau
wire:SyncPinsToWire()
```

***

#### Wire:\_OnDrive

```luau
wire:_OnDrive(sourcePin: Pin, state: number)
```

**Parameters:**

* `sourcePin` — Pin that caused the state change.
* `state` — 0 or 1, value output by pin.

**Returns:** None

**Description:**\
Internal function. Handles pin driving signals, updates `_highDrivers`, counts high signals, and calls `_ChangeState` accordingly.

**Example:**

```luau
-- Internal; not meant to be called manually
```

***

#### Wire:\_ChangeState

```luau
wire:_ChangeState(newState: number)
```

**Parameters:**

* `newState` — 0 or 1, new state of the wire.

**Returns:** None

**Description:**\
Internal function. Updates `State` if it differs from current, then propagates to connected pins via `SyncPinsToWire`.

**Example:**

```luau
-- Internal; not meant to be called manually
```
