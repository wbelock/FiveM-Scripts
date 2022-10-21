-- Configuration File for MidwestTrucking Script. 
-- Will Belock

----------------------------------------------------------------
----------------------------------------------------------------
--------------- Midwest Roleplay Trucking Job ------------------
-------------------- Written by Will B -------------------------
----------------------------------------------------------------
-------------------- Configuration File ------------------------
----------------------------------------------------------------


Config = {}

-- Configuration for function StartTruckingJob()
Config.DeliveryTruck = 'phantom3'
Config.DelTruckSpawnX = 155.99
Config.DelTruckSpawnY = -2972.69
Config.DelTruckSpawnZ = 5.91
Config.DelTruckSpawnH = 188.51
Config.DeliverDriverPed = 'S_M_M_TRUCKER_01'
Config.PlayerPosition = GetEntityCoords(GetPlayerPed(-1))
Config.PlayerID = PlayerPedId()
Config.TrailerHash = 'trailers2'
Config.DelTrailerSpawnX = -454.83
Config.DelTrailerSpawnY = -2799.19
Config.DelTrailerSpawnZ = 6
Config.DelTrailerSpawnH = 41.19

-- Configuration for Map Blip
Config.BlipCoordX = 175.12
Config.BlipCoordY = -3186.4
Config.BlipCoordZ = 5.62
Config.StopRangeSpot = vector3(173.59, -3201.65, 5.73)

-- Configuration for NPC Truck Delivery
Config.TruckNPCDelSpotX = 165.67
Config.TruckNPCDelSpotY = -3203.56
Config.TruckNPCDelSpotZ = 5.89


Config.Peds = {
	---
  { model="a_f_y_bevhills_01", 
  x=153.07, y=-3212.27, z=5.91, a=9.73,
  anim="amb@world_human_clipboard@male@idle_a", 
  animName="idle_c", -- https://wiki.gtanet.work/index.php?title=Animations
  stoic=true,
  voice=female,
  relationship=nil,
	god=true,
	task=nil},
  ---
}

-- Configuration for Markers used in Script

Config.Markers = {
    ['FemaleDispatch'] = {
        markersOverallCoords = vector3(153.07,-3212.17,7.01), 
        xPos = 153.07,
        yPos = -3212.17,
        zPos = 7.01,
        markerType = 3, -- Type of Marker
        directionX = 0.0,
        directionY = 0.0,
        directionZ = 0.0,
        RotationX = 0.0,
        RotationY = 0.0,
        RotationZ = 0.0,
        scaleX = 2,
        scaleY = 2,
        scaleZ = 2,
        ColorValueRed = 255,
        ColorValueBlue = 128,
        ColorValueGreen = 0,
        ColorValueAlpha = 180,
        DoesMarkerBob = false,
        DoesMarkerFacePlayer = true
    }
}

-- Config for Route Blips
-- Trailer Pickup Locations
Config.DelTrailerBlipX = -376.48
Config.DelTrailerBlipY = -2761.28
Config.DelTrailerBlipZ = 6.07