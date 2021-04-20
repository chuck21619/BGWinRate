local frame = CreateFrame("Frame")

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD")


local addonLoaded = false

-- listen to events: initialize stats and update stats
frame:SetScript("OnEvent", function(__, event, arg1)

	if event == "ADDON_LOADED" and arg1 == "BGWinRate" then
	
		addonLoaded = true
		--initialize variables		
		--Alterac Valley
		if (BGWinRate_AlteracValleyWins == nil) then BGWinRate_AlteracValleyWins = 0; end
		if (BGWinRate_AlteracValleyLosses == nil) then BGWinRate_AlteracValleyLosses = 0; end
		
		--Warsong Gulch
		if (BGWinRate_WarsongGulchWins == nil) then BGWinRate_WarsongGulchWins = 0; end
		if (BGWinRate_WarsongGulchLosses == nil) then BGWinRate_WarsongGulchLosses = 0; end
		
		--Arathi Basin
		if (BGWinRate_ArathiBasinWins == nil) then BGWinRate_ArathiBasinWins = 0; end
		if (BGWinRate_ArathiBasinLosses == nil) then BGWinRate_ArathiBasinLosses = 0; end
	
	elseif event == "UPDATE_ACTIVE_BATTLEFIELD" then
	
	
		local playerFaction = UnitFactionGroup("player")
		local winningFaction = GetBattlefieldWinner()
		
		if winningFaction == nil then
			
			--print("BGWinRate: error retrieving battleground winner")
			return
			
		end
		
		if BATTLEFIELD_SHUTDOWN_TIMER == 0 then
			
			--this funcion is called again when player leaves the battleground. we only want to trigger it once:
			--which will be when the battleground ends and the shutdown timer should be at 120
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
			
				BGWinRate_AlteracValleyWins = BGWinRate_AlteracValleyWins + 1
				
			elseif zoneName == "Warsong Gulch" then
			
				BGWinRate_WarsongGulchWins = BGWinRate_WarsongGulchWins + 1
			
			elseif zoneName == "Arathi Basin" then
			
				BGWinRate_ArathiBasinWins = BGWinRate_ArathiBasinWins + 1
			
			else
			
				--print("error identifying battleground")
			
			end
		
		else
		
			if zoneName == "Alterac Valley" then
			
				BGWinRate_AlteracValleyLosses = BGWinRate_AlteracValleyLosses + 1
				
			elseif zoneName == "Warsong Gulch" then
			
				BGWinRate_WarsongGulchLosses = BGWinRate_WarsongGulchLosses + 1
			
			elseif zoneName == "Arathi Basin" then
			
				BGWinRate_ArathiBasinLosses = BGWinRate_ArathiBasinLosses + 1
			
			else
			
				--print("error identifying battleground")
			
			end
		
		end
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
	
	local totalWins = BGWinRate_AlteracValleyWins + BGWinRate_WarsongGulchWins + BGWinRate_ArathiBasinWins
	return totalWins

end

local function totalLosses()

	local totalLosses = BGWinRate_AlteracValleyLosses + BGWinRate_WarsongGulchLosses + BGWinRate_ArathiBasinLosses
	return totalLosses

end

-- display stats
local function displayArathiBasinWinRate()

	local numberOfArathiBasinGames = BGWinRate_ArathiBasinWins + BGWinRate_ArathiBasinLosses
	local arathiBasinWinRate = winRate(BGWinRate_ArathiBasinWins, numberOfArathiBasinGames)
	print("Arathi Basin" .. "(" .. numberOfArathiBasinGames .. "): " .. arathiBasinWinRate .. "%")
	
end

local function displayAlteracValleyWinRate()

	local numberOfAlteracValleyGames = BGWinRate_AlteracValleyWins + BGWinRate_AlteracValleyLosses
	local alteracValleyWinRate = winRate(BGWinRate_AlteracValleyWins, numberOfAlteracValleyGames)
	print("Alterac Valley" .. "(" .. numberOfAlteracValleyGames .. "): " .. alteracValleyWinRate .. "%")
	
end

local function displayWarsongGulchWinRate()

	local numberOfWarsongGulchGames = BGWinRate_WarsongGulchWins + BGWinRate_WarsongGulchLosses
	local warsongGulchWinRate = winRate(BGWinRate_WarsongGulchWins, numberOfWarsongGulchGames)
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

	displayAllWinRates()
	
end

SLASH_BGWinRate1 = '/bgwinrate'
SLASH_BGWinRate2 = '/BGWinRate'
SLASH_BGWinRate3 = '/bgwr'
SLASH_BGWinRate4 = '/BGWR'

SlashCmdList["BGWinRate"] = MyAddonCommands