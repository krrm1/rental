local QBCore = exports['qb-core']:GetCoreObject()
--------------------------------------------------------------------------------------

RegisterNetEvent('spwanBike:client:spawncycel')
AddEventHandler('spwanBike:client:spawncycel', function()    local ped = PlayerPedId()
    local hash = GetHashKey('bimx')
    if not IsModelInCdimage(hash) then return end
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(10) end
    local vehicle = CreateVehicle(hash, GetEntityCoords(ped), GetEntityHeading(ped), true, false)
    TaskWarpPedIntoVehicle(ped, vehicle, -1)
    SetModelAsNoLongerNeeded(vehicle)
    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
    QBCore.Functions.Notify('you got bike', 'success', 2000)
end)
---------------------------------------------------------------
RegisterNetEvent('spwanBike:client:rentmenu')
AddEventHandler('spwanBike:client:rentmenu', function()
    exports['qb-menu']:openMenu({
        {
            header = "🚲 rent menu",
            isMenuHeader = true
        },
        {
            header = "< rent bike 🚲",
            txt = "",
            params = {
                event = "spwanBike:client:spawncycel"
            }
        },
        {
            header = "< store the bike 🅿",
            txt = "",
            params = {
                event = "spwanBike:client:delbike"
            }
        },
    })
end)

-----------------------------------------------------------------
RegisterNetEvent('spwanBike:client:delbike')
AddEventHandler('spwanBike:client:delbike', function()
    QBCore.Functions.Notify('bike got store', 'success', 5000)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    if veh ~= 0 then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    else
        local pcoords = GetEntityCoords(ped)
        local vehicles = GetGamePool('CVehicle')
        for k, v in pairs(vehicles) do
            if #(pcoords - GetEntityCoords(v)) <= 5.0 then
                SetEntityAsMissionEntity(v, true, true)
                DeleteVehicle(v)
            end
        end
    end
end)
------------------------------------------------------------------
--a_m_m_eastsa_02
exports['berkie-target']:SpawnPed({
    [1] = {
      model = 'a_m_m_eastsa_02',
      coords = vector4(272.96, -612.51, 42.92, 336.58),
      minusOne = true,
      freeze = true,
      invincible = true,
      blockevents = true,
      animDict = 'abigail_mcs_1_concat-0',
      scenario = 'WORLD_HUMAN_AA_COFFEE',
      target = { 
        options = {
          {
            type = "client",
            event = "spwanBike:client:rentmenu",
            icon = 'fas fa-car',
            label = 'rent bike',
          }
        },
        distance = 2.5, 
      },
      currentpednumber = 0, 
    },
    [2] = {
      model = 'a_m_m_eastsa_02',
      coords = vector4(277.05, -614.09, 43.18, 341.07),
      minusOne = true,
      freeze = true,
      invincible = true,
      blockevents = true, 
      animDict = 'abigail_mcs_1_concat-0',
      scenario = 'WORLD_HUMAN_AA_COFFEE',
      target = {
        options = {
          {
            type = "client",
            event = "spwanBike:client:rentmenu",
            icon = 'fas fa-car',
            label = 'rent bike',
          }
        },
        distance = 2.5,
      },
      currentpednumber = 0,
    }
  })