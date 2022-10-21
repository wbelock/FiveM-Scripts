-- Civ Job Center Menu for MidwestRP Jobs
-- Created by Will B.

-- Defined Vars
dutyStatusMenu = "~r~Off Duty~s~"
local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
currentJob = "noCurrentJob"
dutyStatus = "Off Duty"

-- Creates base menu & Disables the spinning issue
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Job Center", "~b~MidwestRP Job Center")
_menuPool:Add(mainMenu)
_menuPool:MouseControlsEnabled(false)
_menuPool:MouseEdgeEnabled (false)
_menuPool:ControlDisablingEnabled(false)


---------------------------------------------------------
----------------- Start of Menu Tree --------------------
---------------------------------------------------------


-- Section 1 Triggering and Displaying Duty Status
---------------------------------------------------------
function ShowDutyStatusInMenu(menu) -- Menu Item that displays duty status
    menuDutyStatusDisplay = NativeUI.CreateItem("Duty Status", "Shows rather you are on or off duty!")
    menuDutyStatusDisplay:RightLabel("" .. dutyStatusMenu .. "")
    menuDutyStatusDisplay:SetLeftBadge(BadgeStyle.Star)
    menu:AddItem(menuDutyStatusDisplay)
end

function ToggleDutyStatus(menu)
   local toggleStatus = NativeUI.CreateItem("Toggle Duty Status", "Select to toggle status on/off")
   toggleStatus:SetRightBadge(BadgeStyle.Alert)
   menu:AddItem(toggleStatus)
   toggleStatus.Activated = function(sender, item)
        if ( dutyStatus == "Off Duty" ) then
            dutyStatus = "On Duty!"
            dutyStatusMenu = "~g~On Duty~s~"
            menuDutyStatusDisplay:RightLabel("" .. dutyStatusMenu .. "")
            --[[ Outputs what the checkbox state is ]]
            notify(tostring(dutyStatus))
        elseif ( dutyStatus == "On Duty!" ) then
            dutyStatus = "Off Duty"
            dutyStatusMenu = "~r~Off Duty~s~"
            menuDutyStatusDisplay:RightLabel("" .. dutyStatusMenu .. "")
            --[[ Outputs what the checkbox state is ]]
            notify(tostring(dutyStatus))
        end 
   end
end




function DividerItem(menu)
    local divider = NativeUI.CreateItem("                ↓  Select Job Below  ↓", "")
    menu:AddItem(divider)
end   
 

function SecondItem(menu) 
    local submenu1 = _menuPool:AddSubMenu(menu, "~y~Taxi Service") 
    local carItem = NativeUI.CreateItem("Spawn car", "Spawn car in a submenu")
    submenu1:AddItem(carItem)
end


function ThirdItem(menu) 
    local submenu2 = _menuPool:AddSubMenu(menu, "~HC_173~Trash Collection") 
    local carItem = NativeUI.CreateItem("Spawn car", "Spawn car in a submenu")
    submenu2:AddItem(carItem)
end

function FourthItem(menu) 
   local submenu = _menuPool:AddSubMenu(menu, "~r~Walker Logistics ")
   local cluckBellRoute = NativeUI.CreateItem("~y~Clucking Bell Route", "You must be on duty to start this route!")
   local gasStationRoute = NativeUI.CreateItem("~g~24/7 Route", "You must be on duty to start this route!")
   local ronGasRoute = NativeUI.CreateItem("~o~Ron Gas Station Route", "You must be on duty to start this route!")
   _menuPool:MouseControlsEnabled(false)
   _menuPool:MouseEdgeEnabled (false)
   _menuPool:ControlDisablingEnabled(false)



   -------------------------------------------------------------
   -- Function for activating the Clucking Bell Trucking Route--
   -------------------------------------------------------------
   cluckBellRoute.Activated = function(sender, item)
        if ( dutyStatus == "Off Duty" ) then 
            notify("You must be on duty to start a job!")
        elseif ( dutyStatus == "On Duty!" ) then
            if item == cluckBellRoute then
                currentJob = "cluckingBellJob"
                TriggerEvent('UpdateStatus', true)
				isJobStarted = true
                print("Jobstarted Worked")
                -------------------------------------------------------------
                -- Creating the Deliver Load Menu Options for CB Delivery ---
                -------------------------------------------------------------
                local subDividerTwo = NativeUI.CreateItem("             ↓  Press to Deliver Load!  ↓", "") 
                local deliverRouteOne = NativeUI.CreateItem("Deliver Load @ C. Bell Factory", "Press to Deliver!") -- Delivers Load @ Clucking Bell Factory in Paleto Bay
                deliverRouteOne.Activated = function(sender, item)
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    if ( GetDistanceBetweenCoords(plyCoords, 191.46, 6398.83, 31.45, true) < 10.6 ) then -- Coords for CB Factory in Paleto Bay
                        if item == deliverRouteOne then
                            notify("Delivered")
                            DeliveryBlipTwo() -- Sets route for Burton Store 
                        end
                    end 
                end
                local deliverRouteTwo = NativeUI.CreateItem("Deliver Load @ C. Bell Burton Store", "Press to Deliver!") -- Delivers Load @ Clucking Bell Store in Burton
                deliverRouteTwo.Activated = function(sender, item)
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    if ( GetDistanceBetweenCoords(plyCoords, -132.16, -264.1, 42.78, true) < 10.6 ) then
                        if item == deliverRouteTwo then
                            notify("Delivered")
                            DeliveryBlipThree() -- Sets route for Strawberry Store 
                        end
                    end 
                end
                local deliverRouteThree = NativeUI.CreateItem("Deliver Load @ C. Bell Store Strawberry Store", "Press to Deliver!") -- Delivers Load @ Clucking Bell Store in Strawberry
                deliverRouteThree.Activated = function(sender, item)
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    if ( GetDistanceBetweenCoords(plyCoords, -176.24, -1436.41, 31.25, true) < 10.6 ) then
                        if item == deliverRouteThree then
                            notify("Delivered")
                            notify("Return to Yard")
                            TruckingYardBlip() -- Sets Route back to yard
                        end
                    end 
                end
                
                -------------------------------------------------------------
                ----- End of Deliver Load Menu Options for CB Delivery ------
                -------------------------------------------------------
                ---*******************************************************---
                -------------------------------------------------------------
                ----- Adding All Created Sub-Menu Items to Menu -------------
                -------------------------------------------------------------
                submenu:AddItem(subDividerTwo)
                submenu:AddItem(deliverRouteOne)
                submenu:AddItem(deliverRouteTwo)
                submenu:AddItem(deliverRouteThree)
                _menuPool:RefreshIndex() -- look into adding current job to HUD
                print("SET CURRENT JOB TO CB")
                startTruckingJob()
            end
        end 
   end
        
   
   submenu:AddItem(cluckBellRoute)
   submenu:AddItem(gasStationRoute)
   submenu:AddItem(ronGasRoute)
end



ShowDutyStatusInMenu(mainMenu)
ToggleDutyStatus(mainMenu)
DividerItem(mainMenu)
SecondItem(mainMenu)
ThirdItem(mainMenu)
FourthItem(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        _menuPool:ProcessMenus()
        --[[ The "e" button will activate the menu ]]
        if IsControlJustPressed(1, 51) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end