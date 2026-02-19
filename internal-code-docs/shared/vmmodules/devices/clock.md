---
icon: brackets-curly
---

# Clock

### Dependencies

* [pin.md](../connection/pin.md "mention")
* [utils.md](../../modules/utils.md "mention")
* [wire.md](../connection/wire.md "mention")

### What is this module for?

A simple **clock device**. Produces a square-wave output on its output pin at a configurable frequency. Can be toggled on/off with a dedicated input pin. Tracks completed cycles.

***

### Properties

#### Clock.ID

* **Type:** `string`
* **Description:** Unique identifier for this clock instance, generated automatically.
* **Example:**

```luau
print(myClock.ID) -- "7c3f12..."
```

#### Clock.Frequency

* **Type:** `number`
* **Description:** Clock frequency in Hz. Determines cycle duration of the square wave.

**Example:**

```luau
print(myClock.Frequency) -- 2
```

#### Clock.ToggleClockPin

* **Type:** [`Pin`](../connection/pin.md)&#x20;
* **Description:** Input pin that toggles the clock on/off when driven high.

**Example:**

```luau
myClock.ToggleClockPin:ConnectListener(function(state)
    print("Toggle input:", state)
end)
```

#### Clock.OutputPin

* **Type:** [`Pin`](../connection/pin.md)
* **Description:** Output pin that emits the square-wave signal.

**Example:**

```luau
myClock.OutputPin:ConnectListener(function(state)
    print("Clock output:", state)
end)
```

#### Clock.CyclesDone

* **Type:** `number`
* **Description:** Count of full clock cycles completed (rising-edge count).

**Example:**

```luau
print(myClock.CyclesDone) -- 5
```

#### Internal Properties

| Name                 | Type      | Description                                                                 |
| -------------------- | --------- | --------------------------------------------------------------------------- |
| `_running`           | `boolean` | Indicates whether the clock is currently active.                            |
| `_currentClockOut`   | \`0       | 1\`                                                                         |
| `_cycleDuration`     | `number`  | Full cycle duration in seconds (`1 / Frequency`).                           |
| `_halfCycleDuration` | `number`  | Half-cycle duration in seconds (used for toggling output every half-cycle). |
| `_accumulator`       | `number`  | Tracks accumulated delta time in seconds for cycle updates.                 |

***

### Functions / Methods

#### Clock.new

```luau
Clock.new(frequency: number): Clock
```

**Parameters:**

* `frequency` — Clock frequency in Hz. Defaults to `1` if omitted.

**Returns:**

* `Clock` — A new clock device instance with pins and runtime loop initialized.

**Description:**\
Creates a clock with a toggle input and an output pin. Sets up a background loop to handle output toggling at the configured frequency. The output pin emits a square wave, switching every half-cycle. `CyclesDone` increments on every rising edge.

***

#### Clock:\_Toggle

```luau
Clock:_Toggle(): ()
```

**Description:**\
Internal method that flips the `_running` state of the clock. Called automatically when `ToggleClockPin` receives a high signal.

***

#### Clock:\_ConnectToLoop

```luau
Clock:_ConnectToLoop(func: (deltaTime: number) -> ()): ()
```

**Parameters:**

* `func` — Function called each iteration of the internal update loop, receives `deltaTime` in seconds.

**Description:**\
Sets up a continuously running task that repeatedly calls `func` with the elapsed time since the last update. Handles yielding to allow other Roblox tasks to run. Used internally to drive the clock output.

***

#### Clock:SetFrequency

```luau
Clock:SetFrequency(frequency: number): ()
```

**Parameters:**

* `frequency` — New clock frequency in Hz.

**Description:**\
Updates the clock’s frequency and recalculates cycle durations. Does not start or stop the clock; simply changes the timing of the ongoing loop.

***

### Behavior Notes

* **Output Pin:** `OutputPin` is updated every half-cycle; connected wires and listeners react to its state.
* **Toggle Mechanism:** Driving `ToggleClockPin` high triggers `_Toggle`, flipping the `_running` flag.
* **Cycle Counting:** `CyclesDone` increments only on rising edges (0 → 1).

***

### Example Usage

```luau
local Clock = require(VMModules.Devices.Clock)
local Pin = reqiuire(VMModules.Connection.Pin)
local Wire = reqiuire(VMModules.Connection.Wire)

-- Create a 2 Hz clock
local myClock = Clock.new(2)
local myPin = Pin.new(Pin.Modes.Input)
local myTogglePin = Pin.new(Pin.Modes.Output)

-- listen to our pin
myPin:ConnectListener(function(state:number)
    print(state)
end)

-- set our toggle pin to provide 1, to toggle our clock.
myTogglePin:ConnectProvider(function() : number
    return 1
end)
myTogglePin:Update() -- call update to update Pin's state

Wire.new(myClock.OutputPin, myPin) -- connect to the clock
Wire.new(myClock.ToggleClockPin, myTogglePin) -- once connected clock will be toggled
-- because of automatic Pin->Wire update on connection

-- we should see our state printed at 4Hz (because high and low edge happen in half cycles)

```
