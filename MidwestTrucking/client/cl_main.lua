-- Trucking Delivery Job for MidWestRP
-- Created by Will B
-- Version 1.0 BETA







-- defining locals
local isJobStarted              = nil
local jobStage			        = nil
local plyCoords                 = GetEntityCoords(GetPlayerPed(-1), false)
local Vehicle                   = nil 
local ModelHash                 = nil
local deliveryPed               = nil
local NPCArrived                = nil 
local isPlayerInDelTruck        = nil 
local truckTrailer              = nil
local Blips                     = {}
local ManifestOverallAmountOptions    = {}
local ManifestOverallItemOptions = {}

local ui                        = false
local JOB_STAGE = {
	GETTING_TRUCK               = 1,
	GETTING_TRAILER             = 2,
	GO_TO_FIRST_DELIVERY        = 3,
	UNLOAD_AT_FACTORY           = 4
}


function UpdateStatus(message)
	SendNUIMessage({ event = "updateStatus", message = message })
end

function setBlipForTruckingJob()
	AddTextEntry('TruckingBlip', 'Walker Logistics')
	local truckingJobBlip = AddBlipForCoord(Config.BlipCoordX, Config.BlipCoordY, Config.BlipCoordZ)
	SetBlipSprite(truckingJobBlip, 477) 
	SetBlipColour(truckingJobBlip, 15)
	SetBlipAlpha(truckingJobBlip, 255)
	SetBlipDisplay(truckingJobBlip, 2)
	BeginTextCommandSetBlipName('TruckingBlip')
	AddTextComponentSubstringPlayerName('me')
	EndTextCommandSetBlipName(truckingJobBlip)
end

CreateThread(setBlipForTruckingJob)


function SpawnTrailer()
	local trailerHash = Config.TrailerHash
	if not IsModelInCdimage(trailerHash) then return 
	end
	RequestModel(trailerHash) -- Request the model
	while not HasModelLoaded(trailerHash) do -- Waits for the model to load with a check so it does not get stuck in an infinite loop
	Citizen.Wait(1)
	end
	local playerPed = PlayerPedId()
	local truckTrailer = CreateVehicle(trailerHash, Config.DelTrailerSpawnX, Config.DelTrailerSpawnY, Config.DelTrailerSpawnZ, Config.DelTrailerSpawnH, true, true) -- Spawns a networked vehicle on your current coords
	SetVehicleLivery(truckTrailer, 2)
	SetModelAsNoLongerNeeded(trailerHash)
	--- Spawning in the Trailer ---

	--- Creates dynamic blip for player's trailer ---
	AddTextEntry('DelTrailerBlip', 'Clucking Bell Trailer')
	trailerblip = AddBlipForEntity(truckTrailer)
	SetBlipFlashes(trailerblip, true)
	SetBlipColour(trailerblip, 31)
	SetBlipRoute(trailerblip, true)
	BeginTextCommandSetBlipName('DelTrailerBlip')
	AddTextComponentSubstringPlayerName('me')
	EndTextCommandSetBlipName(trailerblip)
end
 

-- Function for showing notifications during trucking job
function showAdvancedNotification(message, sender, subject, textureDict, saveToBrief, color)
	BeginTextCommandThefeedPost('STRING')
	AddTextComponentSubstringPlayerName(message)
	ThefeedSetNextPostBackgroundColor(color)
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
	EndTextCommandThefeedPostTicker(false, saveToBrief)
end 

function SpawnAndDeliverTruck()
	if not IsModelInCdimage(ModelHash) then return 
	end
	RequestModel(ModelHash) 
	while not HasModelLoaded(ModelHash) do 
	Citizen.Wait(1)
	end
	Vehicle = CreateVehicle(ModelHash, Config.DelTruckSpawnX, Config.DelTruckSpawnY, Config.DelTruckSpawnZ, Config.DelTruckSpawnH, true, false)
	GetEntityCoords(Vehicle)
	SetVehicleOnGroundProperly(Vehicle)
	local deliveryDriverNPC = Config.DeliverDriverPed
	RequestModel(deliveryDriverNPC) 
	while not HasModelLoaded(deliveryDriverNPC) do 
	Citizen.Wait(1)
	end
	deliveryPed = CreatePedInsideVehicle(Vehicle, 2, deliveryDriverNPC, -1, true, false)
	AddTextEntry('DelTruckBlip', 'Delivery Truck')
	truckblip = AddBlipForEntity(Vehicle)
	SetBlipFlashes(truckblip, true)
	SetBlipColour(truckblip, 29)
	BeginTextCommandSetBlipName('DelTruckBlip')
	AddTextComponentSubstringPlayerName('me')
	EndTextCommandSetBlipName(truckblip)
	TaskVehicleDriveToCoord(deliveryPed, Vehicle, Config.TruckNPCDelSpotX, Config.TruckNPCDelSpotY, Config.TruckNPCDelSpotZ, 10.0, 0, ModelHash, 483, 1, true)
end
	
-- Exit's NPC from Delivery Vehicle
CreateThread(function()
	while NPCArrived ~= true do 
		Citizen.Wait(50)
		local stopRange = #(Config.StopRangeSpot - GetEntityCoords(Vehicle))
		if stopRange < 10 then 
			print(stopRange)
			SetBlipFlashes(truckblip, false)
			TaskVehicleTempAction(deliveryPed, Vehicle, 27, 6000)
			TaskLeaveVehicle(deliveryPed, Vehicle, 1)
			TaskWanderStandard(deliveryPed, 10.0, 10)
			NPCArrived = true
		end
	end
end)

-- Removes blip from Mini Map when Player is in Delivery Truck
CreateThread(function()
	while true do 
		Citizen.Wait(50)
		local playerPed = PlayerPedId()
		local drivingStatus = IsPedInVehicle(playerPed, Vehicle, true)
		if drivingStatus == 1 then 
			SetBlipDisplay(truckblip, 3)
			isPlayerInDelTruck = true
		elseif drivingStatus == false then 
			SetBlipDisplay(truckblip, 2)
		end 	
	end
end)



-- Starts the Trucking Job
function startTruckingJob()

	isJobStarted               = true
	jobStage                   = JOB_STAGE["GETTING_TRUCK"]
	local enroute              = false
	local mechPed              = nil
	local playerPos            = Config.PlayerPosition
	local playerPed            = Config.PlayerID
	ModelHash                  = Config.DeliveryTruck


	-- local randomNumber = math.random(1, 4)
	-- local manifestChoice = ManifestOverallStringOptions[randomNumber]
	-- print(manifestChoice)

	   
	--- NUI Commands ---
	SendNUIMessage({ event = "setVisibility", visibility = true })
	SendNUIMessage({ event = "updateHelpText", message = 'Pick up Truck from Dockhand' })
	SendNUIMessage({ event = "updateStopsLeft", message = '3' })
	SendNUIMessage({ event = "updateStatus", message = 'PreTrip' })

	--- Requesting the truck ---
	SpawnAndDeliverTruck()


    --- Spawning in the Trailer ---
	SpawnTrailer()


	--- Set Manifest ---
	setManifestWeights()
	setManifestItems()



	-- Notification to Player (reference function showAdvancedNotification)
	showAdvancedNotification(
		rawCommand, 
		'Walker Logistics', -- Sender
		'A Dock Hand is pulling your truck around!', -- Subject
		'CHAR_AMANDA', -- Icon Displayed (Women)
		true,
		130
	)

	showAdvancedNotification(
		rawCommand, 
		'Walker Logistics', -- Sender
		'You can wait out front for it!', -- Subject
		'CHAR_AMANDA', -- Icon Displayed (Women)
		true,
		130
	)
end

-- Updates Directions when player enters truck for first time, also changes stage
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
		if isJobStarted == false then return end
		local playerPed = PlayerPedId()
		local retrive = IsPedInVehicle(playerPed, Vehicle, false)
		if jobStage == 1 then
			if retrive == 1 then 
				SendNUIMessage({ event = "updateHelpText", message = 'Pick up Trailer from Loading Dock' })
				SendNUIMessage({ event = "updateStatus", message = 'Loading' })
				jobStage = JOB_STAGE["GETTING_TRAILER"]
			end	
		else
		end 
	end 
end)

-- Starts Route when Trailer is connected
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
		if isJobStarted == false then return end
		local isTrailerHookedUp = IsVehicleAttachedToTrailer(Vehicle)
		if isTrailerHookedUp == 1 then 
			if jobStage == JOB_STAGE["GETTING_TRAILER"] then
				RemoveBlip(trailerblip)
				SendNUIMessage({ event = "updateHelpText", message = 'Deliver Load to Clucking Bell Factory' })
				SendNUIMessage({ event = "updateStatus", message = 'En-Route' })
				DeliveryBlipOne()
				jobStage = JOB_STAGE["GO_TO_FIRST_DELIVERY"]
			end
		else
		end 
	end 
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
		local pos = GetEntityCoords(PlayerPedId())
		local distance = #(pos - vector3(179.6, 6391.71, 32.07))
		if isJobStarted == false then return end
		if jobStage == 3 then 
			if distance < 25 then 
				SendNUIMessage({ event = "updateHelpText", message = 'Back into the Loading Bay & see Dock Hand' })
				SendNUIMessage({ event = "updateStatus", message = 'Unloading' })
				jobStage = JOB_STAGE["UNLOAD_AT_FACTORY"]
			end	
		end
	end 
end)



-------------------------------------------------------------
-------------- All Functions used within Script  ------------
-------------------------------------------------------------

-- Shows a notification on the player's screen 
function ShowNotification( text )
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

-- --- All Delivery blips used in script ---
function DeliveryBlipOne() -- Activates Blimp and Route for CB (Clucking Bell) Delivery Spot One
	AddTextEntry('CBFactoryBlip', 'Clucking Bell Factory')
	CluckingBellFactoryBlip = AddBlipForCoord(179.6, 6391.71, 32.07) -- Clucking Bell Factory in Paleto Bay
	SetBlipColour(CluckingBellFactoryBlip, 31)
	SetBlipRoute(CluckingBellFactoryBlip, true)
	BeginTextCommandSetBlipName('CBFactoryBlip')
	AddTextComponentSubstringPlayerName('me')
	EndTextCommandSetBlipName(CluckingBellFactoryBlip)
end

function DeliveryBlipTwo() -- Activates Blimp and Route for CB (Clucking Bell) Delivery Two 
	SetBlipDisplay(CluckingBellFactoryBlip, 0)
	AddTextEntry('BurtonStoreBlip', 'Clucking Bell Burton Store')
	CluckingBellBurtonStoreBlip = AddBlipForCoord(-132.16, -264.1, 42.78) -- Clucking Bell Store in Burton
	SetBlipColour(CluckingBellBurtonStoreBlip, 31)
	SetBlipRoute(CluckingBellBurtonStoreBlip, true)
	BeginTextCommandSetBlipName('BurtonStoreBlip')
	AddTextComponentSubstringPlayerName('me')
	EndTextCommandSetBlipName(CluckingBellBurtonStoreBlip)
end 

function DeliveryBlipThree() -- Activates Blimp and Route for CB (Clucking Bell) Delivery Three
	SetBlipDisplay(CluckingBellBurtonStoreBlip, 0)
	AddTextEntry('StrawberryStoreBlip', 'Clucking Bell Strawberry Store')
	CluckingBellStrawberryStoreBlip = AddBlipForCoord(-176.24, -1436.41, 31.25) -- Clucking Bell Store in Strawberry
	SetBlipColour(CluckingBellStrawberryStoreBlip, 31)
	SetBlipRoute(CluckingBellStrawberryStoreBlip, true)
	BeginTextCommandSetBlipName('StrawberryStoreBlip')
	AddTextComponentSubstringPlayerName('me')
	EndTextCommandSetBlipName(CluckingBellStrawberryStoreBlip)
end

function TruckingYardBlip() -- Activates Blimp and Route for CB (Clucking Bell) Delivery Three
	SetBlipDisplay(CluckingBellStrawberryStoreBlip, 0)
	AddTextEntry('TruckingYardBlip', 'Truck Yard')
	WalkerLogisticsYard = AddBlipForCoord(Config.BlipCoordX, Config.BlipCoordY, Config.BlipCoordZ) -- Trucking Yard
	SetBlipColour(WalkerLogisticsYard, 31)
	SetBlipRoute(WalkerLogisticsYard, true)
	BeginTextCommandSetBlipName('TruckingYardBlip')
	AddTextComponentSubstringPlayerName('me')
	EndTextCommandSetBlipName(WalkerLogisticsYard)
end

function setManifestItems()
	ManifestOverallItemOptions     = {
		['ManifestItemOptionOne'] = {
			ItemOne   = 'Pallets of Chicken,',
			ItemTwo   = 'Secret Sauce Packets,',
			ItemThree = ' of Stuffing,',
			ItemFour  = ' of Breading,',
			ItemFive  = ' of Chemicals',
		},
		['ManifestItemOptionTwo'] = {
			ItemOne   = 'Crates of Raw Chicken,',
			ItemTwo   = "Cups and Straws,",
			ItemThree = ' of Batter,',
			ItemFour  = 'of Breading,',
			ItemFive  = 'of Corn Starch',
		},
		['ManifestItemOptionThree'] = {
			ItemOne   = 'Pallets of Wings,',
			ItemTwo   = 'of Mac & Cheese,',
			ItemThree = 'of Breading,',
			ItemFour  = 'of Flower,',
			ItemFive  = 'Gloves',
		},
		['ManifestItemOptionFour'] = {
			ItemOne   = 'Boxes of Potatoes,',
			ItemTwo   = 'Sauce Packets,',
			ItemThree = 'of Stuffing,',
			ItemFour  = 'of Breading,',
			ItemFive  = 'Face Masks',
		}
	}

	local routeOptionNumber = math.random(1,4)
	local ManifestOverallItemOptionsChoice = nil 

	if routeOptionNumber == 1 then 
		ManifestOverallItemOptionsChoice = 'ManifestItemOptionOne'
	elseif routeOptionNumber == 2 then 
		ManifestOverallItemOptionsChoice = 'ManifestItemOptionTwo'
	elseif routeOptionNumber == 3 then 
		ManifestOverallItemOptionsChoice = 'ManifestItemOptionThree'
	elseif routeOptionNumber == 4 then 
		ManifestOverallItemOptionsChoice = 'ManifestItemOptionFour'	
	end 

	SendNUIMessage({ 
		event = "setManifestItems", 
		message = ManifestOverallItemOptions[ManifestOverallItemOptionsChoice].ItemOne .. ' ' .. ManifestOverallItemOptions[ManifestOverallItemOptionsChoice].ItemTwo .. ' ' .. ManifestOverallItemOptions[ManifestOverallItemOptionsChoice].ItemThree .. ' ' .. ManifestOverallItemOptions[ManifestOverallItemOptionsChoice].ItemFour .. ' ' .. ManifestOverallItemOptions[ManifestOverallItemOptionsChoice].ItemFive
	})
end	

-- Set's Cargo Manifest, randomized options --
function setManifestWeights()
	ManifestOverallAmountOptions     = {
		['ManifestAmountOptionOne'] = {
			ItemOne   = 50,
			ItemTwo   = 4000,
			ItemThree = '1000lbs',
			ItemFour  = '1000lbs',
			ItemFive  = '6000lbs',
		},
		['ManifestAmountOptionTwo'] = {
			ItemOne   = 80,
			ItemTwo   = 9000,
			ItemThree = '2000lbs',
			ItemFour  = '900lbs',
			ItemFive  = '6000lbs',
		},
		['ManifestAmountOptionThree'] = {
			ItemOne   = 90,
			ItemTwo   = 1000,
			ItemThree = '9000lbs',
			ItemFour  = '5000lbs',
			ItemFive  = '6000lbs',
		},
		['ManifestAmountOptionFour'] = {
			ItemOne   = 110,
			ItemTwo   = 5000,
			ItemThree = '2000lbs',
			ItemFour  = '2000lbs',
			ItemFive  = '6000lbs',
		}
	}

	
	local routeOptionNumber = math.random(1,4)
	local ManifestOverallAmountOptionsChoice = nil 

	if routeOptionNumber == 1 then 
		ManifestOverallAmountOptionsChoice = 'ManifestAmountOptionOne'
	elseif routeOptionNumber == 2 then 
		ManifestOverallAmountOptionsChoice = 'ManifestAmountOptionTwo'
	elseif routeOptionNumber == 3 then 
		ManifestOverallAmountOptionsChoice = 'ManifestAmountOptionThree'
	elseif routeOptionNumber == 4 then 
		ManifestOverallAmountOptionsChoice = 'ManifestAmountOptionFour'
	end 

	SendNUIMessage({ 
		event = "setManifestWeights", 
		message = ManifestOverallAmountOptions[ManifestOverallAmountOptionsChoice].ItemOne .. ' ' .. ManifestOverallAmountOptions[ManifestOverallAmountOptionsChoice].ItemTwo .. ' ' .. ManifestOverallAmountOptions[ManifestOverallAmountOptionsChoice].ItemThree .. ' ' .. ManifestOverallAmountOptions[ManifestOverallAmountOptionsChoice].ItemFour .. ' ' .. ManifestOverallAmountOptions[ManifestOverallAmountOptionsChoice].ItemFive
	})
end
    
-------------------------------------------------------------
-------------- All NetEvents used within Script  ------------
-------------------------------------------------------------    

RegisterNetEvent("GetJobStatus2")
AddEventHandler("GetJobStatus2", function(option)
	isJobStarted = option
	TriggerEvent('GetJobStatus', option)
end)

local initialSpawn = true
RegisterNetEvent("spawnnpcs")
AddEventHandler("spawnnpcs", function()
    Wait(0)
	for k,v in ipairs(Config.Peds) do
		RequestModel(GetHashKey(v.model))
		while not HasModelLoaded(GetHashKey(v.model)) do
			Citizen.Wait(20)
		end
		if v.anim ~= nil and v.animName ~= nil then
			RequestAnimDict(v.anim)
			while not HasAnimDictLoaded(v.anim) do
				Citizen.Wait(20)
			end
		end
		local npcSpawn = CreatePed(4, GetHashKey(v.model), v.x, v.y, v.z, v.a, true, true)
		-- SetModelAsNoLongerNeeded(GetHashKey(v.model))
		-- SetEntityAsMissionEntity(npcSpawn, true, true)
		SetNetworkIdExistsOnAllMachines(netid, true)
		if v.relationship ~= nil then
			SetPedRelationshipGroupHash(npcSpawn, GetHashKey(v.relationship))
		end
		if v.stoic == true then
			SetBlockingOfNonTemporaryEvents(npcSpawn, true)
			SetPedFleeAttributes(npcSpawn, 0, 0)
		end
		if v.god == true then
			SetEntityProofs(npcSpawn, true, true, true, false, true, true, true, true)
		end
		if v.task ~= nil then
			local ped = GetPlayerPed(-1)
			if v.task == "taskcombatplayer" then
				TaskCombatPed(npcSpawn, ped, 0, 16)
			--elseif v.task == "someothervariable" then
			--	insertnewtaskhere
			--elseif v.task == "someothervariable" then
			--	insertnewtaskhere
			end
		end
		if v.anim ~= nil and v.animName ~= nil then
			TaskPlayAnim(npcSpawn, v.anim, v.animName, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
		end
	end
end)

AddEventHandler("playerSpawned", function()
	if initialSpawn and GetNumberOfPlayers() == 1 then
		TriggerServerEvent("collectnpcs")
		initialSpawn = false
	end
end)

-------------------------------------------------------------

-- DV Command, included for personal testing
RegisterCommand('dv', function()
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	DeleteEntity(vehicle)
end, false)

-- Controlling NUI

RegisterCommand('showui', function()
    ui = not ui
    if isJobStarted == true then 
		if ui then 
			SendNUIMessage({ event = "setVisibility", visibility = true }) -- Sends a message to the js file.
		else     
			SendNUIMessage({ event = "setVisibility", visibility = false }) -- Sends a message to the js file.
		end
	end	 
end)

RegisterCommand('status', function(src, args, rawCommand)
	if #args == 0 then print("nothing to update") end
	local buffer = ""
	for i, v in ipairs(args) do
		buffer = buffer .. v
	end
	UpdateStatus(buffer)
end)




-------------------------------------------------------------------
----------------------- Testing Area ------------------------------
-------------------------------------------------------------------


 