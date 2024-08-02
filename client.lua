local QBCore = exports['qb-core']:GetCoreObject()
local isOn = false

function GetPlayersWithin2M()
  local playersInRange = {}
  local playerPed = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)

  for _, playerId in ipairs(GetActivePlayers()) do
      local targetPed = GetPlayerPed(playerId)
      local targetCoords = GetEntityCoords(targetPed)
      local distance = #(playerCoords - targetCoords)
      if distance <= 2.0 then
          local serverId = GetPlayerServerId(playerId)
          table.insert(playersInRange, serverId)
      end
  end

  return playersInRange
end

RegisterNetEvent("ES-Bodycam:client:PlayAudio", function(onOff)
  SendNUIMessage({
    type = "playAudio",
    audio = onOff,
  })
end)

RegisterCommand("toggleBodycam", function()
  local Player = QBCore.Functions.GetPlayerData()
  local job = Player.job
  if job.name == "police" then
    local send = GetPlayersWithin2M()

    local ped = PlayerPedId()

    while ( not HasAnimDictLoaded( "clothingtie" ) ) do
        RequestAnimDict( "clothingtie" )
        Citizen.Wait( 0 )
    end

    ClearPedTasks(ped)
    TaskPlayAnim(ped, "clothingtie", "outro", 8.0, 2.0, 1880, 51, 2.0, 0, 0, 0 )

    if isOn then
      SendNUIMessage({
        type = "off",
      })
      isOn = false
      TriggerServerEvent("ES-Bodycam:server:PlayAudio", send, false)
    else
      SendNUIMessage({
        type = "on",
      })
      isOn = true
      TriggerServerEvent("ES-Bodycam:server:PlayAudio", send, true)
    end
  end
end, false)

RegisterKeyMapping('toggleBodycam', 'Turns BodyCam Overlay On / Off', 'keyboard', 'LBRACKET')