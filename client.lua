local ESX = nil
local allLicensesClient = {}
local mylicenseClient = {}
local lSelected = {}
local indexMenu = 1
local TypeDispo = {
    [1] = 'drive',
    [2] = 'drive_bike',
    [3] = 'drive_truck'
}

Citizen.CreateThread(function()
    TriggerEvent('esx:getSharedObject', function(lib) ESX = lib end)
    while ESX == nil do Citizen.Wait(100) end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end



local function menuPointLicenses()
    local menuP = RageUI.CreateMenu("Gestions Permis", ' ')
    local menuS = RageUI.CreateSubMenu(menuP, "Gestions Permis", ' ')
    menuP:SetRectangleBanner(11, 11, 11, 1)
    menuS:SetRectangleBanner(11, 11, 11, 1)
    RageUI.Visible(menuP, not RageUI.Visible(menuP))
    while menuP do
        Citizen.Wait(0)
        RageUI.IsVisible(menuP, true, true, true, function()

        if Config.permisdecision == true then 

        for k,v in pairs(allLicensesClient) do
        if v.Type == TypeDispo[1] then
            RageUI.ButtonWithStyle("Nom : "..v.Name, nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    lSelected = v
                end
            end, menuS)
            end
        end

        else
        RageUI.List('Type de permis : ', {'Voiture', 'Moto', 'Camion'}, indexMenu, nil, {}, true, function(Hovered, Active, Selected, Index)
            indexMenu = Index
        end)
            
        for k,v in pairs(allLicensesClient) do
            if v.Type == TypeDispo[indexMenu] then
            RageUI.ButtonWithStyle(v.Name, nil, {RightLabel = v.Point.." Point(s)"}, true, function(Hovered, Active, Selected)
                if Selected then
                    lSelected = v
                end
            end, menuS)
            end
        end
    end
end)

        RageUI.IsVisible(menuS, true, true, true, function()

            RageUI.Separator(lSelected.Name.." - "..lSelected.Point.. " Point(s)")

            if Config.permisdecision == true then 

            RageUI.ButtonWithStyle("Ajouter des points", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local qty = KeyboardInput("Combien de points voulez-vous ajouter ? ", "", 3)
                    TriggerServerEvent('rPermisPoint:addPoint', TypeDispo[1], qty, lSelected.Owner)
                    TriggerServerEvent('rPermisPoint:addPoint', TypeDispo[2], qty, lSelected.Owner)
                    TriggerServerEvent('rPermisPoint:addPoint', TypeDispo[3], qty, lSelected.Owner)
                    RageUI.CloseAll()
                end
            end)

            RageUI.ButtonWithStyle("Retirer des points", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local qty = KeyboardInput("Combien de points voulez-vous retirer ? ", "", 3)
                    TriggerServerEvent('rPermisPoint:removePoint', TypeDispo[1], qty, lSelected.Owner)
                    TriggerServerEvent('rPermisPoint:removePoint', TypeDispo[2], qty, lSelected.Owner)
                    TriggerServerEvent('rPermisPoint:removePoint', TypeDispo[3], qty, lSelected.Owner)
                    RageUI.CloseAll()
                    end
                end) 

            else

            RageUI.ButtonWithStyle("Ajouter des points", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local qty = KeyboardInput("Combien de points voulez-vous ajouter ? ", "", 3)
                    TriggerServerEvent('rPermisPoint:addPoint', lSelected.Type, qty, lSelected.Owner)
                    RageUI.CloseAll()
                end
            end)

            RageUI.ButtonWithStyle("Retirer des points", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local qty = KeyboardInput("Combien de points voulez-vous retirer ? ", "", 3)
                    TriggerServerEvent('rPermisPoint:removePoint', lSelected.Type, qty, lSelected.Owner)
                    RageUI.CloseAll()
                    end
                end)
            end
        end)

        if not RageUI.Visible(menuP) and not RageUI.Visible(menuS) then
            menuP = RMenu:DeleteType("Menu Point", true)
        end
    end
end


local function mespoints()
    local MenuMp = RageUI.CreateMenu("Mes Point(s)", ' ')
    MenuMp:SetRectangleBanner(11, 11, 11, 1)
    RageUI.Visible(MenuMp, not RageUI.Visible(MenuMp))
    while MenuMp do
        Citizen.Wait(0)
        RageUI.IsVisible(MenuMp, true, true, true, function()
            
            if Config.permisdecision == true then 

                for k,v in pairs(mylicenseClient) do
                    if v.Type == TypeDispo[1] then
        
                    RageUI.Separator("Vous avez actuellement : "..v.Point.." points sur votre permis")
        
                    end
                end

            else

            for k,v in pairs(mylicenseClient) do
                if v.Type == TypeDispo[indexMenu] then
    
                RageUI.Separator("Vous avez actuellement : "..v.Point.." points sur votre permis")
    
            end
            end
            
            RageUI.List('Type de permis : ', {'Voiture', 'Moto', 'Camion'}, indexMenu, nil, {}, true, function(Hovered, Active, Selected, Index)
                indexMenu = Index
            end)

            end
        end)

        if not RageUI.Visible(MenuMp) and not RageUI.Visible(menuS) then
            MenuMp = RMenu:DeleteType("Menu Point", true)
        end
    end
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.menuPermisInfo) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == v.jobName then
        local dist = #(plyPos-v.posMenu)
        if dist <= 10.0 then
         Timer = 0
         DrawMarker(22, v.posMenu, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
        end
         if dist <= 3.0 then
            Timer = 0
                RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder à la gestion des permis", time_display = 1 })
            if IsControlJustPressed(1,51) then
local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
if closestPlayer ~= -1 and closestDistance <= 3.0 then
    ESX.TriggerServerCallback('rPermisPoint:getAllLicenses', function(result)
                    allLicensesClient = result
                    menuPointLicenses()
                end, GetPlayerServerId(closestPlayer))
else
    ESX.ShowNotification('Aucun joueurs à proximité')
end
            end
         end
        end
    end
    Citizen.Wait(Timer)
 end
end)

RegisterCommand(Config.cmdplayer, function()
    ESX.TriggerServerCallback('rPermisPoint:getLicenses', function(result)
        mylicenseClient = result
        mespoints()
    end)
end)