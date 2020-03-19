local robot = require"robot"
local thread = require "thread"
local component = require "component"
local event = require("event")
local serialization = require("serialization")
local filesystem = require "filesystem"
local serialization = require"serialization"
local computer = require"computer"
local modem = component.modem
local port = 512
local robotPort = 1024
local eeprom = component.eeprom
--local navigation = component.navigation
local library = require"library"
local inventory = component.inventory_controller
local gpu = component.gpu
modem.open(port)
modem.open(robotPort)
waypointParam = {}
Control = {}
Algorithms = {}
function connect()
	addresses = {}
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

function receiveSignal()
	local _, _, from, _, _, message = event.pull("modem_message")
	return message
end
function sendToServer(dataString, pathToSave, fileOptions)
 --local filePath,dataString = read(file)
 if (pathToSave == nil or pathToSave == _) then
pathToSave = "temp"
fileOptions = "add"
 end
 if (fileOptions == "add") then
dataString = dataString.."$ "
 end 
modem.send(variableCurrentAddress, port, "receiveFile")--begin
modem.send(variableCurrentAddress, port, pathToSave) --path
modem.send(variableCurrentAddress, port, fileOptions) --opt
os.sleep(0.5)
modem.send(variableCurrentAddress, port, dataString) --data
end

function inventoryCount()
local INVENTORY = {}
for i =1, 16, 1 do
table.insert(INVENTORY,(robot.count(i)))
return INVENTORY
end end 

function toolDurability()
	local TOOL = {[1] = robot.durability()}
	return TOOL[cur]
	
end

function sendLogToServer()
local toLog = {computer.energy(),
computer.maxEnergy(),
computer.freeMemory(),
toolDurability(),
inventoryCount(),
}

local fileString = serialization.serialize(toLog)
print("pick the path to send file to server")
sendFileToServer(fileString, io.read())
end

function detectLeft()
robot.turnLeft()
bobot.detect()
robot.turnRight()
end
function detectRight()
robot.turnRight()
bobot.detect()
robot.turnLeft()
end

function oreAnalyze()
local currentOre = nil
local analyzeSide = nil
local analyzedOreCoordinatres = {
	[1] = {analyzedOreCoordinatreX},
	 [2] ={analyzedOreCoordinatreY},
	  [3] = {analyzedOreCoordinatreZ}}
local availableAnalyze = {
	[1] = robot.detect(),
	[2] = robot.detectUp(),
	[3] = robot.detectDown(),
	[4] = detectLeft(),
	[5] = detectRight(),
}
local isBlockOnSide = nil
local availableSides = 5 -- front up down left right 
for counter = 0, availableSides do
--check have a block the front of robot
isBlockOnSide, currentOre = analyzedOreCoordinatres[counter]
sendToServer(isBlockOnSide, "analyzedBlocks", "add")
sendToServer(currentOre, "analyzedBlock", "add")
end end

local function remoteControl()
	while true do
--	local _, _, from, _, _, message = event.pull("modem_message")
		local e = {event.pull()}
	if e[1] == "modem_message" then
		if e[4] == robotPort then
				if e[6] then print(e[6])
				if e[6] == "moveUp" then
						robot.up()
					elseif e[6] == "moveDown" then
						robot.down()
					elseif e[6] == "moveForward" then
						robot.forward()
					elseif e[6] == "moveBack" then
						robot.back()
					elseif e[6] == "moveLeft" then
						robot.turnLeft()
					elseif e[6] == "moveRight" then
						robot.turnRight()
					elseif e[6] == "analyze" then
						isPassing, detectedBlock = robot.detect()
						modem.broadcast(robotPort, detectedBlock)
					elseif e[6] == "checkKey" then
						checkkey()
					else if e[6] == "activate" then
						robot.use()
					elseif e[6] == "OTSOS" then
						for i = 1, (inventory.getInventorySize(0) or 1) do
							inventory.suckFromSlot(0, 1)
						end
						for i = 1, (inventory.getInventorySize(1) or 1) do
							inventory.suckFromSlot(1, 1)
						end
					else if e[6] == "swing" then 
						robot.swing()
					
					else if e[6] == "use" then
						robot.use()
					
					elseif e[6] == "VIBROSI" then
						for i = 1, robot.inventorySize() do
							robot.select(1)
							robot.drop(64)
						end
					else if e[6] == "analyze" then 
						oreAnalyze()
					end
					else if e[6] == "end" then
						return "end"
					elseif e[6] == "moveSpeedUp" then
						moveSpeed = moveSpeed + 0.1
						print("SKOROST + NA 0.1")
					elseif e[6] == "moveSpeedDown" then
						moveSpeed = moveSpeed - 0.1
					if moveSpeed < 0.1 then moveSpeed = 0.1 end
					print("SKOROST - NA 0.1")
				end
			end
		end
	end
end end end
end end end

function algorithmControl()

--get signal
local _, _, _, _, _, message = event.pull("modem_message")
if (message == "mine")then
	Algorithms.mine()
else if (message == "end") then
	break
end end end

local function getAlgorithms()
	local serializedTable = serialization.serialize(Algorithms)
for i = 0, #Algorithms, 1 do
print(i .. ".".. " ".. Algorithms[i]) 
end end

function Algorithms.mine()
local cubeX = 20
local cubeY = 20
local cubeZ = 20
local Xposition
local Yposition
local Zposition
local startPosition = {cubeX/2, cubeY,cubeZ}
local currentPosition = {Xposition, Yposition, Zposition}
local XstartPosition = 0
while(currentPosition.Zposition ~= cubeZ)do
	robot.swing()
	robot.forward()
	--turn
	if(currentPosition.Zposition == cubeZ) then
	while(currentPosition.Yposition ~= cubeY)do
robot.swingUp()
robot.up()
robot.turnRight()
robot.turnRight()
if (currentPosition.Yposition == cubeY and currentPosition.Yposition == cubeY and currentPosition.Xposition ~= cubeX) then
while(currentPosition.Xposition ~= cubeX) do
	robot.turnRight()
	robot.swing()
	robot.forward()
end end 
end
 end end end


----------------------------------------------------------------------------------------------------|
--	execute	begin																					--
----------------------------------------------------------------------------------------------------|
	connect()
	variableCurrentAddress = currentAddress()

while true do
	print("start system")
local signal = receiveSignal()
if signal == "remoteControl" then
	print("start controlling")
	 remoteControl()
else if signal == "algorithmControl" then
	algorithmControl()
end end end
----------------------------------------------------------------------------------------------------|
--	execute end																						--
----------------------------------------------------------------------------------------------------|
