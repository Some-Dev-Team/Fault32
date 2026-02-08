local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Pin = require(ReplicatedStorage.VMModules.Connection.Pin)

local Wire = {}
Wire.__index = Wire

function Wire.new(pinA: typeof(Pin.new()), pinB: typeof(Pin.new()))
	local self = setmetatable({}, Wire)

	self.PinA = pinA
	self.PinB = pinB

	-- internal state
	self._lastDriver = nil

	-- attach listeners
	pinA:ConnectWireListener(function(state: number)
		self:_OnDrive(pinA, state)
	end)

	pinB:ConnectWireListener(function(state: number)
		self:_OnDrive(pinB, state)
	end)

	-- initial update
	pinA:Update()
	pinB:Update()

	return self
end

function Wire:_OnDrive(sourcePin, state: number)
	local otherPin = (sourcePin == self.PinA) and self.PinB or self.PinA

	-- detect contention only if both are currently driving
	local otherIsDriving =
		(otherPin.Mode == Pin.Modes.Output)
		or (otherPin.Mode == Pin.Modes.TriState and otherPin.Driving)

	--if otherIsDriving then
	--	warn("🔥 Wire contention between pins " .. self.PinA.ID .. " and " .. self.PinB.ID)
	--end

	-- propagate
	otherPin:Set(state)
end


function Wire:Disconnect()
	self.PinA._WireListener = function() end
	self.PinB._WireListener = function() end
end

return Wire
