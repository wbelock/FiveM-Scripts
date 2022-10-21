--------------------------------------------------------------------------
------------------ Functions Used for MidwestTrucking --------------------
--------------------------------------------------------------------------
-- local isJobStarted              = nil
-- local jobStage			        = nil
-- local plyCoords                 = GetEntityCoords(GetPlayerPed(-1), false)
-- local Vehicle                   = nil 
-- local ModelHash                 = nil
-- local deliveryPed               = nil
-- local NPCArrived                = nil 
-- local isPlayerInDelTruck        = nil 
-- local truckTrailer              = nil
-- local Blips                     = {}
-- local ManifestOverallAmountOptions    = {}
-- local ManifestOverallItemOptions = {}

-- local ui                        = false
-- local JOB_STAGE = {
-- 	GETTING_TRUCK               = 1,
-- 	GETTING_TRAILER             = 2,
-- 	GO_TO_FIRST_DELIVERY        = 3,
-- 	GO_TO_SECOND_DELIVERY       = 4
-- }

--     isJobStarted               = true
-- 	jobStage                   = JOB_STAGE["GETTING_TRUCK"]
-- 	local enroute              = false
-- 	local mechPed              = nil
-- 	local playerPos            = Config.PlayerPosition
-- 	local playerPed            = Config.PlayerID
-- 	ModelHash                  = Config.DeliveryTruck


-- function UpdateStatus(message)
-- 	SendNUIMessage({ event = "updateStatus", message = message })
-- end

-- function setBlipForTruckingJob()
-- 	AddTextEntry('TruckingBlip', 'Walker Logistics')
-- 	local truckingJobBlip = AddBlipForCoord(Config.BlipCoordX, Config.BlipCoordY, Config.BlipCoordZ)
-- 	SetBlipSprite(truckingJobBlip, 477) 
-- 	SetBlipColour(truckingJobBlip, 15)
-- 	SetBlipAlpha(truckingJobBlip, 255)
-- 	SetBlipDisplay(truckingJobBlip, 2)
-- 	BeginTextCommandSetBlipName('TruckingBlip')
-- 	AddTextComponentSubstringPlayerName('me')
-- 	EndTextCommandSetBlipName(truckingJobBlip)
-- end



-- function SpawnTrailer()
-- 	local trailerHash = Config.TrailerHash
-- 	if not IsModelInCdimage(trailerHash) then return 
-- 	end
-- 	RequestModel(trailerHash) -- Request the model
-- 	while not HasModelLoaded(trailerHash) do -- Waits for the model to load with a check so it does not get stuck in an infinite loop
-- 	Citizen.Wait(1)
-- 	end
-- 	local playerPed = PlayerPedId()
-- 	local truckTrailer = CreateVehicle(trailerHash, Config.DelTrailerSpawnX, Config.DelTrailerSpawnY, Config.DelTrailerSpawnZ, Config.DelTrailerSpawnH, true, true) -- Spawns a networked vehicle on your current coords
-- 	SetVehicleLivery(truckTrailer, 2)
-- 	SetModelAsNoLongerNeeded(trailerHash)
-- 	--- Spawning in the Trailer ---

-- 	--- Creates dynamic blip for player's trailer ---
-- 	AddTextEntry('DelTrailerBlip', 'Clucking Bell Trailer')
-- 	trailerblip = AddBlipForEntity(truckTrailer)
-- 	SetBlipFlashes(trailerblip, true)
-- 	SetBlipColour(trailerblip, 31)
-- 	SetBlipRoute(trailerblip, true)
-- 	BeginTextCommandSetBlipName('DelTrailerBlip')
-- 	AddTextComponentSubstringPlayerName('me')
-- 	EndTextCommandSetBlipName(trailerblip)
-- end

-- function showAdvancedNotification(message, sender, subject, textureDict, saveToBrief, color)
-- 	BeginTextCommandThefeedPost('STRING')
-- 	AddTextComponentSubstringPlayerName(message)
-- 	ThefeedSetNextPostBackgroundColor(color)
-- 	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
-- 	EndTextCommandThefeedPostTicker(false, saveToBrief)
-- end 

-- function ShowNotification( text )
--     SetNotificationTextEntry("STRING")
--     AddTextComponentSubstringPlayerName(text)
--     DrawNotification(false, false)
-- end

-- --- All Delivery blips used in script ---
-- function DeliveryBlipOne() -- Activates Blimp and Route for CB (Clucking Bell) Delivery Spot One
-- 	AddTextEntry('CBFactoryBlip', 'Clucking Bell Factory')
-- 	CluckingBellFactoryBlip = AddBlipForCoord(46.15, 6301.91, 31.23) -- Clucking Bell Factory in Paleto Bay
-- 	SetBlipColour(CluckingBellFactoryBlip, 31)
-- 	SetBlipRoute(CluckingBellFactoryBlip, true)
-- 	BeginTextCommandSetBlipName('CBFactoryBlip')
-- 	AddTextComponentSubstringPlayerName('me')
-- 	EndTextCommandSetBlipName(CluckingBellFactoryBlip)
-- end

-- function DeliveryBlipTwo() -- Activates Blimp and Route for CB (Clucking Bell) Delivery Two 
-- 	SetBlipDisplay(CluckingBellFactoryBlip, 0)
-- 	AddTextEntry('BurtonStoreBlip', 'Clucking Bell Burton Store')
-- 	CluckingBellBurtonStoreBlip = AddBlipForCoord(-132.16, -264.1, 42.78) -- Clucking Bell Store in Burton
-- 	SetBlipColour(CluckingBellBurtonStoreBlip, 31)
-- 	SetBlipRoute(CluckingBellBurtonStoreBlip, true)
-- 	BeginTextCommandSetBlipName('BurtonStoreBlip')
-- 	AddTextComponentSubstringPlayerName('me')
-- 	EndTextCommandSetBlipName(CluckingBellBurtonStoreBlip)
-- end 

-- function DeliveryBlipThree() -- Activates Blimp and Route for CB (Clucking Bell) Delivery Three
-- 	SetBlipDisplay(CluckingBellBurtonStoreBlip, 0)
-- 	AddTextEntry('StrawberryStoreBlip', 'Clucking Bell Strawberry Store')
-- 	CluckingBellStrawberryStoreBlip = AddBlipForCoord(-176.24, -1436.41, 31.25) -- Clucking Bell Store in Strawberry
-- 	SetBlipColour(CluckingBellStrawberryStoreBlip, 31)
-- 	SetBlipRoute(CluckingBellStrawberryStoreBlip, true)
-- 	BeginTextCommandSetBlipName('StrawberryStoreBlip')
-- 	AddTextComponentSubstringPlayerName('me')
-- 	EndTextCommandSetBlipName(CluckingBellStrawberryStoreBlip)
-- end

-- function TruckingYardBlip() -- Activates Blimp and Route for CB (Clucking Bell) Delivery Three
-- 	SetBlipDisplay(CluckingBellStrawberryStoreBlip, 0)
-- 	AddTextEntry('TruckingYardBlip', 'Truck Yard')
-- 	WalkerLogisticsYard = AddBlipForCoord(Config.BlipCoordX, Config.BlipCoordY, Config.BlipCoordZ) -- Trucking Yard
-- 	SetBlipColour(WalkerLogisticsYard, 31)
-- 	SetBlipRoute(WalkerLogisticsYard, true)
-- 	BeginTextCommandSetBlipName('TruckingYardBlip')
-- 	AddTextComponentSubstringPlayerName('me')
-- 	EndTextCommandSetBlipName(WalkerLogisticsYard)
-- end

-- function setManifest()
-- 	ManifestOverallAmountOptions     = {
-- 		['ManifestAmountOptionOne'] = {
-- 			ItemOne   = 50,
-- 			ItemTwo   = 4000,
-- 			ItemThree = '1000lbs',
-- 			ItemFour  = '1000lbs',
-- 			ItemFive  = '6000lbs',
-- 		},
-- 		['ManifestAmountOptionTwo'] = {
-- 			ItemOne   = 80,
-- 			ItemTwo   = 9000,
-- 			ItemThree = '2000lbs',
-- 			ItemFour  = '900lbs',
-- 			ItemFive  = '6000lbs',
-- 		},
-- 		['ManifestAmountOptionThree'] = {
-- 			ItemOne   = 90,
-- 			ItemTwo   = 1000,
-- 			ItemThree = '9000lbs',
-- 			ItemFour  = '5000lbs',
-- 			ItemFive  = '6000lbs',
-- 		},
-- 		['ManifestAmountOptionFour'] = {
-- 			ItemOne   = 110,
-- 			ItemTwo   = 5000,
-- 			ItemThree = '2000lbs',
-- 			ItemFour  = '2000lbs',
-- 			ItemFive  = '6000lbs',
-- 		}
-- 	}

-- 	ManifestOverallItemOptions     = {
-- 		['ManifestItemOptionOne'] = {
-- 			ItemOne   = 'Pallets of Chicken',
-- 			ItemTwo   = 'Secret Sauce Packets',
-- 			ItemThree = ' of Stuffing',
-- 			ItemFour  = ' of Breading',
-- 			ItemFive  = ' of Cleaning Chemicals',
-- 		},
-- 		['ManifestItemOptionTwo'] = {
-- 			ItemOne   = 'Crates of Raw Chicken',
-- 			ItemTwo   = "Cups and Straws",
-- 			ItemThree = ' of Batter',
-- 			ItemFour  = 'of Breading',
-- 			ItemFive  = 'of Corn Starch',
-- 		},
-- 		['ManifestItemOptionThree'] = {
-- 			ItemOne   = 'Pallets of Chicken Wings',
-- 			ItemTwo   = 'of Frozen Mac & Cheese',
-- 			ItemThree = 'of Breading',
-- 			ItemFour  = 'of Flower',
-- 			ItemFive  = 'Cleaning Chemicals',
-- 		},
-- 		['ManifestItemOptionFour'] = {
-- 			ItemOne   = 'Boxes of Mashed Potatoes',
-- 			ItemTwo   = 'Secret Sauce Packets',
-- 			ItemThree = 'of Stuffing',
-- 			ItemFour  = 'of Breading',
-- 			ItemFive  = 'Cleaning Chemicals',
-- 		}
-- 	}

-- 	local routeOptionNumber = math.random(1,4)
-- 	local ManifestOverallAmountOptionsChoice = nil 
-- 	local ManifestOverallItemOptionsChoice = nil 

-- 	if routeOptionNumber == 1 then 
-- 		ManifestOverallAmountOptionsChoice = 'ManifestAmountOptionOne'
-- 		ManifestOverallItemOptionsChoice = 'ManifestItemOptionOne'
-- 	elseif routeOptionNumber == 2 then 
-- 		ManifestOverallAmountOptionsChoice = 'ManifestAmountOptionTwo'
-- 		ManifestOverallItemOptionsChoice = 'ManifestItemOptiontwo'
-- 	elseif routeOptionNumber == 3 then 
-- 		ManifestOverallAmountOptionsChoice = 'ManifestAmountOptionThree'
-- 		ManifestOverallItemOptionsChoice = 'ManifestItemOptionThree'
-- 	elseif routeOptionNumber == 4 then 
-- 		ManifestOverallAmountOptionsChoice = 'ManifestAmountOptionFour'
-- 		ManifestOverallItemOptionsChoice = 'ManifestItemOptionFour'	
-- 	end 

-- 	SendNUIMessage({ 
-- 		event = "setManifest", 
-- 		message = ManifestOverallAmountOptions[ManifestOverallAmountOptionsChoice].ItemOne .. ' ' .. ManifestOverallAmountOptions[ManifestOverallAmountOptionsChoice].ItemTwo .. ' ' .. ManifestOverallAmountOptions[ManifestOverallAmountOptionsChoice].ItemThree .. ' ' .. ManifestOverallAmountOptions[ManifestOverallAmountOptionsChoice].ItemFour .. ' ' .. ManifestOverallAmountOptions[ManifestOverallAmountOptionsChoice].ItemFive
-- 	})
-- end
-- -- ---------------------------------------------
-- -- -- Registering All Functions as NetEvents ---
-- -- ---------------------------------------------

-- RegisterNetEvent('MidwestTrucking:UpdateStatus')
-- AddEventHandler('MidwestTrucking:UpdateStatus', function()
--     UpdateStatus(message)
-- end)

-- RegisterNetEvent('MidwestTrucking:setBlipForTruckingJob')
-- AddEventHandler('MidwestTrucking:setBlipForTruckingJob', function()
--     setBlipForTruckingJob()
-- end)

-- RegisterNetEvent('MidwestTrucking:SpawnAndDeliverTruck')
-- AddEventHandler('MidwestTrucking:SpawnAndDeliverTruck', function()
--     SpawnAndDeliverTruck()
-- end)

-- RegisterNetEvent('MidwestTrucking:SpawnTrailer')
-- AddEventHandler('MidwestTrucking:SpawnTrailer', function()
--     SpawnTrailer()
-- end)

-- RegisterNetEvent('MidwestTrucking:showAdvancedNotification')
-- AddEventHandler('MidwestTrucking:showAdvancedNotification', function()
--     showAdvancedNotification(message, sender, subject, textureDict, saveToBrief, color)
-- end)

-- RegisterNetEvent('MidwestTrucking:ShowNotification')
-- AddEventHandler('MidwestTrucking:ShowNotification', function()
--     ShowNotification( text )
-- end)

-- RegisterNetEvent('MidwestTrucking:DeliveryBlipOne')
-- AddEventHandler('MidwestTrucking:DeliveryBlipOne', function()
--     DeliveryBlipOne()
-- end)

-- RegisterNetEvent('MidwestTrucking:DeliveryBlipTwo')
-- AddEventHandler('MidwestTrucking:DeliveryBlipTwo', function()
--     DeliveryBlipTwo()
-- end)

-- RegisterNetEvent('MidwestTrucking:DeliveryBlipThree')
-- AddEventHandler('MidwestTrucking:DeliveryBlipThree', function()
--     DeliveryBlipThree()
-- end)

-- RegisterNetEvent('MidwestTrucking:TruckingYardBlip')
-- AddEventHandler('MidwestTrucking:TruckingYardBlip', function()
--     TruckingYardBlip()
-- end)

-- RegisterNetEvent('MidwestTrucking:setManifest')
-- AddEventHandler('MidwestTrucking:setManifest', function()
--     setManifest()
-- end)

