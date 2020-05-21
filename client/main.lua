local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local showPlayerId, isScoreboardActive = true, false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(2000)
	ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(connectedPlayers, maxPlayers)
		UpdatePlayerTable(connectedPlayers)

		SendNUIMessage({
			action = 'updateServerInfo',
			maxPlayers = maxPlayers,
			uptime = 'unknown',
			playTime = '00h 00m'
		})
	end)
end)

RegisterNetEvent('esx_scoreboard:updateConnectedPlayers')
AddEventHandler('esx_scoreboard:updateConnectedPlayers', function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
end)

RegisterNetEvent('esx_scoreboard:updatePlayersInQueue')
AddEventHandler('esx_scoreboard:updatePlayersInQueue', function(playersInQueue)
	SendNUIMessage({action = 'updateServerInfo', playersInQueue = playersInQueue})
end)

RegisterNetEvent('esx_scoreboard:updatePing')
AddEventHandler('esx_scoreboard:updatePing', function(connectedPlayers)
	SendNUIMessage({action = 'updatePing', players = connectedPlayers})
end)

RegisterNetEvent('esx_scoreboard:toggleID')
AddEventHandler('esx_scoreboard:toggleID', function(state)
	if state then
		showPlayerId = state
	else
		showPlayerId = not showPlayerId
	end

	SendNUIMessage({action = 'toggleID', state = showPlayerId})
end)

RegisterNetEvent('uptime:tick')
AddEventHandler('uptime:tick', function(uptime)
	SendNUIMessage({action = 'updateServerInfo', uptime = uptime})
end)

function UpdatePlayerTable(connectedPlayers)
	local formattedPlayerList = {}
	local ems, police, taxi, mechanic, cardealer, estate, players = 0, 0, 0, 0, 0, 0, 0

	for k,v in pairs(connectedPlayers) do
		table.insert(formattedPlayerList, ('<tr><td>%s</td><td>%s</td><td>%s</td></tr>'):format(v.name, v.playerId, v.ping))
		players = players + 1

		if v.job == 'ambulance' then
			ems = ems + 1
		elseif v.job == 'police' then
			police = police + 1
		elseif v.job == 'taxi' then
			taxi = taxi + 1
		elseif v.job == 'mechanic' then
			mechanic = mechanic + 1
		elseif v.job == 'cardealer' then
			cardealer = cardealer + 1
		elseif v.job == 'realestateagent' then
			estate = estate + 1
		end
	end

	SendNUIMessage({action = 'updatePlayerList', players = table.concat(formattedPlayerList)})

	SendNUIMessage({
		action = 'updatePlayerJobs',
		jobs = {ems = ems, police = police, taxi = taxi, mechanic = mechanic, cardealer = cardealer, estate = estate, player_count = players}
	})
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() and isScoreboardActive then
		SetNuiFocus(false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, Keys['F10']) then
			ToggleScoreBoard()
			Citizen.Wait(200)
		end
	end
end)

RegisterNUICallback('onCloseMenu', function()
	isScoreboardActive = false
	SetNuiFocus(false)
end)

Citizen.CreateThread(function()
	local playMinute, playHour = 0, 0

	while true do
		Citizen.Wait(60000)
		playMinute = playMinute + 1

		if playMinute == 60 then
			playMinute = 0
			playHour = playHour + 1
		end

		SendNUIMessage({
			action = 'updateServerInfo',
			playTime = string.format("%02dh %02dm", playHour, playMinute)
		})
	end
end)

function ToggleScoreBoard()
	SendNUIMessage({
		action = 'toggle'
	})
end
