-- to show errors. type "/console scriptErrors 1" in wow. turn them off with "/console scriptErrors 0"
-- to run a method while in game. type "/run BGWinRate:HelloWorld()"

local frame = CreateFrame("Frame")

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
frame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
frame:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD")


frame:RegisterEvent("CURSOR_UPDATE") --testing


local addonLoaded = false

-- listen to events: initialize stats and update stats
frame:SetScript("OnEvent", function(__, event, arg1)

	if event == "ADDON_LOADED" and arg1 == "BGWinRate" then
	
		addonLoaded = true
		
		--initialize variables		
		--Alterac Valley
		if (AlteracValleyWins == nil) then AlteracValleyWins = 0; end
		if (AlteracValleyLosses == nil) then AlteracValleyLosses = 0; end
		
		--Warsong Gulch
		if (WarsongGulchWins == nil) then WarsongGulchWins = 0; end
		if (WarsongGulchLosses == nil) then WarsongGulchLosses = 0; end
		
		--Arathi Basin
		if (ArathiBasinWins == nil) then ArathiBasinWins = 0; end
		if (ArathiBasinLosses == nil) then ArathiBasinLosses = 0; end
		
	elseif event == "UPDATE_BATTLEFIELD_STATUS" then
	
		
	elseif event == "UPDATE_BATTLEFIELD_SCORE" then
	
		
		
	elseif event == "UPDATE_ACTIVE_BATTLEFIELD" then
	
		local playerFaction = UnitFactionGroup("player")
		local winningFaction = GetBattlefieldWinner()
		
		if winningFaction == nil then
			
			--print("BGWinRate: error retrieving battleground winner")
			return
			
		end
		
		if winningFaction == 0 then
		
			winningFaction = "Horde"
			
		else
		
			winningFaction = "Alliance"
			
		end
		
		local didWin = winningFaction == playerFaction 
		local zoneName = GetZoneText()
		
		
		
		if didWin then
		
			if zoneName == "Alterac Valley" then
			
				AlteracValleyWins = AlteracValleyWins + 1
				
			elseif zoneName == "Warsong Gulch" then
			
				WarsongGulchWins = WarsongGulchWins + 1
			
			elseif zoneName == "Arathi Basin" then
			
				ArathiBasinWins = ArathiBasinWins + 1
			
			else
			
				--print("error identifying battleground")
			
			end
		
		else
		
			if zoneName == "Alterac Valley" then
			
				AlteracValleyLosses = AlteracValleyLosses + 1
				
			elseif zoneName == "Warsong Gulch" then
			
				WarsongGulchLosses = WarsongGulchLosses + 1
			
			elseif zoneName == "Arathi Basin" then
			
				ArathiBasinLosses = ArathiBasinLosses + 1
			
			else
			
				--print("error identifying battleground")
			
			end
		
		end
	
	elseif event == "CURSOR_UPDATE" then
	
	
	end
	
end);

-- calculate stats

local function winRate(numberOfWins, numberOfGames)

	if numberOfGames == 0 then
		
		return 0
	
	else
	
		local trueWinRate = (numberOfWins / numberOfGames) * 100
		local roundedWinRate = math.floor(trueWinRate + 0.5)
		return roundedWinRate
	
	end
end

local function totalWins()
	
	local totalWins = AlteracValleyWins + WarsongGulchWins + ArathiBasinWins
	return totalWins

end

local function totalLosses()

	local totalLosses = AlteracValleyLosses + WarsongGulchLosses + ArathiBasinLosses
	return totalLosses

end

-- display stats
local function displayArathiBasinWinRate()

	local numberOfArathiBasinGames = ArathiBasinWins + ArathiBasinLosses
	local arathiBasinWinRate = winRate(ArathiBasinWins, numberOfArathiBasinGames)
	print("Arathi Basin" .. "(" .. numberOfArathiBasinGames .. "): " .. arathiBasinWinRate .. "%")
	
end

local function displayAlteracValleyWinRate()

	local numberOfAlteracValleyGames = AlteracValleyWins + AlteracValleyLosses
	local alteracValleyWinRate = winRate(AlteracValleyWins, numberOfAlteracValleyGames)
	print("Alterac Valley" .. "(" .. numberOfAlteracValleyGames .. "): " .. alteracValleyWinRate .. "%")
	
end

local function displayWarsongGulchWinRate()

	local numberOfWarsongGulchGames = WarsongGulchWins + WarsongGulchLosses
	local warsongGulchWinRate = winRate(WarsongGulchWins, numberOfWarsongGulchGames)
	print("Warsong Gulch" .. "(" .. numberOfWarsongGulchGames .. "): " .. warsongGulchWinRate .. "%")
	
end

local function displayTotalWinRate()

	local totalGames = totalWins() + totalLosses()
	local totalWinRate = winRate(totalWins(), totalGames)
	print("All Battlegrounds" .. "(" .. totalGames .. "): " .. totalWinRate .. "%")
	
end

local function displayAllWinRates()

	displayTotalWinRate()
	displayAlteracValleyWinRate()
	displayArathiBasinWinRate()
	displayWarsongGulchWinRate()

end


--user interaction
local function MyAddonCommands(msg, editbox)

	if msg == "" then
		
		displayAllWinRates()
		
	elseif msg == 'bye' then
		print('Goodbye, World!')
	else
		print("BGWinRate - invalid command")
	end
end

SLASH_BGWinRate1 = '/bgwinrate'

SlashCmdList["BGWinRate"] = MyAddonCommands   -- add /hiw and /hellow to command list