
local QBCore = exports['qb-core']:GetCoreObject()

local Blipy = {}
local JuzBlip = false

CreateThread(function()
    while true do
        Wait(0)
        if not JuzBlip then
            Blipy['car'] = AddBlipForCoord(311.85, -1110.96, 28.4)
            SetBlipSprite(Blipy['car'], 488)
            SetBlipDisplay(Blipy['car'], 4)
            SetBlipScale(Blipy['car'], 0.8)
            SetBlipAsShortRange(Blipy['car'], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Rental')
            EndTextCommandSetBlipName(Blipy['car'])
	    JuzBlip = true
        end
    end
end)

CreateThread(function()
    SpawnNPC()
end)
----------------------------------

SpawnNPC = function()
    CreateThread(function()
        RequestModel(GetHashKey('a_m_m_mexlabor_01'))
        while not HasModelLoaded(GetHashKey('a_m_m_mexlabor_01')) do
            Wait(1)
        end
        CreateNPC()
    end)
end

CreateNPC = function()
    created_ped = CreatePed(5, GetHashKey('a_m_m_mexlabor_01') ,311.85, -1110.96, 28.4, 85.16, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
end


RegisterNetEvent('MenuRental', function(car)
    exports['qb-menu']:openMenu({
        {
            header = "🚘 rental guy",
            isMenuHeader = true
        },
        {
            header = "< rent",
            txt = "futo $3000",
            params = {
                event = "SpawnCar",
                args = {
                    vehicle = "futo",
                }
            }
        },
        {
            header = "< rent",
            txt = "sultan $3000",
            params = {
                event = "SpawnCar",
                args = {
                    vehicle = "sultan",
                }
            }
        },          {
            header = "< Return",
            txt = "Return Vehicle",
            params = {
                event = "DeleteCar",
            }
        },
    })
end)

RegisterNetEvent('DeleteCar', function()
    local car = GetVehiclePedIsIn(PlayerPedId(),true)
    DeleteVehicle(car)
    DeleteEntity(car)
    TriggerEvent('animations:client:EmoteCommandStart', {"keyfob"})
end)

RegisterNetEvent('SpawnCar', function(car, data)
    TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
    QBCore.Functions.Progressbar('SpawnCar', 'geting car ready...', 6000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        TriggerServerEvent('rental:TakeDeposit')
    }, {}, {}, function() -- Play When Done
        local vehicle = car.vehicle
        local coords = { ['x'] = 307.35, ['y'] = -1109.41, ['z'] = 29.35, ['h'] = 179.97 }
        QBCore.Functions.SpawnVehicle(car.vehicle, function(veh)
            SetVehicleNumberPlateText(veh, "rental"..tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, coords.h)
            exports['LegacyFuel']:SetFuel(veh, 80.0)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
            plaquevehicule = GetVehicleNumberPlateText(veh)
        end, coords, true)
       TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        IsDrilling = false
    end, function() -- Play When Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("rental:ReturnDeposit")
    end)
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("23", vector3(311.46, -1110.95, 29.41), 0.55, 0.35,  {
      name = "23",
      heading = 0,
      debugPoly = false,
      minZ=29.51,
      maxZ=30.01,
    }, {
      options = {
        {
          type = "client",
          event = "MenuRental",
          icon = 'fas fa-clipboard',
          label = 'rental board',
        }
      },
      distance = 2.5,
    })
  end)

