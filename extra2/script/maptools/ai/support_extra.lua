function ResearchAllUniversityTechnologies_Extra(_playerId)

	--AddOn Technologies
	Logic.SetTechnologyState(_playerId,Technologies.GT_Mathematics,3)
	Logic.SetTechnologyState(_playerId,Technologies.GT_Binocular,3)
	Logic.SetTechnologyState(_playerId,Technologies.GT_Matchlock,3)
	Logic.SetTechnologyState(_playerId,Technologies.GT_PulledBarrel,3)

end

----------------------------------------------------------------------------------------
-- Start Countdown
----------------------------------------------------------------------------------------
function MapLocal_StartCountDown(_time)

	GUIQuestTools.ToggleStopWatch(_time, 1)

end


----------------------------------------------------------------------------------------
-- Stop Countdown
----------------------------------------------------------------------------------------
function MapLocal_StopCountDown()

	GUIQuestTools.ToggleStopWatch(0, 0)

end

----------------------------------------------------------------------------------------
-- Set Campaign Flag for Extra campaigns
----------------------------------------------------------------------------------------

function SetGDBFlagForExtraCampaign()
	-- Get map name
	local MapName = Framework.GetCurrentMapName()
	-- Create key
	local KeyName = "Game\\Campaign03\\WonMap_" .. MapName
	-- Set GDB key
	GDB.SetValue( KeyName, 1 )	
end