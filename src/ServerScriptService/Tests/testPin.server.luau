local Pin = require(game.ReplicatedStorage.Hardware.Connections.Pin)

local shouldLog = false

local function log(msg)
	if not shouldLog then
		return
	end
	print("[PIN TEST] " .. msg)
end

local function assertEq(actual, expected, message)
	if actual ~= expected then
		error((message or "assert failed") .. " | expected " .. tostring(expected) .. ", got " .. tostring(actual))
	end
end

log("Creating pin")
local pin = Pin.new()

log("Checking initial state")
assertEq(pin:Read(), false, "new pin should start low")

local changes = {}

log("Attaching listener")
local disconnect = pin:OnChange(function(level)
	log("Listener fired -> " .. tostring(level))
	table.insert(changes, level)
end)

-- Phase 1: single source
log("Phase 1: single source A HIGH")
pin:HoldHigh("sourceA")

assertEq(pin:Read(), true, "pin should go high when sourceA holds high")
assertEq(#changes, 1, "listener should fire once on rising edge")
assertEq(changes[1], true, "first change should be HIGH")

-- Duplicate hold (should be ignored)
log("Holding same sourceA again (no-op expected)")
pin:HoldHigh("sourceA")

assertEq(#changes, 1, "duplicate hold should not trigger change")

-- Phase 2: multiple sources
log("Phase 2: adding sourceB HIGH")
pin:HoldHigh("sourceB")

assertEq(pin:Read(), true, "pin should remain high")
assertEq(#changes, 1, "no extra change while already high")

-- Partial release
log("Releasing sourceA (sourceB still active)")
pin:Release("sourceA")

assertEq(pin:Read(), true, "pin should stay high with sourceB active")
assertEq(#changes, 1, "no transition yet")

-- Final release
log("Releasing sourceB (should go LOW)")
pin:Release("sourceB")

assertEq(pin:Read(), false, "pin should go low when last source releases")
assertEq(#changes, 2, "listener should fire on falling edge")
assertEq(changes[2], false, "second change should be LOW")

-- Phase 3: reconnect behavior
log("Disconnecting listener")
disconnect()

log("Testing after disconnect (sourceC)")
pin:HoldHigh("sourceC")

assertEq(pin:Read(), true, "pin should still respond internally")
assertEq(#changes, 2, "listener should NOT fire after disconnect")

log("Cleaning up sourceC")
pin:Release("sourceC")

-- Phase 4: stress / redundancy checks
log("Phase 4: redundant operations")
pin:Release("nonexistent") -- should be no-op
pin:HoldHigh("dup")
pin:HoldHigh("dup") -- duplicate
pin:Release("dup")

log("Verifying final state is LOW")
assertEq(pin:Read(), false, "final state should be LOW")

log("Re-attaching listener for final sanity check")
local finalChanges = {}
pin:OnChange(function(level)
	table.insert(finalChanges, level)
end)

pin:HoldHigh("A")
pin:Release("A")

assertEq(#finalChanges >= 2, true, "should detect at least rising + falling edge")

log("ALL TESTS PASSED ✔")
