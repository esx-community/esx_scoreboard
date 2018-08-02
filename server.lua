ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




function CountEMS()

	local xPlayers = ESX.GetPlayers()

	EMSConnected = 0
	PoliceConnected = 0
	TaxiConnected = 0
	MekConnected = 0
	BilConnected = 0
	MaklareConnected = 0
	IcaConnected = 0
	PlayerConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		PlayerConnected = PlayerConnected + 1
		if xPlayer.job.name == 'ambulance' then
			EMSConnected = EMSConnected + 1
		end		
		if xPlayer.job.name == 'police' then
			PoliceConnected = PoliceConnected + 1
		end	
		if xPlayer.job.name == 'taxi' then
			TaxiConnected = TaxiConnected + 1
		end
		if xPlayer.job.name == 'mecano' then
			MekConnected = MekConnected + 1
		end
		if xPlayer.job.name == 'cardealer' then
			BilConnected = BilConnected + 1
		end
		if xPlayer.job.name == 'realestateagent' then
			MaklareConnected = MaklareConnected + 1
		end	
		if xPlayer.job.name == 'unicorn' then
			IcaConnected = IcaConnected + 1
		end
	end

		--SetTimeout(2000, CountEMS)
end

ESX.RegisterServerCallback('stadusrp_getJobsOnline', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  CountEMS()
cb(EMSConnected, PoliceConnected, TaxiConnected, MekConnected, BilConnected, MaklareConnected, IcaConnected, PlayerConnected)

end)

