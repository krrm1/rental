local QBCore = exports['qb-core']:GetCoreObject()

--- take money for bank or cash form player 
RegisterNetEvent('rental:TakeDeposit', function()
	local _source = source
	local Player = QBCore.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney("bank", 3000,_source, "rent-deposit")
    TriggerClientEvent("QBCore:Notify", _source, "You were charged a deposit of $2500")
end)

--- give money to player to cash or bank
RegisterNetEvent('rental:ReturnDeposit', function(info)
	local _source = source
    local Player = QBCore.Functions.GetPlayer(_source)
        Player.Functions.AddMoney("bank", 3000, "return-vehicle")
        TriggerClientEvent("QBCore:Notify", _source, "You canceled and recieved your deposit back", "success")
end)
