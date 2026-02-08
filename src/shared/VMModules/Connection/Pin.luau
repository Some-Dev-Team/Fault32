-- services and dependencies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Modules
local Utils = require(Modules.Utils)

local Pin = {}
Pin.__index = Pin

Pin.Modes = {
	Input    = 0,
	Output   = 1,
	TriState = 2,
}

-- helpers

local function defaultProvideValueFunc(): number
	return 0
end

local function defaultListenFunction(state: number)
	assert(state == 0 or state == 1, "State must be 0 or 1, got " .. tostring(state))
end

-- constructor

function Pin.new(mode: number?)
	local self = setmetatable({}, Pin)

	if mode then
		assert(
			mode == Pin.Modes.Input
				or mode == Pin.Modes.Output
				or mode == Pin.Modes.TriState,
			"Invalid pin mode"
		)
	end

	self.ID = Utils.GenerateUniqueID()
	self.Mode = mode or Pin.Modes.Input

	self.ProvideValueFunc = defaultProvideValueFunc
	self.ListenFunc = defaultListenFunction

	self.Driving = false -- only meaningful for Output / TriState
	self._lastOutput = nil

	self._WireListeners = {function(state: number) end}

	return self
end

function Pin:ConnectWireListener(func: (state: number) -> ())
	table.insert(self._WireListeners, func)
end

-- dev-facing API

function Pin:ConnectListener(func: (state: number) -> ())
	assert(self.Mode == Pin.Modes.Input or self.Mode == Pin.Modes.TriState,
		"Attempted to connect listener to non-input-capable pin")

	self.ListenFunc = function(state: number)
		assert(state == 0 or state == 1, "State must be 0 or 1, got " .. tostring(state))
		func(state)
	end
end

function Pin:ConnectProvider(func: () -> number)
	assert(self.Mode == Pin.Modes.Output or self.Mode == Pin.Modes.TriState,
		"Attempted to connect provider to non-output-capable pin")

	self.ProvideValueFunc = function()
		local val = func()
		assert(val == 0 or val == 1, "Value must be 0 or 1, got " .. tostring(val))
		return val
	end
end

-- runtime behavior

function Pin:Read(): number?
	if self.Mode == Pin.Modes.Output then
		return self.ProvideValueFunc()
	end

	if self.Mode == Pin.Modes.TriState and self.Driving then
		return self.ProvideValueFunc()
	end

	return nil -- floating
end

function Pin:Set(state: number)
	assert(state == 0 or state == 1, "State must be 0 or 1, got " .. tostring(state))
	self.ListenFunc(state)
end

function Pin:Update()
	if self.Mode == Pin.Modes.Output
	or (self.Mode == Pin.Modes.TriState and self.Driving) then
		local val = self.ProvideValueFunc()

		if val ~= self._lastOutput or self._lastWasDriving ~= true then
			self._lastOutput = val
			self._lastWasDriving = true
			
			for _, func in self._WireListeners do
				func(val)
			end
		end
	else
		self._lastWasDriving = false
	end
end


return Pin
