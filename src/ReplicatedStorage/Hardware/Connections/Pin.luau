local Pin = {}
Pin.__index = Pin

export type PowerLevel = boolean

export type PinListener = (newPowerLevel: PowerLevel) -> ()
export type PinListenerDisconnect = () -> ()

type PinFields = {
	autoPropagate: boolean,

	_listeners: { PinListener },
	_highSources: { [string]: true },
	_highCount: number,
	_lastNotifiedLevel: PowerLevel,

	Read: (self: Pin) -> PowerLevel,
	Propagate: (self: Pin) -> (),
	OnChange: (self: Pin, listener: PinListener) -> PinListenerDisconnect,

	HoldHigh: (self: Pin, sourceId: string) -> (),
	Release: (self: Pin, sourceId: string) -> (),
	_FireListeners: (self: Pin) -> (),
}

export type Pin = typeof(setmetatable({} :: PinFields, Pin))

Pin.PowerLevels = {
	HIGH = true,
	LOW = false,
}

function Pin.new(autoPropagate: boolean?): Pin
	local self = setmetatable({} :: PinFields, Pin)

	self.autoPropagate = if autoPropagate == nil then true else autoPropagate

	self._listeners = {}
	self._highSources = {}
	self._highCount = 0
	self._lastNotifiedLevel = false

	return self
end

function Pin:Read(): PowerLevel
	return self._highCount > 0
end

function Pin:_FireListeners()
	local newLevel = self:Read()

	if self._lastNotifiedLevel == newLevel then
		return
	end

	self._lastNotifiedLevel = newLevel

	for _, listener in ipairs(self._listeners) do
		listener(newLevel)
	end
end

function Pin:Propagate()
	self:_FireListeners()
end

function Pin:HoldHigh(sourceId: string)
	if self._highSources[sourceId] then
		return
	end

	self._highSources[sourceId] = true
	self._highCount += 1

	if self.autoPropagate then
		self:_FireListeners()
	end
end

function Pin:Release(sourceId: string)
	if not self._highSources[sourceId] then
		return
	end

	self._highSources[sourceId] = nil
	self._highCount -= 1

	if self.autoPropagate then
		self:_FireListeners()
	end
end

function Pin:OnChange(listener: PinListener): PinListenerDisconnect
	table.insert(self._listeners, listener)
	local index = #self._listeners

	return function()
		if self._listeners[index] == listener then
			table.remove(self._listeners, index)
			return
		end

		for i = #self._listeners, 1, -1 do
			if self._listeners[i] == listener then
				table.remove(self._listeners, i)
				break
			end
		end
	end
end

return Pin
