local Pin = require(game.ReplicatedStorage.Hardware.Connections.Pin)

local function assertEq(actual, expected, message)
	if actual ~= expected then
		error((message or "assert failed") .. " | expected " .. tostring(expected) .. ", got " .. tostring(actual))
	end
end

local pin = Pin.new()

assertEq(pin:Read(), false, "new pin should start low")

local changes = {}
local disconnect = pin:OnChange(function(level)
	table.insert(changes, level)
end)

pin:HoldHigh("sourceA")
assertEq(pin:Read(), true, "pin should go high when one source holds high")
assertEq(#changes, 1, "listener should fire once")
assertEq(changes[1], true, "listener should receive high")

pin:HoldHigh("sourceA")
assertEq(#changes, 1, "holding same source twice should not duplicate change")

pin:HoldHigh("sourceB")
assertEq(pin:Read(), true, "pin should stay high with multiple sources")
assertEq(#changes, 1, "no extra change when still high")

pin:Release("sourceA")
assertEq(pin:Read(), true, "pin should stay high while another source remains")
assertEq(#changes, 1, "no change yet")

pin:Release("sourceB")
assertEq(pin:Read(), false, "pin should go low when last source releases")
assertEq(#changes, 2, "listener should fire again")
assertEq(changes[2], false, "listener should receive low")

disconnect()

pin:HoldHigh("sourceC")
assertEq(pin:Read(), true, "pin should still work after disconnect")
assertEq(#changes, 2, "disconnected listener should not fire")

print("Pin test passed")
