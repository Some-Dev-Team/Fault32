---
description: Object
icon: brackets-curly
---

# Pin

### Dependencies

* [utils.md](../../modules/utils.md "mention")

### What is this module for?

Provides a programmable “pin” abstraction for connecting wires in a virtual machine. Supports **Input**, **Output**, and **Bidirectional** pins. Pins can have listeners, providers, and internal registers, and propagate state changes through connected wires.

***

### Properties

#### Pin.ID

* **Type:** `string`
* **Description:** Unique identifier for the pin, automatically generated on creation.
* **Example:**

```lua
print(pin.ID) -- "f3b7a2..."
```

#### Pin.Mode

* **Type:** `PinMode` (`Pin.Modes.Input | Pin.Modes.Output | Pin.Modes.Bidirectional`)
* **Description:** Mode of the pin, defining allowed operations. Defaults to Input if not provided.
* **Example:**

```lua
if pin.Mode == Pin.Modes.Bidirectional then
    print("This pin can both send and receive signals.")
end
```

#### Pin.Register

* **Type:** `number?`
* **Description:** Optional internal register, auto-updated when `createPinRegister` is true. Can store last input/output for this pin.
* **Example:**

```lua
pin.Register = 1
print(pin.Register)
```

#### Internal Properties

These are intended for internal usage, but exposed for debugging:

| Property            | Type                                 | Description                                                                                     |
| ------------------- | ------------------------------------ | ----------------------------------------------------------------------------------------------- |
| `_getOutput`        | `() -> number`                       | Function returning the output value. Defaults to 0, set via `ConnectProvider`.                  |
| `_inputListeners`   | `{ (state: number) -> () }`          | List of listeners triggered when pin input changes.                                             |
| `_driving`          | `boolean`                            | Whether a bidirectional pin is currently driving output. Output pins always considered driving. |
| `_lastDrivenValue`  | `number?`                            | Last value output by pin provider.                                                              |
| `_lastInputValue`   | `number`                             | Last aggregated input state from wires.                                                         |
| `_inputHighSources` | `{ [Wire] = true }`                  | Tracks which connected wires are driving high.                                                  |
| `_inputHighCount`   | `number`                             | Count of wires currently driving high.                                                          |
| `_wireListeners`    | `{ [Wire] = (state: number) -> () }` | Functions that propagate pin state to connected wires.                                          |

***

### Functions

#### Pin.new

```luau
Pin.new(mode: PinMode, createPinRegister: boolean?): Pin
```

**Parameters:**

* `mode` — Pin mode (Input, Output, Bidirectional). Optional, defaults to Input.
* `createPinRegister` — \[optional] Creates internal register if true.

**Returns:**

* `Pin` — New pin instance.

**Description:**\
Creates a new pin instance with optional register, listeners, and provider.

**Example:**

```luau
local inputPin = Pin.new(Pin.Modes.Input, true)
local outputPin = Pin.new(Pin.Modes.Output)
```

***

#### Pin:ConnectListener

```luau
pin:ConnectListener(func: (state: number) -> ()): () -> ()
```

**Parameters:**

* `func` — Function called when pin receives input (0 or 1).

**Returns:**

* `DisconnectListener` — Function that removes the listener.

**Description:**\
Connects a listener to Input or Bidirectional pins. Throws an error if called on Output pin.

**Example:**

```luau
local disconnect = inputPin:ConnectListener(function(state)
    print("Input received:", state)
end)

-- Disconnect later
disconnect()
```

***

#### Pin:ConnectProvider

```luau
pin:ConnectProvider(func: () -> number, overwrite: boolean?): nil
```

**Parameters:**

* `func` — Function returning output value (0 or 1).
* `overwrite` — \[optional] Allows replacing existing provider. Defaults to false.

**Returns:**

* None

**Description:**\
Connects a provider function to Output or Bidirectional pins. Only one provider allowed per pin.

**Example:**

```luau
outputPin:ConnectProvider(function() return 1 end)
print(outputPin:Read()) -- 1
```

***

#### Pin:Read

```luau
pin:Read(): number
```

**Parameters:** None

**Returns:**

* Current value of the pin (0 or 1). Considers output provider if driving, or aggregated input otherwise.

**Example:**

```luau
print(inputPin:Read())
```

***

#### Pin:IsDriving

```luau
pin:IsDriving(): boolean
```

**Parameters:** None

**Returns:**

* `true` if pin is currently driving output, else `false`.

**Example:**

```luau
print(bidiPin:IsDriving()) -- true or false
```

***

#### Pin:ApplyWireState

```luau
pin:ApplyWireState(sourceWire, state: number)
```

{% hint style="warning" %}
This function is used internally, it is strongly adviced to omit using it for general purposes.
{% endhint %}

**Parameters:**

* `sourceWire` — Wire that triggered state change.
* `state` — 0 or 1, new state of wire.

**Returns:** None

**Description:**\
Updates internal input state from a wire. Notifies listeners if pin is not driving.

**Example:**

```luau
pin:ApplyWireState(wire1, 1)
```

***

#### Pin:SetDriving

```luau
pin:SetDriving(driving: boolean?)
```

**Parameters:**

* `driving` — \[optional] true to start driving, false to stop. Only affects Bidirectional pins.

**Returns:** None

**Description:**\
Sets whether a bidirectional pin is actively driving. Propagates current pin value to wires.

**Example:**

```luau
bidiPin:SetDriving(true)
```

***

#### Pin:Update

```luau
pin:Update()
```

**Parameters:** None

**Returns:** None

**Description:**\
Updates pin state, pushing current output to connected wires if driving. Typically called every VM cycle.

**Example:**

```luau
outputPin:Update()
```

***

#### Pin:AddWireListener

```luau
pin:AddWireListener(sourceWire, func: (state: number) -> ())
```

{% hint style="warning" %}
This function is used internally, it is strongly adviced to omit using it for general purposes.
{% endhint %}

**Parameters:**

* `sourceWire` — Wire to attach listener to.
* `func` — Function called immediately and on subsequent wire state changes.

**Returns:** None

**Example:**

```luau
pin:AddWireListener(wire1, function(state) print("Wire state:", state) end)
```

***

#### Pin:RemoveWireListener

```luau
pin:RemoveWireListener(sourceWire)
```

{% hint style="warning" %}
This function is used internally, it is strongly adviced to omit using it for general purposes.
{% endhint %}

**Parameters:**

* `sourceWire` — Wire to remove listener for.

**Returns:** None

**Description:**\
Removes wire listener and updates internal high-source count. Warns if listener not found.

**Example:**

```luau
pin:RemoveWireListener(wire1)
```
