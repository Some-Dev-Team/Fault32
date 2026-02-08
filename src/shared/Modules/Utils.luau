-- dependencies and servcies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local httpService = game:GetService("HttpService")

local Utils = {}

function Utils.GenerateUniqueID(): string
	return httpService:GenerateGUID(false)
end

function Utils.BitTableToByte(bitTable: {number}): number
	local byte = 0
	for i = 1, #bitTable do
		if bitTable[i] == 1 then
			byte = byte + 2 ^ (i - 1)
		end
	end
	return byte
end

function Utils.ByteToBitTable(byte: number, bitCount: number): {number}
	local bitTable = {}
	for i = 1, bitCount do
		bitTable[i] = byte % 2
		byte = math.floor(byte / 2)
	end
	return bitTable
end


return Utils
