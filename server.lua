local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("ES-Bodycam:server:PlayAudio", function(players, onOff)
    for k, v in pairs(players) do
        TriggerClientEvent("ES-Bodycam:client:PlayAudio", v, onOff)
    end
end)