local component = require "component"
local serialization = require"serialization"
local thread = require"thread"
local computer = require"computer"
local modem = component.modem
local gpu = component.gpu
local port = 512
local event = require "event"
local modemAddress = component.modem.address
local w, h = gpu.getResolution()
local keys = {
	[17] = "moveForward", 	--W
	[31] = "moveBack",		--S
	[30] = "moveLeft",		--A
	[32] = "moveRight",		--D
	[42] = "moveDown",		--SHIFT
	[57] = "moveUp",		--SPACE
	[18] = "OTSOS",			--E
	[33] = "VIBROSI",		--F
	[16] = "chopTree",		--Q
	[19] = "checkKey",		--R
	[20] = "activate"		--T
}
Colors = {Black = 0x000000, White = 0xFFFFFF, Red = 0xFF0000, Green = 0x00FF00, Blue = 0x0000FF, Yellow = 0xFFDB00}
local e = {}
local addresses = {}
local Options = {}

	modem.open(port)

function Options.communicateWithServer()

	modem.send(variableCurrentAddress, port, (io.read()))
	repeat
	local _, _, from, port, _, message = event.pull("modem_message")
	print("Got a message from " .. from .. " on port " .. port .. ": " .. tostring(message))
until message == "end" 
print ("end of cicle")
end 

function countMemory()
	--1024KB/4096KB
	print(computer.freeMemory() .. '/' .. computer.totalMemory())
end

function Options.ShowDEBUGInfo()

	gpu.setBackground(Colors.Yellow)
gpu.fill(152, 0, w, h, " ")
	gpu.setForeground(Colors.Black)
gpu.set(152, 0,countMemory())
end

function connect()
	local addressesCount = 1
	modem.broadcast(port, "connect")
	for i = 0, 10,1 do 
		local _, _, from, _, _, _ = event.pull(1, "modem_message") --pull with timeout of 1 second(listen for 10 times)
	
	if from ~= nil then
	print(from)

	
	addresses[addressesCount] = from
	print(addressesCount)
	addressesCount = addressesCount+1
	
else 
	break
	print("nil address")
end end end

function currentAddress()
	local counter = 1
		for addressesCount = 0, 10, 1 do
			if addresses[addressesCount] ~=nil then
	print(counter..'.'..addresses[addressesCount])
	
	counter = counter +1
 			else
 	break end end
 	print ("choose address")
 	while true do
	 local e = {event.pull()}
 	 if e[1] == "key_down" then
			local currentPosition = tonumber((e[4] -1))
		 CA = addresses[currentPosition]
		print(currentPosition)
	if (CA ~= nil) then
	print("your chose: "..currentPosition..'.'..CA)
	break
	else print("wrong position")
    end end
end 
 	return CA
end 

--[[function options()
while true do
	 local e = {event.pull()}
 	 if e[1] == "key_down" then
			local currentOption = tonumber((e[4] -1))
end]]--
-----------------------------------------------------------------------------------------------|
-----------------------------------------------------------------------------------------------|
	connect()
	variableCurrentAddress = currentAddress()
while true do
print("pick the option")
local chose = io.read()
	if chose == "communicate" then
	Options.communicateWithServer() 
else if chose == "show" then
	Options.ShowDEBUGInfo()
else if chose == "ram" then
	countMemory()
end end end end
-----------------------------------------------------------------------------------------------|
-----------------------------------------------------------------------------------------------|
--[[
local _, _, from, port, _, message = event.pull("modem_message")


]]--